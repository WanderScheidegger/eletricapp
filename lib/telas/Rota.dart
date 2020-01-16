import 'package:flutter/material.dart';

class Rota extends StatefulWidget {
  @override
  _RotaState createState() => _RotaState();
}

class _RotaState extends State<Rota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rota a seguir",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
          },
        ),
        backgroundColor: Color(0xff9FA8DA),
      ),


    );
  }
}
