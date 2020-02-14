import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/OrdemRot.dart';

class EmexecucaoRot extends StatefulWidget {
  @override
  _EmexecucaoRotState createState() => _EmexecucaoRotState();
}

class _EmexecucaoRotState extends State<EmexecucaoRot> {

  static Firestore db = Firestore.instance;
  static String _equipeLogado = "sem equipe";
  bool _isSemEquipe = true;
  static ProgressDialog pr;
  static TextEditingController _controllerObservacoes = TextEditingController();


  //padrão de TextStyle
  static _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }


  static _tomarCiencia(context, item){

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Gravando...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: _textStyle(12.0),
    );

    pr.show();

    db.collection("roteirizacao")
        .document(item)
        .updateData({"observacoes" : _controllerObservacoes.text })
        .then((onValue){
      pr.hide();

    }).timeout(Duration(seconds: 15), onTimeout: () {
      pr.hide();
      _displayDialog_NOk(context);

    });

  }

  //ALERT DIALOG
  static _displayDialog_NOk(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Erro ao salvar os dados",
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }


  //ALERT DIALOG
  static _showDisplayDialog(BuildContext context, item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(15),
            elevation: 15.0,
            title: Text(
              "Finalizar a notificação",
              style: _textStyle(14.0),
              textAlign: TextAlign.center,
            ),
            content: TextField(
              controller: _controllerObservacoes,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: _textStyle(13.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                hintText: "Preencha as \n "
                    "observações para \n "
                    "finalizar a \n "
                    "notificação.",
                filled: true,
                fillColor: Color(0xffB5B6B3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                  child: Text(
                    "Finalizar",
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 9,
                      color: Color(0xffffffff),
                    ),
                  ),
                  color: Color(0xffEE162D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _tomarCiencia(context, item);
                  }),
              RaisedButton(
                  child: Text(
                    "Cancelar",
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
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  StreamBuilder stream = StreamBuilder(
      stream: db
          .collection("roteirizacao")
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
                  color: Color(0xff008B00),
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
                      color: Color(0xff008B00),
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
                        "Você não tem tarefas em execução ou houve um erro no carregamento. "
                            "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 12,
                          color: Color(0xff008B00),
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

                        OrdemRot ordem = OrdemRot();

                        ordem.emissao = item['emissao'];
                        ordem.inicio = item['inicio'];
                        ordem.tempo_atend = item['tempo_atend'];
                        ordem.num_rot = item['num_rot'];
                        ordem.programacao = item['programacao'];
                        ordem.diagrama = item['diagrama'];
                        ordem.endereco = item['endereco'];
                        ordem.coord_x = item['coord_x'];
                        ordem.coord_y = item['coord_y'];
                        ordem.observacoes = item['observacoes'];
                        ordem.obs_adm = item['obs_adm'];
                        ordem.matricula = item['matricula'];
                        ordem.status = "Atribuída";
                        ordem.uidcriador = item['uidcriador'];
                        ordem.parceiro = item['parceiro'];

                        return Card(
                          elevation: 8,
                          color: Color(0xffBDBDBD),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Número: " + item['num_rot'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff008B00),
                                  ),
                                ),
                                subtitle: Text(
                                  "Diagrama: " + item['diagrama'] +
                                      " \n" +
                                      "Prog.: " +
                                      item['programacao'] +
                                      "\n" +
                                      "Endereço: " +
                                      item['endereco'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff008B00),
                                  ),
                                ),
                                trailing: Text(
                                  "Sit: " +
                                      item['status'],
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
                                        color: Colors.yellow,
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
                                        color: Color(0xff61D800),
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
                                  "Você não tem tarefas em execução ou houve um erro no carregamento. "
                                      "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff008B00),
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
                        color: Color(0xff008B00),
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