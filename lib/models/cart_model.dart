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