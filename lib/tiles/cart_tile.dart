import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter_app/datas/cart_product.dart';
import 'package:virtual_store_flutter_app/datas/product_data.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  const CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent(){}

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("products").document(cartProduct.category)
          .collection("items").document(cartProduct.pid).get(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent();
            }else{
              return Container(
                height: 70,
                child: CircularProgressIndicator(),
                alignment: AlignmentDirectional.center,
              );
            }
          },
        ) :
          _buildContent()
    );
  }
}