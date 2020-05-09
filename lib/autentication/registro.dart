import 'package:flutter/material.dart';
import 'package:doggo/autentication/autenteicacao.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});


  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //campo de texto state
  String email = '';
  String password = '';
  String nome = '';
  String erro = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        elevation:0.0,
        title: Text('Registrar no Doggo'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Login'),
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
                Text('Email'),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Digite o email' : null,
                    onChanged: (val){
                      setState(() => email = val);
                    }
                ),
                SizedBox(height: 20.0),
                Text('Senha'),
                TextFormField(
                    validator: (val) => val.length < 6 ? 'Digite uma senha com pelo menos uma numero' : null,
                    obscureText: true,
                    onChanged: (val){
                      setState(() => password = val);
                    }
                ),
                //SizedBox(height: 20.0),
                //Text('Nome'),
               // TextFormField(
                //    validator: (val) => val.isEmpty ? 'Digite seu Nome Com a Inicial Maiuscula' : null,
                //    onChanged: (val){
               //       setState(() => nome = val);
               //     }
               // ),
                RaisedButton(
                    color: Colors.white,
                    child: Text(
                      'Cadastro',
                      style: TextStyle(color:Colors.orange[600]),
                    ),
                    onPressed:() async{
                      if(_formKey.currentState.validate()){
                        dynamic result = await _auth.registrarComEmaileSenha(email, password);
                        if (result == null){
                          setState(() => erro = 'Envie um email valido');

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
