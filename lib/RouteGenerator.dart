import 'package:eletricapp/Almoxarifado/Diagrama.dart';
import 'package:eletricapp/Roteirizacao/HomeRoteiriza.dart';
import 'package:eletricapp/SafeWork/FinalizaNotifica.dart';
import 'package:eletricapp/SafeWork/HomeSafeWork.dart';
import 'package:eletricapp/SafeWork/NotificaPess.dart';
import 'package:eletricapp/SafeWork/SeeNot.dart';
import 'package:eletricapp/telas/AdmOR.dart';
import 'package:eletricapp/telas/Cadastro.dart';
import 'package:eletricapp/telas/EditaOR.dart';
import 'package:eletricapp/telas/FinalizarOR.dart';
import 'package:eletricapp/telas/GeraOrdemOr.dart';
import 'package:eletricapp/telas/Home.dart';
import 'package:eletricapp/telas/LoadPage.dart';
import 'package:eletricapp/telas/Login.dart';
import 'package:eletricapp/telas/MenuAdm.dart';
import 'package:eletricapp/telas/ModificaUsuario.dart';
import 'package:eletricapp/telas/Rota.dart';
import 'package:eletricapp/telas/TrackOR.dart';
import 'package:eletricapp/telas/VerOrdemOr.dart';
import 'package:eletricapp/telas/VerOrdemOrFin.dart';
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
      case "/verordemorfim":
        return MaterialPageRoute(builder: (_) => VerOrdemOrFin(args));
      case "/admor":
        return MaterialPageRoute(builder: (_) => AdmOR());
      case "/menuadm":
        return MaterialPageRoute(builder: (_) => MenuAdm());
      case "/editaor":
        return MaterialPageRoute(builder: (_) => EditaOR(args));
      case "/modificausuario":
      return MaterialPageRoute(builder: (_) => MOdificaUsuario(args));
      case "/trackor":
        return MaterialPageRoute(builder: (_) => TrackOR());
      case "/finalizaor":
        return MaterialPageRoute(builder: (_) => FinalizarOR(args));
      case "/rota":
        return MaterialPageRoute(builder: (_) => Rota());
        //----------------------------------------------------------------------
      case "/diagrama":
        return MaterialPageRoute(builder: (_) => Diagrama());

        //------------------ Segurança do trabalho -----------------------------
      case "/homesafework":
        return MaterialPageRoute(builder: (_) => HomeSafeWork());

      case "/finalizanotifica":
        return MaterialPageRoute(builder: (_) => FinalizaNotifica(args));
      case "/notificapess":
        return MaterialPageRoute(builder: (_) => NotificaPess());
      case "/seenot":
        return MaterialPageRoute(builder: (_) => SeeNot(args));

        //------------------------ Roteirizador---------------------------------
      case "/homeroteiriza":
        return MaterialPageRoute(builder: (_) => HomeRoteiriza());

    }

  }

}