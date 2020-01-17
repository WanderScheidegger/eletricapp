import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Aexecutaror.dart';
import 'EmExecucaoor.dart';
import 'Executadasor.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> itensMenu = ["Logout", "ADM"];
  TextEditingController _dialogController = TextEditingController();
  String _textoAalerta = "Digite a senha de Administrador";
  String _equipeLogado = "";
  String _uid = "";


  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "ADM":
        _displayDialog(context);
        break;
      case "Logout":
        _deslogarUsuario();
        break;
    }
  }

  //ALERT DIALOG
  _displayDialog(BuildContext context) async {
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
                  _admLogin();
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

  _admLogin() {
    String senhaADM = _dialogController.text;
    if (senhaADM == "aneel") {
      setState(() {
        _dialogController.text = "";
      });
      Navigator.pushReplacementNamed(context, "/admor");
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    if (usuarioLogado == null) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
    }
  }

  _adicionarListenerLocalizacao() async{

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      timeInterval: 30000,
    );
    geolocator.getPositionStream( locationOptions )
        .listen((Position position){

      Firestore db = Firestore.instance;
      db.collection("usuarios").document(_equipeLogado).
      updateData({"latitude": position.latitude, "longitude": position.longitude,
        "time": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' - ', H, ':', nn]).toString()})
          .then((onValue){
        print("localizacao atual: " + position.toString());
        print("UID: " + _uid);
      });
    });

  }

  _verificaEquipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eq = "";
    while (eq == "") {
      eq = prefs.getString("uid").split(":")[1];
    }

    setState(() {
      _equipeLogado = eq;
    });

  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _verificaEquipe();
    _adicionarListenerLocalizacao();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _dialogController.text = "";

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ordens de reclamação",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xff9FA8DA),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 2,
          indicatorColor: Colors.white,
          labelColor: Color(0xffffffff),
          labelStyle: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 8,
          ),
          //controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.sort,
                size: 30,
              ),
              text: "A executar",
            ),
            Tab(
              icon: Icon(
                Icons.timer,
                size: 30,
              ),
              text: "Em execução",
            ),
            Tab(
              icon: Icon(
                Icons.done,
                size: 30,
              ),
              text: "Executadas",
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Aexecutaror(),
          EmExecucaoor(),
          Executadasor(),
        ],
      ),
    );
  }
}
