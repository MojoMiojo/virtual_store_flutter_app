import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  //usuário atual
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String,dynamic> userData = Map();

  bool isLoading = false;

  void begin(){
    this.isLoading = true;
    notifyListeners();
  }

  void end(){
    this.isLoading = false;
    notifyListeners();
  }

  void signUp({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail})
  {

    begin();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user)async{
      firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      end();
    }).catchError((e){
      onFail();
      print(e);
      end();
    });
  }

  void  signIn()async{
    begin();
    await Future.delayed(Duration(seconds: 3));
    end();
  }

  void signOut() async{
    await _auth.signOut();
    userData=Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(){

  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String,dynamic> userData)async{
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

}