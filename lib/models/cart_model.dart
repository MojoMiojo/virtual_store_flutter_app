import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store_flutter_app/datas/cart_product.dart';
import 'package:virtual_store_flutter_app/models/user_model.dart';

class CartModel extends Model{
  UserModel user;

  CartModel(this.user);

  List<CartProduct> products = [];

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

}