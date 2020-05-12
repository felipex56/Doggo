import 'package:doggo/autentication/LoginNew.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doggo/autentication/autenteicacao.dart';
import 'package:doggo/autentication/autenticate.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });


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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          backgroundColor: Colors.orange[600].withOpacity(0.0000005),
          elevation:0.0,
          title: Text('Login no Doggo'),
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
      ),
      body: Container(
          decoration: BoxDecoration(color: const Color(0xFFeeeeee)),
          child: Stack(
            children: <Widget>[
              Transform.scale(
              scale: 2.0,
                child: Container(
                  width: 746,
                  height: 746,
                  transform: Matrix4.translationValues(0, -250, 0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.5, 0.21),
                      end: Alignment(0.5, 0.77),
                      colors: [Color(0xffebbd57), Color(0xffeb6e57)],
                    ),
                    shape: BoxShape.circle,
                  ),
              ),
            ),
            Center(
                child: Container(
                  width: 318,
                  height: 530,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                        color: const Color(0xff000000).withOpacity(0.16),
                      )
                    ],
                  ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/img/dogg.png'),
                      Container(
                        width: 272,
                        child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "E-mail",
                            ),
                            validator: (val) => val.isEmpty ? 'Digite o email' : null,
                            onChanged: (val){
                              setState(() => email = val);
                            }
                        ),
                      ),
                      Container(
                        width: 272,
                        child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Nome",
                            ),
                            validator: (val) => val.isEmpty ? 'Digite o seu nome' : null,
                            obscureText: true,
                            onChanged: (val){
                              setState(() => nome = val);
                            }
                        ),
                      ),
                      Container(
                        width: 272,
                        child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Senha",
                            ),
                            validator: (val) => val.length < 6 ? 'Digite uma senha com pelo menos uma numero' : null,
                            obscureText: true,
                            onChanged: (val){
                              setState(() => password = val);
                            }
                        ),
                      ),
                      Container(
                        width: 272,
                        height: 47,
                        child: RaisedButton(
                          onPressed: () async {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid
                            if (_formKey.currentState.validate()) {
                              // Process data.
                              dynamic result = await _auth.createUserWithEmailAndPassword(email, password, nome);
                              if (result == null){
                                setState(() => erro = 'Erro ao fazer Login com esses dados');
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(0, 0.5),
                                end: Alignment(1, 0.5),
                                colors: [Color(0xffebbd57), Color(0xffeb6e57)],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 88.0,
                                  minHeight:
                                  36.0), // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: const Text(
                                'Registrar-se',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),

                      ),
                    ],
                  ),
                )
            )
          )
        ]
      )
     )
    );
  }
}