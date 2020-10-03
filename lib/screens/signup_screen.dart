import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store_flutter_app/models/user_model.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _adressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Criar contar"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);
          return  Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome completo",
                  ),
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty) return "Nome inválido!";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || text.length < 6) return "Senha inválida!";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _adressController,
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty) return "Endereço inválida!";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Map<String,dynamic> userData ={
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "adress": _adressController.text,
                        };
                        model.signUp(
                            userData: userData,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail,
                        );
                      }
                    },
                    child: Text(
                      "Criar conta",
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }

  void _onSuccess() {
  }

  void _onFail() {
  }
}
