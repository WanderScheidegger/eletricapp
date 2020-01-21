import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eletricapp/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  var _fontSizeField = 14.0;

  //controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerSobrenome = TextEditingController();
  TextEditingController _controllerMatricula = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _mensagemErro = "";
  ProgressDialog pr;


  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
  }

  //ALERT DIALOG
  _displayDialog_NOk(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              _mensagemErro,
              style: _textStyle(12.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;

    auth
        .createUserWithEmailAndPassword(
        email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {

          //Salvar dados do usuário
      usuario.uid = firebaseUser.user.uid;

      db
          .collection("usuarios")
          .document(firebaseUser.user.uid)
          .setData(usuario.toMap());
      setState(() {
        _mensagemErro = "Usuário cadastrado com sucesso!";
      });
      pr.hide();
      _displayDialog_NOk(context);
      Navigator.pushReplacementNamed(context, "/loadpage");

    }).catchError((error) {
      setState(() {
        _mensagemErro = "Erro ao cadastrar. Tente novamente.";
      });
      pr.hide();
      _displayDialog_NOk(context);
    }).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {
        _mensagemErro = "Conexão de internet ruim. Tente novamente mais tarde.";
      });
      pr.hide();
      _displayDialog_NOk(context);
    });
  }

  _validarCampos() {

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Cadastrando o usuário...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: _textStyle(12.0),
    );

    String nome = _controllerNome.text;
    String sobrenome = _controllerSobrenome.text;
    String matricula = _controllerMatricula.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.length > 2) {
      if (sobrenome.length > 2) {
        if (email.isNotEmpty && email.contains("@")) {
          if (senha.isNotEmpty && senha.length >= 6) {
            Usuario usuario = Usuario();
            usuario.nome = nome;
            usuario.sobrenome = sobrenome;
            usuario.matricula = matricula;
            usuario.email = email;
            usuario.senha = senha;
            usuario.adm = "não";
            usuario.equipe = "sem equipe";
            usuario.servico = "não atribuído";
            usuario.latitude = "";
            usuario.longitude = "";
            usuario.time = "";


            pr.show();

            _cadastrarUsuario(usuario);
          } else {
            setState(() {
              _mensagemErro = "A senha deve conter mais de 5 caracteres.";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Endereço de e-mail vazio ou incorreto.";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "O sobrenome deve ter mais de 2 caracteres.";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "O nome deve ter mais de 2 caracteres.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastro",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
          },
        ),
        backgroundColor: Color(0xff9FA8DA),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffeeeeee)),
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child:
                  Image.asset("images/logo_eletric.png", width: 157, height: 85),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    //autofocus: true,
                    controller: _controllerNome,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: _fontSizeField,
                      color: Color(0xff311B92),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerSobrenome,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: _fontSizeField,
                      color: Color(0xff311B92),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Sobrenome",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerMatricula,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: _fontSizeField,
                      color: Color(0xff311B92),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Matrícula",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: _fontSizeField,
                      color: Color(0xff311B92),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "EDP Preon",
                    fontSize: _fontSizeField,
                    color: Color(0xff311B92),
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Color(0xffB5B6B3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 17,
                          color: Color(0xffffffff),
                        ),
                      ),
                      color: Color(0xff9FA8DA),
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: _fontSizeField,
                      color: Color(0xff311B92),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
