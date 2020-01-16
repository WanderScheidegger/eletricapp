import 'package:eletricapp/RouteGenerator.dart';
import 'package:eletricapp/telas/Login.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xffC5CAE9),
      accentColor: Color(0xff9FA8DA),
    ),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
  
  
}