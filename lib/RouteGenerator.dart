import 'package:eletricapp/telas/AdmOR.dart';
import 'package:eletricapp/telas/Cadastro.dart';
import 'package:eletricapp/telas/EditaOR.dart';
import 'package:eletricapp/telas/GeraOrdemOr.dart';
import 'package:eletricapp/telas/Home.dart';
import 'package:eletricapp/telas/LoadPage.dart';
import 'package:eletricapp/telas/Login.dart';
import 'package:eletricapp/telas/VerOrdemOr.dart';
import 'package:flutter/material.dart';


class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case "/loadpage":
        return MaterialPageRoute(builder: (_) => LoadPage());
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/geraordem":
        return MaterialPageRoute(builder: (_) => GeraOrdemOr());
      case "/verordemor":
        return MaterialPageRoute(builder: (_) => VerOrdemOr(args));
      case "/admor":
        return MaterialPageRoute(builder: (_) => AdmOR());
      case "/editaor":
        return MaterialPageRoute(builder: (_) => EditaOR(args));

    }

  }

}