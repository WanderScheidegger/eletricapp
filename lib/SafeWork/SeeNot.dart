import 'package:eletricapp/SafeWork/model/OrdemSt.dart';
import 'package:flutter/material.dart';

class SeeNot extends StatefulWidget {
  OrdemSt ordem;
  SeeNot(this.ordem);

  @override
  _SeeNotState createState() => _SeeNotState();
}

class _SeeNotState extends State<SeeNot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notificação de Pessoas",
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
