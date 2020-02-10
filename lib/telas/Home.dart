import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  TextEditingController _dialogController = TextEditingController();
  String _textoAalerta = "Digite a senha de Administrador";
  String _equipeLogado = "";
  String _uid = "";
  ProgressDialog pr;

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

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/pendencia.png"),
                  fit: BoxFit.none,
                ),
                color: Color(0xff9FA8DA),
              ),
              child: Text(
                '\n\nELETRIC',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/almoxarifado.png"),
              ),
              title: Text('Almoxarifado'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/ccm.png"),
              ),
              title: Text('CCM'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/pendencia.png"),
              ),
              title: Text('Pendências (ADM)'),
              onTap: (){
                Navigator.pop(context);
                _displayDialog(context, "/admor");
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/seguranca.png"),
              ),
              title: Text('Segurança'),
              onTap: (){
                Navigator.pop(context);
                _displayDialog(context, "/homesafework");
              },
            ),
            ListTile(
              leading:Icon(Icons.map),
              title: Text('Mapa'),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, "/rota", (_) => false);

              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: (){
                Navigator.pop(context);
                _deslogarUsuario();

              },
            ),
          ],
        ),
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
