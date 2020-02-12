import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/OrdemSt.dart';

class EmAbertoHsw extends StatefulWidget {
  @override
  _EmAbertoHswState createState() => _EmAbertoHswState();
}

class _EmAbertoHswState extends State<EmAbertoHsw> {
  static Firestore db = Firestore.instance;
  static String _equipeLogado = "sem equipe";
  bool _isSemEquipe = true;

  //padrão de TextStyle
  static _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
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
                        "Não há notificações em aberto ou houve um erro no carregamento. "
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
                      snapshot.data['ciencia'] == 'Sim')
                          .toList();

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
                                  "Retorno: " +
                                      item['retorno1'],
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
                                  "Não há notificações em aberto ou houve um erro no carregamento. "
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