import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              "Criar conta",
              style: TextStyle(fontSize: 15),
            ),
            textColor: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
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
              decoration: InputDecoration(
                hintText: "Senha",
              ),
              obscureText: true,
              validator: (text){
                // ignore: missing_return
                if(text.isEmpty || text.length < 6) return "Senha inválida!";
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {},
                child: Text(
                  "Esqueci minha senha",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 44,
              child: RaisedButton(
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    
                  }
                },
                child: Text(
                  "Entrar",
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
      ),
    );
  }
}
