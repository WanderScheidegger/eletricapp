import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:eletricapp/SafeWork/model/OrdemSt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NotificaPess extends StatefulWidget {
  @override
  _NotificaPessState createState() => _NotificaPessState();
}

class _NotificaPessState extends State<NotificaPess> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _sobreNomeController = TextEditingController();
  TextEditingController _matriculaController = TextEditingController();
  TextEditingController _placaController = TextEditingController();

  TextEditingController _irregularidades1Controller = TextEditingController();
  TextEditingController _acoes1Controller = TextEditingController();
  TextEditingController _irregularidades2Controller = TextEditingController();
  TextEditingController _acoes2Controller = TextEditingController();
  TextEditingController _irregularidades3Controller = TextEditingController();
  TextEditingController _acoes3Controller = TextEditingController();
  TextEditingController _irregularidades4Controller = TextEditingController();
  TextEditingController _acoes4Controller = TextEditingController();
  TextEditingController _irregularidades5Controller = TextEditingController();
  TextEditingController _acoes5Controller = TextEditingController();

  String _setor = "Escolha o setor";
  String _opcao = "Escolha o tipo de notificação";
  String _nomeSupervidor = "";
  String _matriculaSupervisor = "";

  String _potencialRisco1 = "Potencial de risco 1";
  String _dataShow1 = 'Data de retorno';
  String _potencialRisco2 = "Potencial de risco 2";
  String _dataShow2 = 'Data de retorno';
  String _potencialRisco3 = "Potencial de risco 3";
  String _dataShow3 = 'Data de retorno';
  String _potencialRisco4 = "Potencial de risco 4";
  String _dataShow4 = 'Data de retorno';
  String _potencialRisco5 = "Potencial de risco 5";
  String _dataShow5 = 'Data de retorno';

  bool _isVisibleIrregularidades1 = false;
  bool _isVisibleIrregularidades2 = false;
  bool _isVisibleIrregularidades3 = false;
  bool _isVisibleIrregularidades4 = false;
  bool _isVisibleIrregularidades5 = false;
  bool _isVisibleOpcao = false;

  String _textoVisIrregularidade1 = "\n IRREGULARIDADE 1";
  String _textoVisIrregularidade2 = "\n IRREGULARIDADE 2";
  String _textoVisIrregularidade3 = "\n IRREGULARIDADE 3";
  String _textoVisIrregularidade4 = "\n IRREGULARIDADE 4";
  String _textoVisIrregularidade5 = "\n IRREGULARIDADE 5";

  ProgressDialog pr;
  String _uidcriador = "";
  String _num_ost = "";
  String _dataEmissao = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
  String _ciencia = "Não";

  _dataToString(date) {
    var datalist = date.toString().split(" ")[0];
    var datas = datalist.split("-");

    return datas[2] + "/" + datas[1] + "/" + datas[0];
  }

  _checaSuper(){

    Firestore sup = Firestore.instance;
    sup.
    collection("supervisores").
    document(_setor).
    get().
    then((onValue){
      var nome = onValue.data['nome'];
      var sobrenome = onValue.data['sobrenome'];
      var matricula = onValue.data['matricula'];

      setState(() {
        _nomeSupervidor = nome + " " + sobrenome;
        _matriculaSupervisor = matricula;
      });

      _geraNotificacao();

    });

  }


  Future _geraNotificacao() async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Salvando os dados...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: _textStyle(12.0),
    );

    pr.show();
    //checa o usuario conectado
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String uid = usuarioLogado.uid;

    DocumentSnapshot snapshot =
    await db.collection("usuarios").document(uid).get();

    var _nomeCriador = snapshot.data["nome"].toString();
    var _sobreNomeCriador = snapshot.data["sobrenome"].toString();

    setState(() {
      _uidcriador = _nomeCriador + " " + _sobreNomeCriador;
    });
    //--------------------------------------------------------------------------
    //checa o numero da ultima ordem
    Firestore db1 = Firestore.instance;
    QuerySnapshot querySnapshot =
    await db1.collection("OST").getDocuments().then((value) {
      List<int> listaOrdens = List();
      for (DocumentSnapshot item in value.documents) {
        var dados = item.documentID;

        listaOrdens.add(int.parse(dados));
      }
      var n = listaOrdens.reduce(max) + 1;

      _num_ost = n.toString();

      OrdemSt ordem = OrdemSt();
      ordem.opcao = _opcao;
      ordem.num_ost = _num_ost;
      ordem.nome = _nomeController.text;
      ordem.sobrenome = _sobreNomeController.text;
      ordem.matricula = _matriculaController.text;
      ordem.placa = _placaController.text;
      ordem.setor = _setor;
      ordem.data = _dataEmissao;
      ordem.ciencia = _ciencia;
      ordem.data_ciencia = "";
      ordem.em_aberto = "Sim";
      ordem.observacoes = "";
      ordem.zdata_finaliza = "";

      //------------------------------------------------------------------------
      ordem.risco1 = _potencialRisco1;
      ordem.retorno1 = _dataShow1;
      ordem.irregularidade1 = _irregularidades1Controller.text;
      ordem.acoes1 = _acoes1Controller.text;
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades2 && _irregularidades2Controller.text.isNotEmpty) {
        ordem.risco2 = _potencialRisco2;
        ordem.retorno2 = _dataShow2;
        ordem.irregularidade2 = _irregularidades2Controller.text;
        ordem.acoes2 = _acoes2Controller.text;
      }else{
        ordem.risco2 = "";
        ordem.retorno2 = _dataShow1;
        ordem.irregularidade2 = "";
        ordem.acoes2 = "";
      }
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades3 && _irregularidades3Controller.text.isNotEmpty) {
        ordem.risco3 = _potencialRisco3;
        ordem.retorno3 = _dataShow3;
        ordem.irregularidade3 = _irregularidades3Controller.text;
        ordem.acoes3 = _acoes3Controller.text;
      }else{
        ordem.risco3 = "";
        ordem.retorno3 = _dataShow1;
        ordem.irregularidade3 = "";
        ordem.acoes3 = "";
      }
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades4 && _irregularidades4Controller.text.isNotEmpty) {
        ordem.risco4 = _potencialRisco4;
        ordem.retorno4 = _dataShow4;
        ordem.irregularidade4 = _irregularidades4Controller.text;
        ordem.acoes4 = _acoes4Controller.text;
      }else{
        ordem.risco4 = "";
        ordem.retorno4 = _dataShow1;
        ordem.irregularidade4 = "";
        ordem.acoes4 = "";
      }
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades5 && _irregularidades5Controller.text.isNotEmpty) {
        ordem.risco5 = _potencialRisco5;
        ordem.retorno5 = _dataShow5;
        ordem.irregularidade5 = _irregularidades5Controller.text;
        ordem.acoes5 = _acoes5Controller.text;
      }else{
        ordem.risco5 = "";
        ordem.retorno5 = _dataShow1;
        ordem.irregularidade5 = "";
        ordem.acoes5 = "";
      }
      //------------------------------------------------------------------------
      ordem.responsavel = _uidcriador;
      ordem.supervisor = _nomeSupervidor;
      ordem.matSupervisor = _matriculaSupervisor;


      Firestore db2 = Firestore.instance;
      db2
          .collection("OST")
          .document(_num_ost)
          .setData(ordem.toMap())
          .then((onValue) {
        pr.hide();
        _displayDialog_Ok(context, "Notificação criada com sucesso.");
      });
    }).catchError((error) {
      pr.hide();
      if (error.toString() == "Bad state: No element") {
        _num_ost = "1";
        _displayDialog_Ok(
            context, "Primeira notificação cadastrada no banco de dados.");
      } else {
        _num_ost = _dataEmissao;
        _displayDialog_Ok(context, "Erro de conexão, NºOST = $_num_ost");
      }

      //Salva os dados da notificação
      //--------------------------------------------------------------------
      OrdemSt ordem = OrdemSt();
      ordem.opcao = _opcao;
      ordem.num_ost = _num_ost;
      ordem.nome = _nomeController.text;
      ordem.sobrenome = _sobreNomeController.text;
      ordem.matricula = _matriculaController.text;
      ordem.placa = _placaController.text;
      ordem.setor = _setor;
      ordem.data = _dataEmissao;
      ordem.ciencia = _ciencia;
      ordem.data_ciencia = "";
      ordem.em_aberto = "Sim";
      ordem.observacoes = "";
      ordem.zdata_finaliza = "";

      //------------------------------------------------------------------------
      ordem.risco1 = _potencialRisco1;
      ordem.retorno1 = _dataShow1;
      ordem.irregularidade1 = _irregularidades1Controller.text;
      ordem.acoes1 = _acoes1Controller.text;
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades2 && _irregularidades2Controller.text.isNotEmpty) {
        ordem.risco2 = _potencialRisco2;
        ordem.retorno2 = _dataShow2;
        ordem.irregularidade2 = _irregularidades2Controller.text;
        ordem.acoes2 = _acoes2Controller.text;
      }else{
        ordem.risco2 = "";
        ordem.retorno2 = _dataShow1;
        ordem.irregularidade2 = "";
        ordem.acoes2 = "";
      }
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades3 && _irregularidades3Controller.text.isNotEmpty) {
        ordem.risco3 = _potencialRisco3;
        ordem.retorno3 = _dataShow3;
        ordem.irregularidade3 = _irregularidades3Controller.text;
        ordem.acoes3 = _acoes3Controller.text;
      }else{
        ordem.risco3 = "";
        ordem.retorno3 = _dataShow1;
        ordem.irregularidade3 = "";
        ordem.acoes3 = "";
      }
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades4 && _irregularidades4Controller.text.isNotEmpty) {
        ordem.risco4 = _potencialRisco4;
        ordem.retorno4 = _dataShow4;
        ordem.irregularidade4 = _irregularidades4Controller.text;
        ordem.acoes4 = _acoes4Controller.text;
      }else{
        ordem.risco4 = "";
        ordem.retorno4 = _dataShow1;
        ordem.irregularidade4 = "";
        ordem.acoes4 = "";
      }
      //------------------------------------------------------------------------
      if (_isVisibleIrregularidades5 && _irregularidades5Controller.text.isNotEmpty) {
        ordem.risco5 = _potencialRisco5;
        ordem.retorno5 = _dataShow5;
        ordem.irregularidade5 = _irregularidades5Controller.text;
        ordem.acoes5 = _acoes5Controller.text;
      }else{
        ordem.risco5 = "";
        ordem.retorno5 = _dataShow1;
        ordem.irregularidade5 = "";
        ordem.acoes5 = "";
      }
      //------------------------------------------------------------------------
      ordem.responsavel = _uidcriador;
      ordem.supervisor = _nomeSupervidor;
      ordem.matSupervisor = _matriculaSupervisor;


      Firestore db2 = Firestore.instance;
      db2
          .collection("OST")
          .document(_num_ost.split("/")[0])
          .setData(ordem.toMap())
          .then((onValue) {
        pr.hide();
        _displayDialog_Ok(context, "Notificação criada com sucesso.");
      });
    });
  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context, String _erro) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              _erro,
              style: _textStyle(13.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, "/homesafework");
                },
              )
            ],
          );
        });
  }

  //ALERT DIALOG
  _displayDialog_NOk(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Tipo, setor e data de retorno são obrigatórios",
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

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notificação de Pessoas",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/homesafework", (_) => false);
          },
        ),
        backgroundColor: Color(0xffEE162D),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "NOTIFICAÇÃO DE SEGURANÇA",
                    style: _textStyle(15.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "DADOS DO NOTIFICADO",
                    style: _textStyle(14.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _nomeController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(12.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Nome do notificado",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _sobreNomeController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(12.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "sobrenome do notificado",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: _matriculaController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(12.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "matrícula do notificado",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "NOTIFICAÇÃO",
                    style: _textStyle(14.0),
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                  child: DropdownButton<String>(
                    elevation: 20,
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      size: 30,
                    ),
                    hint: Text(
                      _opcao,
                      style: _textStyle(14),
                    ),
                    items: <String>['Veículos', 'Pessoas'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: _textStyle(13.5),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _opcao = value;
                      });

                      if (_opcao == 'Veículos') {
                        setState(() {
                          _isVisibleOpcao = true;
                        });
                      } else {
                        setState(() {
                          _isVisibleOpcao = false;
                        });
                      }
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                  child: Visibility(
                    visible: _isVisibleOpcao,
                    child: TextField(
                      controller: _placaController,
                      keyboardType: TextInputType.text,
                      style: _textStyle(12.5),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Placa do veículo",
                        filled: true,
                        fillColor: Color(0xffB5B6B3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    replacement: Container(),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                  child: DropdownButton<String>(
                    elevation: 20,
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      size: 30,
                    ),
                    hint: Text(
                      _setor,
                      style: _textStyle(14),
                    ),
                    items: <String>[
                      '1-Boa Energia',
                      '2-Pendências',
                      '3-Cadastro',
                      '4-Plantão',
                      '5-Linha Morta CCM',
                      '6-Linha Morta CCM',
                      '7-Linha Viva CCM',
                      '8-Linha Viva BTZero',
                      '9-Linha Morta BTZero',
                      '10-BTZero Ramal',
                      '11-Almoxarifado'
                    ]
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: _textStyle(13.5),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _setor = value;
                      });
                    },
                  ),
                ),

                //------------------ Irregularidade 1 --------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      GestureDetector(
                        child: Text(
                          _textoVisIrregularidade1,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleIrregularidades1 =
                                !_isVisibleIrregularidades1;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleIrregularidades1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 30, right: 30, top: 20),
                              child: DropdownButton<String>(
                                elevation: 20,
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 30,
                                ),
                                hint: Text(
                                  _potencialRisco1,
                                  style: _textStyle(14),
                                ),
                                items: <String>[
                                  '1-Acidente',
                                  '2-Multa',
                                  '3-Paralização',
                                  '4-Acidente + Multa',
                                  '5-Acidente + Paralização',
                                  '6-Acidente + Multa + Paralização',
                                  '7-Multa + Paralização'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: _textStyle(13.5),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _potencialRisco1 = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: RaisedButton(
                                  child: Text(
                                    "Escolha a data",
                                    style: TextStyle(
                                      fontFamily: "EDP Preon",
                                      fontSize: 14,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  color: Color(0xffEE162D),
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2019),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      setState(() {
                                        _dataShow1 = _dataToString(date);
                                      });
                                    });
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                _dataShow1,
                                style: _textStyle(13.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _irregularidades1Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText:
                                      "Descreva as irregularidades apontadas",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _acoes1Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText: "Ação corretiva esperada",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //------------------ Irregularidade 2 --------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      GestureDetector(
                        child: Text(
                          _textoVisIrregularidade2,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleIrregularidades2 =
                                !_isVisibleIrregularidades2;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleIrregularidades2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 30, right: 30, top: 20),
                              child: DropdownButton<String>(
                                elevation: 20,
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 30,
                                ),
                                hint: Text(
                                  _potencialRisco2,
                                  style: _textStyle(14),
                                ),
                                items: <String>[
                                  '1-Acidente',
                                  '2-Multa',
                                  '3-Paralização',
                                  '4-Acidente + Multa',
                                  '5-Acidente + Paralização',
                                  '6-Acidente + Multa + Paralização',
                                  '7-Multa + Paralização'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: _textStyle(13.5),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _potencialRisco2 = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: RaisedButton(
                                  child: Text(
                                    "Escolha a data",
                                    style: TextStyle(
                                      fontFamily: "EDP Preon",
                                      fontSize: 14,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  color: Color(0xffEE162D),
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2019),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      setState(() {
                                        _dataShow2 = _dataToString(date);
                                      });
                                    });
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                _dataShow2,
                                style: _textStyle(13.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _irregularidades2Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText:
                                      "Descreva as irregularidades apontadas",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _acoes2Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText: "Ação corretiva esperada",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //------------------ Irregularidade 3 --------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      GestureDetector(
                        child: Text(
                          _textoVisIrregularidade3,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleIrregularidades3 =
                                !_isVisibleIrregularidades3;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleIrregularidades3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 30, right: 30, top: 20),
                              child: DropdownButton<String>(
                                elevation: 20,
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 30,
                                ),
                                hint: Text(
                                  _potencialRisco3,
                                  style: _textStyle(14),
                                ),
                                items: <String>[
                                  '1-Acidente',
                                  '2-Multa',
                                  '3-Paralização',
                                  '4-Acidente + Multa',
                                  '5-Acidente + Paralização',
                                  '6-Acidente + Multa + Paralização',
                                  '7-Multa + Paralização'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: _textStyle(13.5),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _potencialRisco3 = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: RaisedButton(
                                  child: Text(
                                    "Escolha a data",
                                    style: TextStyle(
                                      fontFamily: "EDP Preon",
                                      fontSize: 14,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  color: Color(0xffEE162D),
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2019),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      setState(() {
                                        _dataShow3 = _dataToString(date);
                                      });
                                    });
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                _dataShow3,
                                style: _textStyle(13.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _irregularidades3Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText:
                                      "Descreva as irregularidades apontadas",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _acoes3Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText: "Ação corretiva esperada",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //------------------ Irregularidade 4 --------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      GestureDetector(
                        child: Text(
                          _textoVisIrregularidade4,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleIrregularidades4 =
                                !_isVisibleIrregularidades4;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleIrregularidades4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 30, right: 30, top: 20),
                              child: DropdownButton<String>(
                                elevation: 20,
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 30,
                                ),
                                hint: Text(
                                  _potencialRisco4,
                                  style: _textStyle(14),
                                ),
                                items: <String>[
                                  '1-Acidente',
                                  '2-Multa',
                                  '3-Paralização',
                                  '4-Acidente + Multa',
                                  '5-Acidente + Paralização',
                                  '6-Acidente + Multa + Paralização',
                                  '7-Multa + Paralização'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: _textStyle(13.5),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _potencialRisco4 = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: RaisedButton(
                                  child: Text(
                                    "Escolha a data",
                                    style: TextStyle(
                                      fontFamily: "EDP Preon",
                                      fontSize: 14,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  color: Color(0xffEE162D),
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2019),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      setState(() {
                                        _dataShow4 = _dataToString(date);
                                      });
                                    });
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                _dataShow4,
                                style: _textStyle(13.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _irregularidades4Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText:
                                      "Descreva as irregularidades apontadas",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _acoes4Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText: "Ação corretiva esperada",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //------------------ Irregularidade 5 --------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      GestureDetector(
                        child: Text(
                          _textoVisIrregularidade5,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleIrregularidades5 =
                                !_isVisibleIrregularidades5;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleIrregularidades5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 30, right: 30, top: 20),
                              child: DropdownButton<String>(
                                elevation: 20,
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 30,
                                ),
                                hint: Text(
                                  _potencialRisco5,
                                  style: _textStyle(14),
                                ),
                                items: <String>[
                                  '1-Acidente',
                                  '2-Multa',
                                  '3-Paralização',
                                  '4-Acidente + Multa',
                                  '5-Acidente + Paralização',
                                  '6-Acidente + Multa + Paralização',
                                  '7-Multa + Paralização'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: _textStyle(13.5),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _potencialRisco5 = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: RaisedButton(
                                  child: Text(
                                    "Escolha a data",
                                    style: TextStyle(
                                      fontFamily: "EDP Preon",
                                      fontSize: 14,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  color: Color(0xffEE162D),
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2019),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      setState(() {
                                        _dataShow5 = _dataToString(date);
                                      });
                                    });
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                _dataShow5,
                                style: _textStyle(13.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _irregularidades5Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText:
                                      "Descreva as irregularidades apontadas",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _acoes5Controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: _textStyle(13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText: "Ação corretiva esperada",
                                  filled: true,
                                  fillColor: Color(0xffB5B6B3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Notificar",
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 14,
                          color: Color(0xffffffff),
                        ),
                      ),
                      color: Color(0xffEE162D),
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        //_checaSuper();
                        if (_dataShow1 != 'Data de retorno' &&
                            _setor != 'Escolha o setor' &&
                            _opcao != "Escolha o tipo de notificação"
                        ){
                          _geraNotificacao();
                        }else{
                          _displayDialog_NOk(context);
                        }

                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
