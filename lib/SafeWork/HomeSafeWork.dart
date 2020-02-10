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

class _HomeSafeWorkState extends State<HomeSafeWork> with SingleTickerProviderStateMixin{
  TabController _tabController;


  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
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
              title: Text('Pendências'),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/home");
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
          VencidasHsw(),
          TomarCienciaHsw(),
          EmAbertoHsw(),
          FinalizadasHsw(),
        ],
      ),
    );
  }
}
