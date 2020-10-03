import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter_app/screens/home_screen.dart';
import 'package:virtual_store_flutter_app/screens/login_screen.dart';
import 'package:virtual_store_flutter_app/screens/signup_screen.dart';

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
    return MaterialApp(
      title: "Flutter's Clothing",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141)
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      //home: LoginScreen()
      //home: SignUpScreen(),
    );
  }
}
