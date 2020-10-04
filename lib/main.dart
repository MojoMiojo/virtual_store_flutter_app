import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store_flutter_app/models/user_model.dart';
import 'package:virtual_store_flutter_app/screens/home_screen.dart';

import 'models/cart_model.dart';

void main (){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant(
        builder: (context,child,model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: "Flutter's Clothing",
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141)
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
              //home: LoginScreen()
              //home: SignUpScreen(),
            ),
          );
        },
      )
    );
  }
}
