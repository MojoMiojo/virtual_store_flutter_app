import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store_flutter_app/models/cart_model.dart';
import 'package:virtual_store_flutter_app/models/user_model.dart';
import 'package:virtual_store_flutter_app/tiles/cart_tile.dart';
import 'package:virtual_store_flutter_app/widgets/discount_card.dart';

import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho"),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context,child,model){
                int p = model.products.length;
                return Text(
                "${p ?? 0} ${p == 1 ? "ITEM": "ITENS"}",
                  style: TextStyle(
                    fontSize: 17
                  ),
                );
              }
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        // ignore: missing_return
        builder: (context,child,model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if (!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16,),
                  Text("Faça o login para adicionar produtos!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 18),),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>LoginScreen())
                      );
                    },
                  )
                ],
              ),
            );
          }else if(model.products == null || model.products.length == 0){
            return Center(
              child: Text("Nenhum produto no carrinho!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              ),
            );
          }else{
            return ListView(
              children: [
                Column(
                  children: model.products.map((product){
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCard(),
              ],
            );
          }
        }
      ),
    );
  }
}
