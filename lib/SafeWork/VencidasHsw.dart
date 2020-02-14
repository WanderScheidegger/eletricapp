import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/OrdemSt.dart';

class VencidasHsw extends StatefulWidget {
  @override
  _VencidasHswState createState() => _VencidasHswState();
}

class _VencidasHswState extends State<VencidasHsw> {
  static Firestore db = Firestore.instance;
  static String _equipeLogado = "sem equipe";
  bool _isSemEquipe = true;
  static var _hoje = DateTime.now();
  static TextEditingController _controllerObservacoes = TextEditingController();
  static ProgressDialog pr;
  static String _dataFinaliza = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);


  //padrão de TextStyle
  static _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  static _stringToDate(string){
    var lista = string.split("/");
    return DateTime( int.parse(lista[2]), int.parse(lista[1]), int.parse(lista[0]));
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

  //ALERT DIALOG
  static _displayDialogCiencia(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "O notificado ainda não tomou ciência desta notificação. Providencie a cência dos envolvidos",
              style: _textStyle(13.0),
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

    db.collection("OST")
        .document(item)
        .updateData({"em_aberto" : "Não", "zdata_finaliza" : _dataFinaliza, "observacoes" : _controllerObservacoes.text })
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
    }else{
      setState(() {
        _isSemEquipe = true;
      });
    }
  }

  StreamBuilder stream = StreamBuilder(
      stream: db
          .collection("OST")
          .where('em_aberto', isEqualTo: "Sim")
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
                  color: Color(0xff9E0616),
                ),
              ),
            );
          case ConnectionState.waiting:
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Carregando as notificações...",
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 12,
                      color: Color(0xff9E0616),
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
                        "Não há notificações vencidas ou houve um erro no carregamento. "
                            "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 12,
                          color: Color(0xff9E0616),
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
                      (snapshot.data['em_aberto'] == 'Sim' &&
                          ( _hoje.isAfter(_stringToDate(snapshot.data['retorno1']))) ) ||
                          ( _hoje.isAfter(_stringToDate(snapshot.data['retorno2'])) ) ||
                          ( _hoje.isAfter(_stringToDate(snapshot.data['retorno3'])) ) ||
                          ( _hoje.isAfter(_stringToDate(snapshot.data['retorno4'])) ) ||
                          ( _hoje.isAfter(_stringToDate(snapshot.data['retorno5'])) )

                      ).toList();

                      num++;
                      if (ordens.length != 0 && indice<ordens.length){
                        DocumentSnapshot item = ordens[indice];

                        OrdemSt ordem = OrdemSt();
                        ordem.opcao = item["opcao"];
                        ordem.num_ost = item["num_ost"];
                        ordem.nome = item["nome"];
                        ordem.sobrenome = item["sobrenome"];
                        ordem.matricula = item["matricula"];
                        ordem.placa = item["placa"];
                        ordem.setor = item["setor"];
                        ordem.data = item["data"];
                        ordem.data_ciencia = item["data_ciencia"];
                        ordem.em_aberto = item["em_aberto"];
                        ordem.risco1 = item["risco1"];
                        ordem.retorno1 = item["retorno1"];
                        ordem.irregularidade1 = item["irregularidade1"];
                        ordem.acoes1 = item["acoes1"];
                        ordem.risco2 = item["risco2"];
                        ordem.retorno2 = item["retorno2"];
                        ordem.irregularidade2 = item["irregularidade2"];
                        ordem.acoes2 = item["acoes2"];
                        ordem.risco3 = item["risco3"];
                        ordem.retorno3 = item["retorno3"];
                        ordem.irregularidade3 = item["irregularidade3"];
                        ordem.acoes3 = item["acoes3"];
                        ordem.risco4 = item["risco4"];
                        ordem.retorno4 = item["retorno4"];
                        ordem.irregularidade4 = item["irregularidade4"];
                        ordem.acoes4 = item["acoes4"];
                        ordem.risco5 = item["risco5"];
                        ordem.retorno5 = item["retorno5"];
                        ordem.irregularidade5 = item["irregularidade5"];
                        ordem.acoes5 = item["acoes5"];
                        ordem.responsavel = item["responsavel"];
                        ordem.supervisor = item["supervisor"];
                        ordem.matSupervisor = item["matSupervisor"];
                        ordem.ciencia = item["ciencia"];
                        ordem.zdata_finaliza = item["zdata_finaliza"];
                        ordem.observacoes = item["observacoes"];

                        return Card(
                          elevation: 8,
                          color: Color(0xffBDBDBD),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "OST nº: " + item['num_ost'] +"\n" + "Setor: " + item['setor'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff9E0616),
                                  ),
                                ),
                                subtitle: Text(
                                  "Tipo: " + item['opcao']+
                                      " \n" +
                                      "Emissão: " +
                                      item['data'] +
                                      "\n" +
                                      "Notificado: " +
                                      item['nome'] + " " + item['sobrenome'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff9E0616),
                                  ),
                                ),
                                trailing: Text(
                                  "Ciente: " +
                                      item['ciencia'],
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
                                          "Visualizar",
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
                                              context, "/seenot",
                                              arguments: ordem);

                                        }),
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
                                          if (item['ciencia'] == "Sim") {
                                            _showDisplayDialog(
                                                context, item['num_ost']);
                                          }else{
                                            _displayDialogCiencia(context);
                                          }
                                        }),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(ordens.length==0 && num==1) {
                        return Card(
                          elevation: 8,
                          color: Color(0xffBDBDBD),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Não há notificações vencidas ou houve um erro no carregamento. "
                                      "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff9E0616),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        return null;
                      }
                    }),
              );
            }
            break;
        }
      });

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
                      "Ocorreu um erro inesperado. Por favor, entre em contato com a administração.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "EDP Preon",
                        fontSize: 12,
                        color: Color(0xff9E0616),
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