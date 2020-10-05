import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store_flutter_app/datas/cart_product.dart';
import 'package:virtual_store_flutter_app/models/user_model.dart';

class CartModel extends Model{
  UserModel user;
  bool isLoading = false;

  String cupomCode;
  int discountPercentage = 0;

  CartModel(this.user){
    if(user.isLoggedIn())
      _loadCartItems();
  }

  List<CartProduct> products = [];

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  Future<String> finishOrder()async{
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "products": products.map((cartProduct)=>cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1,
    });

    await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("orders").document(refOrder.documentID).setData({
      "orderId": refOrder.documentID
    });

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    cupomCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductsPrice(){
    double price = 0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }//end getProductsPrice

  double getShipPrice(){
    return 9.99;
  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  void setCupom(String cuponCode, int percent){
    this.cupomCode = cuponCode;
    this.discountPercentage = percent;
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
    .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);
    Firestore.instance.collection("users")
    .document(user.firebaseUser.uid)
    .collection("cart").add(cartProduct.toMap()).then((doc) {
      cartProduct.cid = doc.documentID;
    });
    notifyListeners();
  }//end addCartItem

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).delete();

    products.remove(cartProduct);

    notifyListeners();
  }//end removeCartItem

  void _loadCartItems()async{
    QuerySnapshot query = await Firestore.instance.collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart").getDocuments();
    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
  }

}