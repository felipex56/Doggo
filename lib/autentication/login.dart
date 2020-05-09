import 'package:doggo/autentication/autenteicacao.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});



  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //campo de texto state
  String email = '';
  String password = '';
  String erro = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
          backgroundColor: Colors.orange[600],
          elevation:0.0,
          title: Text('Login no Doggo'),
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Register'),
                onPressed:(){
                  widget.toggleView();
                },
               )
          ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                  validator: (val) => val.isEmpty ? 'Digite o email' : null,
                  onChanged: (val){
                    setState(() => email = val);
                  }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  validator: (val) => val.length < 6 ? 'Digite uma senha com pelo menos uma numero' : null,
                  obscureText: true,
                  onChanged: (val){
                    setState(() => password = val);
                  }
              ),
              RaisedButton(
                color: Colors.white,
                child: Text(
                  'Sign in',
                  style: TextStyle(color:Colors.orange[600]),
                ),
                onPressed:() async{
                  if(_formKey.currentState.validate()){
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null){
                      setState(() => erro = 'Erro ao fazer Login com esses dados');
                    }
                  }
                }
              ),
              SizedBox(height: 12.0,),
              Text(
                erro,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )

            ],
          ),
        )
      ),
    );
  }
}
