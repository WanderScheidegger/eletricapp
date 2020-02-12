import 'package:eletricapp/SafeWork/EmAbertoHsw.dart';
import 'package:eletricapp/SafeWork/FinalizadasHsw.dart';
import 'package:eletricapp/SafeWork/TomarCienciaHsw.dart';
import 'package:eletricapp/SafeWork/VencidasHsw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeSafeWork extends StatefulWidget {
  @override
  _HomeSafeWorkState createState() => _HomeSafeWorkState();
}

class _HomeSafeWorkState extends State<HomeSafeWork>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
  }

  //CHOICE DIALOG
  _displayDialogChoice(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "Escolha o alvo da notificação.",
                style: _textStyle(14.0),
            ),
            actions: <Widget>[
              RaisedButton(
                  child: Text(
                    "Pessoas",
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 12,
                      color: Color(0xffffffff),
                    ),
                  ),
                  color: Color(0xffEE162D),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(context, "/notificapess", (_) => false);
                  }),
              RaisedButton(
                  child: Text(
                    "Veículos",
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 12,
                      color: Color(0xffffffff),
                    ),
                  ),
                  color: Color(0xffEE162D),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(context, "/notificaveic", (_) => false);
                  }),
            ],
          );
        });
  }

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);

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
          "Segurança do Trabalho",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xffEE162D),
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
              text: "Vencidas",
            ),
            Tab(
              icon: Icon(
                Icons.timer,
                size: 30,
              ),
              text: "Ciência",
            ),
            Tab(
              icon: Icon(
                Icons.done,
                size: 30,
              ),
              text: "Em aberto",
            ),
            Tab(
              icon: Icon(
                Icons.done,
                size: 30,
              ),
              text: "Finalizadas",
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
                  image: AssetImage("images/seguranca.png"),
                  fit: BoxFit.none,
                ),
                color: Colors.white,
              ),
              child: Text(
                '\n\nELETRIC',
                style: TextStyle(
                  color: Color(0xff9E0616),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/almoxarifado.png"),
              ),
              title: Text('Almoxarifado'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/ccm.png"),
              ),
              title: Text('CCM'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/pendencia.png"),
              ),
              title: Text('Pendências'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/home");
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
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
          VencidasHsw(),
          TomarCienciaHsw(),
          EmAbertoHsw(),
          FinalizadasHsw(),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color(0xffEE162D),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              iconSize: 38,
              color: Colors.white,
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, "/notificapess", (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
