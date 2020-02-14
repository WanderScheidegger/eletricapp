import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MenuAdm extends StatefulWidget {
  @override
  _MenuAdmState createState() => _MenuAdmState();
}

class _MenuAdmState extends State<MenuAdm> {
  ProgressDialog pr;
  TextEditingController _dialogController = TextEditingController();
  String _textoAalerta = "Digite a senha de Administrador";


  //ALERT DIALOG
  _displayDialog(BuildContext context, String local) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_textoAalerta),
            content: TextField(
              controller: _dialogController,
              obscureText: true,
              decoration: InputDecoration(hintText: ""),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Entrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _admLogin(local);
                },
              ),
              FlatButton(
                child: Text('Cancela'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  //ALERT DIALOG
  _displayDialog_NOk(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              msg,
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


  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
  }

  _admLogin(String local) {
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

    pr.show();
    String senhaADM = _dialogController.text;

    Firestore db = Firestore.instance;
    db.collection('passwords')
        .document('master')
        .get()
        .then((onValue){

      pr.hide();
      print(onValue.data['senha'].toString());


      if (senhaADM == onValue.data['senha'].toString()) {
        setState(() {
          _dialogController.text = "";
        });
        Navigator.pushReplacementNamed(context, local);
      }else{
        _displayDialog_NOk(context, "Senha incorreta, tente novamente.");

      }

    }).timeout(Duration(seconds: 15), onTimeout: () {
      pr.hide();
      _displayDialog_NOk(context, "Tempo excedido!, check sua conexão com a internet e tente novamente");

    });


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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               Container(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Column(
                       children: <Widget>[
                         Row(
                           children: <Widget>[
                             GestureDetector(
                               child: Padding(
                                 padding: EdgeInsets.only(top: 10, right: 10),
                                 child: Image.asset("images/roteirizador.png",
                                     width: 90, height: 90),
                               ),
                               onTap: (){
                                 Navigator.pushNamedAndRemoveUntil(context, "/homeroteiriza", (_) => false);
                               },
                             ),

                           ],
                         ),
                         Row(
                           children: <Widget>[
                             Padding(
                               padding: EdgeInsets.all(5),
                               child: Text(
                                 "Roteiro",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   fontFamily: "EDP Preon",
                                   fontSize: 11,
                                   color: Color(0xff311B92),
                                 ),
                               ),
                             ),
                           ],
                         ),

                         Row(
                           children: <Widget>[
                             GestureDetector(
                               child: Padding(
                                 padding: EdgeInsets.only(top: 10, right: 10),
                                 child: Image.asset("images/pendencia.png",
                                     width: 90, height: 90),
                               ),
                               onTap: (){
                                 Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
                               },
                             ),
                           ],
                         ),
                         Row(
                           children: <Widget>[
                             Padding(
                               padding: EdgeInsets.all(5),
                               child: Text(
                                 "Pendências",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   fontFamily: "EDP Preon",
                                   fontSize: 11,
                                   color: Color(0xff311B92),
                                 ),
                               ),
                             ),
                           ],

                         ),
                       ],
                     ),

                     Column(
                       children: <Widget>[
                         Row(
                           children: <Widget>[
                             GestureDetector(
                               child: Padding(
                                 padding: EdgeInsets.only(top: 10, left: 10),
                                 child: Image.asset("images/ccm.png",
                                     width: 90, height: 90),
                               ),
                               onTap: (){


                               },
                             ),
                           ],
                         ),
                         Row(
                           children: <Widget>[
                             Padding(
                               padding: EdgeInsets.all(5),
                               child: Text(
                                 "CCM",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   fontFamily: "EDP Preon",
                                   fontSize: 11,
                                   color: Color(0xff311B92),
                                 ),
                               ),
                             ),
                           ],
                         ),

                         Row(
                           children: <Widget>[
                             GestureDetector(
                               child: Padding(
                                 padding: EdgeInsets.only(top: 10, left: 10),
                                 child: Image.asset("images/seguranca.png",
                                     width: 90, height: 90),
                               ),
                               onTap: (){
                                 _displayDialog(context, "/homesafework");
                               },
                             ),
                           ],
                         ),
                         Row(
                           children: <Widget>[
                             Padding(
                               padding: EdgeInsets.all(5),
                               child: Text(
                                 "Segurança",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   fontFamily: "EDP Preon",
                                   fontSize: 11,
                                   color: Color(0xff311B92),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ],
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
