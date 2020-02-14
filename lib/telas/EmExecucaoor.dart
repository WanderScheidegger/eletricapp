import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eletricapp/model/Ordem.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class EmExecucaoor extends StatefulWidget {
  @override
  _EmExecucaoorState createState() => _EmExecucaoorState();
}

class _EmExecucaoorState extends State<EmExecucaoor> {

  static Firestore db = Firestore.instance;
  static String _equipeLogado = "sem equipe";
  bool _isSemEquipe = true;

  StreamBuilder stream = StreamBuilder(
      stream: db
          .collection("OR")
          .where('status', isEqualTo: "Em execução")
          .snapshots(),

      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Expanded(
              child: Text(
                "Você não tem conexão com a internet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 12,
                  color: Color(0xff311B92),
                ),
              ),
            );
          case ConnectionState.waiting:
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Carregando as ordens...",
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 12,
                      color: Color(0xff311B92),
                    ),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            print("tamanho" + querySnapshot.documents.length.toString());
            var num = 0;
            if (querySnapshot.documents.length == 0) {
              return Card(
                elevation: 8,
                color: Color(0xffBDBDBD),
                borderOnForeground: true,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Você não tem ordens em execução ou houve um erro no carregamento. "
                            "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 12,
                          color: Color(0xff311B92),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {

              return Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, indice) => Divider(
                      color: Color(0xff9E0616),
                      thickness: 0.2,
                    ),
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {
                      //Recupara as ordens
                      List<DocumentSnapshot> ordens = querySnapshot.documents
                          .where((snapshot) =>
                      snapshot.data['matricula'] == _equipeLogado || snapshot.data['parceiro'] == _equipeLogado)
                          .toList();
                      print("ordens:" + ordens.length.toString());
                      num++;
                      if (ordens.length != 0 && indice<ordens.length){
                        DocumentSnapshot item = ordens[indice];

                        Ordem ordem = Ordem();

                        ordem.emissao = item['emissao'];
                        ordem.inicio = item['inicio'];
                        ordem.tempo_atend = item['tempo_atend'];
                        ordem.num_osr = item['num_osr'];
                        ordem.programacao = item['programacao'];
                        ordem.obra = item['obra'];
                        ordem.med_antigo = item['med_antigo'];
                        ordem.med_inst = item['med_inst'];
                        ordem.modulo_cs = item['modulo_cs'];
                        ordem.display = item['display'];
                        ordem.display_retirado = item['display_retirado'];
                        ordem.display_instalado = item['display_instalado'];
                        ordem.cs = item['cs'];
                        ordem.trafo = item['trafo'];
                        ordem.anilha = item['anilha'];
                        ordem.tipo_de_fase = item['tipo_de_fase'];
                        ordem.endereco = item['endereco'];
                        ordem.coord_x = item['coord_x'];
                        ordem.coord_y = item['coord_y'];
                        ordem.tipo_ordem = item['tipo_ordem'];
                        ordem.observacoes = item['observacoes'];
                        ordem.obs_adm = item['obs_adm'];
                        ordem.matricula = item['matricula'];
                        ordem.status = "Atribuída";
                        ordem.uidcriador = item['uidcriador'];
                        ordem.execucao = item['execucao'];
                        ordem.finalizacao = item['finalizacao'];
                        ordem.parceiro = item['parceiro'];

                        return Card(
                          elevation: 8,
                          color: Color(0xffBDBDBD),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "OSR: " + item['num_osr'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff311B92),
                                  ),
                                ),
                                subtitle: Text(
                                  "Obra: " + item['obra'] +
                                      " \n" +
                                      "Prog.: " +
                                      item['programacao'] +
                                      "\n" +
                                      "Tipo: " +
                                      item['tipo_ordem'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff311B92),
                                  ),
                                ),
                                trailing: Text(
                                  "Sit: " +
                                      item['status'] +
                                      "\n" +
                                      "Início: " +
                                      item['inicio'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 10,
                                    color: Color(0xffEE162D),
                                  ),
                                ),
                              ),
                              ButtonTheme.bar(
                                child: ButtonBar(
                                  children: <Widget>[
                                    RaisedButton(
                                        child: Text(
                                          "Finalizar a ordem",
                                          style: TextStyle(
                                            fontFamily: "EDP Preon",
                                            fontSize: 9,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, "/finalizaor",
                                              arguments: ordem);
                                        }),
                                    RaisedButton(
                                        child: Text(
                                          "Rota",
                                          style: TextStyle(
                                            fontFamily: "EDP Preon",
                                            fontSize: 9,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        color: Color(0xff9FA8DA),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        onPressed: () {
                                          //_displayDialog_Ok(context, item);
                                          _displayMapsOption(context, item);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );

                      }else if(ordens.length==0 && num==1){
                        return Card(
                          elevation: 8,
                          color: Color(0xffBDBDBD),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Você não tem ordens em execução ou houve um erro no carregamento. "
                                      "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff311B92),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else{
                        return null;
                      }
                    }),
              );
            }
            break;
        }
      });

  _verificaEquipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eq = "";
    while (eq == "") {
      eq = prefs.getString("uid").split(":")[0];
    }

    setState(() {
      _equipeLogado = eq;
    });
    if (_equipeLogado == "Adm" || _equipeLogado == "sem equipe") {
      setState(() {
        _isSemEquipe = false;
      });
    }else {
      setState(() {
        _isSemEquipe = true;
      });
    }
  }

  //ALERT DIALOG
  static _displayMapsOption(BuildContext context, item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Qual App deseja iniciar a rota?",
              style: TextStyle(
                fontFamily: "EDP Preon",
                fontSize: 12,
                color: Color(0xff008B00),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Google Maps'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _openMaps(item);
                },
              ),
              FlatButton(
                child: Text('Waze'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _openWaze(item);
                },
              ),
            ],
          );
        });
  }

  static _openMaps(item){

    Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    ).then((Position position){

      var Lat = position.latitude;
      var Long = position.longitude;

      launch(
          "https://www.google.com.br/maps/dir/$Lat,$Long/" +
              item['coord_x'] +
              "," +
              item['coord_y']);

    }).timeout(Duration(seconds: 10), onTimeout: () {

    });

  }

  static _openWaze(item){

    Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    ).then((Position position){

      var latIr = item['coord_x'];
      var longIr = item['coord_y'];

      launch(
          "waze://?ll=$latIr%2C$longIr&navigate=yes&zoom=17"
      );

    }).timeout(Duration(seconds: 10), onTimeout: () {

    });

  }

  @override
  void initState() {
    _verificaEquipe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: _isSemEquipe,
            child: stream,
            replacement: Card(
              elevation: 8,
              color: Color(0xffBDBDBD),
              borderOnForeground: true,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Você ainda não foi atribuído a uma equipe. Por favor, entre em contato com a administração.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "EDP Preon",
                        fontSize: 12,
                        color: Color(0xff311B92),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}