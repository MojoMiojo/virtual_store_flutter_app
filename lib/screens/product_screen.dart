import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter_app/datas/cart_product.dart';
import 'package:virtual_store_flutter_app/datas/product_data.dart';
import 'package:virtual_store_flutter_app/models/cart_model.dart';
import 'package:virtual_store_flutter_app/models/user_model.dart';
import 'package:virtual_store_flutter_app/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  _ProductScreenState(this.product);
  String size;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            //Carrosel de imagens
            child: Carousel(
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              //tamanho do ponto
              dotSize: 4.0,
              //espaçamento do ponto
              dotSpacing: 15,
              //cor de fundo do ponto
              dotBgColor: Colors.transparent,
              //cor do ponto
              dotColor: primaryColor,
              //rodar automaticamente
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //linhas
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                color:
                                    s == size ? primaryColor : Colors.grey[500],
                                width: 3,
                              )),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: size != null ? () {
                      if(UserModel.of(context).isLoggedIn()){
                        CartProduct cartProduct = CartProduct();

                        cartProduct.size = size;
                        cartProduct.quantity = 1;
                        cartProduct.pid = product.id;
                        cartProduct.category = product.category;

                        CartModel.of(context).addCartItem(cartProduct);
                      }else{
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>LoginScreen())
                        );
                      }
                    } : null,
                    child: UserModel.of(context).isLoggedIn() ? Text(
                      "Adicionar ao Carrinho",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ) : Text(
                      "Entre para comprar",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
