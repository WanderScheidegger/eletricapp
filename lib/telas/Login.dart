import 'package:eletricapp/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var _fontSizeField = 14.0;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  ProgressDialog pr;


  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado != null) {

      Navigator.pushNamedAndRemoveUntil(context, "/menuadm", (_) => false);
    }
  }

  _validarCampos() {

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Efetuando o login...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: _textStyle(12.0),
    );

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length >= 6) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        pr.show();
        _logarUsuario(usuario);
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
  }

  _logarUsuario(Usuario usuario) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
        email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {

          pr.hide();
          Navigator.pushNamedAndRemoveUntil(context, "/loadpage", (_) => false);
    }).catchError((error) {
      pr.hide();
      setState(() {
        print("erro app: " + error.toString());
        _mensagemErro =
        "Erro ao autenticar. Verifique o e-mail e a senha e tente novamente.";
      });
    });
  }


  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffeeeeee)),
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Image.asset("images/logo_eletric.png",
                      width: 128, height: 55),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text(
                    "Eletricidade Comércio e Serviços Ltda EPP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 11,
                      color: Color(0xff311B92),
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
                      fontSize: 14,
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
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "EDP Preon",
                    fontSize: 14,
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
                  padding: EdgeInsets.only(top: 16, bottom: 20),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 16,
                          color: Color(0xffffffff),
                        ),
                      ),
                      color: Color(0xff9FA8DA),
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Sem cadastro? clique aqui!",
                      style: TextStyle(
                        fontFamily: "EDP Preon",
                        fontSize: 16,
                        color: Color(0xff311B92),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/cadastro");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        fontFamily: "EDP Preon",
                        fontSize: _fontSizeField,
                        color: Color(0xff311B92),
                      ),
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
