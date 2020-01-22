import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eletricapp/model/Ordem.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdmExecutadasor extends StatefulWidget {
  @override
  _AdmExecutadasorState createState() => _AdmExecutadasorState();
}

class _AdmExecutadasorState extends State<AdmExecutadasor> {
  static Firestore db = Firestore.instance;
  static String _equipeLogado = "sem equipe";
  bool _isSemEquipe = true;

  StreamBuilder stream = StreamBuilder(
      stream: db
          .collection("OR")
          .where('status', isEqualTo: "Finalizada")
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
            var num = 0;
            if (querySnapshot.documents.length == 0) {
              return Card(
                elevation: 8,
                color: Color(0xffB5B6B3),
                borderOnForeground: true,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Você não tem ordens finalizadas ou houve um erro no carregamento. "
                        "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 12,
                          color: Color(0xff000000),
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
                      List<DocumentSnapshot> ordens =
                      querySnapshot.documents.toList();
                      DocumentSnapshot item = ordens[indice];

                      num++;
                      if (ordens.length != 0 && indice < ordens.length) {
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

                        return Card(
                          elevation: 8,
                          color: Color(0xffB5B6B3),
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
                                  "Obra: " +
                                      item['obra'] +
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
                                      "Finalizada: " +
                                      item['finalizacao'],
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
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, "/verordemor",
                                              arguments: ordem);
                                        }),
                                    RaisedButton(
                                        child: Text(
                                          "Deletar",
                                          style: TextStyle(
                                            fontFamily: "EDP Preon",
                                            fontSize: 9,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        color: Color(0xffEE162D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        onPressed: () {
                                          _displayDialog_Ok(context, item);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (ordens.length == 0 && num == 1) {
                        return Card(
                          elevation: 8,
                          color: Color(0xffB5B6B3),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Você não tem ordens finalizadas ou houve um erro no carregamento. "
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
    } else {
      setState(() {
        _isSemEquipe = true;
      });
    }
  }

  //ALERT DIALOG
  static _displayDialog_Ok(BuildContext context, item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Tem certeza que deseja deletar a ordem? Todos os dados serão perdidos",
              style: TextStyle(
                fontFamily: "EDP Preon",
                fontSize: 12,
                color: Color(0xff311B92),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Deletar'),
                onPressed: () async {
                  await db.collection('OR').document(item.documentID).delete();

                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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
              color: Color(0xffB5B6B3),
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
