import 'package:eletricapp/SafeWork/model/OrdemSt.dart';
import 'package:flutter/material.dart';

class FinalizaNotifica extends StatefulWidget {
  OrdemSt ordem;
  FinalizaNotifica(this.ordem);

  @override
  _FinalizaNotificaState createState() => _FinalizaNotificaState();
}

class _FinalizaNotificaState extends State<FinalizaNotifica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Finaliza OST nº ",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/homesafework", (_) => false);
          },
        ),
        backgroundColor: Color(0xffEE162D),
      ),




    );
  }
}
