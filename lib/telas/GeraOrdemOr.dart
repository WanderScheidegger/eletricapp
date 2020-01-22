import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:eletricapp/model/Ordem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:progress_dialog/progress_dialog.dart';

class GeraOrdemOr extends StatefulWidget {
  @override
  _GeraOrdemOrState createState() => _GeraOrdemOrState();
}

class _GeraOrdemOrState extends State<GeraOrdemOr> {
  TextEditingController _programacaoController = TextEditingController();
  TextEditingController _obraController = TextEditingController();
  TextEditingController _med_antigoController = TextEditingController();
  TextEditingController _modulo_csController = TextEditingController();
  TextEditingController _display_retiradoController = TextEditingController();
  TextEditingController _csController = TextEditingController();
  TextEditingController _trafoController = TextEditingController();
  TextEditingController _anilhaController = TextEditingController();
  TextEditingController _tipo_de_faseController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _coord_xController = TextEditingController();
  TextEditingController _coord_yController = TextEditingController();
  TextEditingController _obs_admController = TextEditingController();
  TextEditingController _matriculaController = TextEditingController();
  TextEditingController _parceiroController = TextEditingController();
  String _tipo_ordem = "Tipo da ordem";
  String _dataEmissao = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
  String _num_osr = "";
  String _mensagem = "";
  String _uidcriador = "";
  ProgressDialog pr;

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
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
                  Navigator.pushReplacementNamed(context, "/admor");
                },
              )
            ],
          );
        });
  }

  _displayDialog_NOk(BuildContext context, String _mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_mensagem, style: _textStyle(13.0)),
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

  _validaCampos() {
    if (_programacaoController.text.isNotEmpty &&
        _tipo_ordem != "Tipo da ordem" &&
        _coord_xController.text.isNotEmpty &&
        _coord_yController.text.isNotEmpty) {
      _geraOrdem();
    } else {
      _displayDialog_NOk(
          context,
          "Campos obrigatórios: Data de programação, "
          "Tipo da ordem, coordenadas e matrícula ");
    }
  }

  Future _geraOrdem() async {
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
        await db1.collection("OR").getDocuments().then((value) {
      List<int> listaOrdens = List();
      for (DocumentSnapshot item in value.documents) {
        var dados = item.documentID;

        listaOrdens.add(int.parse(dados));
      }
      var n = listaOrdens.reduce(max) + 1;

      _num_osr = n.toString();

      Ordem ordem = Ordem();
      ordem.emissao = _dataEmissao;
      ordem.inicio = "";
      ordem.tempo_atend = "";
      ordem.num_osr = _num_osr;
      ordem.programacao = _programacaoController.text;
      ordem.obra = _obraController.text;
      ordem.med_antigo = _med_antigoController.text;
      ordem.med_inst = "";
      ordem.modulo_cs = _modulo_csController.text;
      ordem.display_retirado = "";
      ordem.display = _display_retiradoController.text;
      ordem.display_instalado = "";
      ordem.cs = _csController.text;
      ordem.trafo = _trafoController.text;
      ordem.anilha = _anilhaController.text;
      ordem.tipo_de_fase = _tipo_de_faseController.text;
      ordem.endereco = _enderecoController.text;
      ordem.coord_x = _coord_xController.text;
      ordem.coord_y = _coord_yController.text;
      ordem.tipo_ordem = _tipo_ordem;
      ordem.observacoes = "";
      ordem.obs_adm = _obs_admController.text;
      ordem.matricula = _matriculaController.text;
      ordem.status = "Atribuída";
      ordem.uidcriador = _uidcriador;
      ordem.execucao = "";
      ordem.finalizacao = "";

      if (_parceiroController.text.isNotEmpty){
        ordem.parceiro = _parceiroController.text;
      }else{
        ordem.parceiro = "sem parceiro";
      }

      Firestore db2 = Firestore.instance;
      db2
          .collection("OR")
          .document(_num_osr)
          .setData(ordem.toMap())
          .then((onValue) {
        pr.hide();
        _displayDialog_Ok(context, "Ordem criada com sucesso.");
      });
    }).catchError((error) {
      pr.hide();
      if (error.toString() == "Bad state: No element") {
        _num_osr = "1";
        _displayDialog_Ok(
            context, "Primeira ordem cadastrada no banco de dados.");
      } else {
        _num_osr = _dataEmissao;
        _displayDialog_Ok(context, "Erro de conexão, NºOSR = $_num_osr");
      }

      //Salva os dados da ordem
      //--------------------------------------------------------------------
      Ordem ordem = Ordem();
      ordem.emissao = _dataEmissao;
      ordem.inicio = "";
      ordem.tempo_atend = "";
      ordem.num_osr = _num_osr;
      ordem.programacao = _programacaoController.text;
      ordem.obra = _obraController.text;
      ordem.med_antigo = _med_antigoController.text;
      ordem.med_inst = "";
      ordem.modulo_cs = _modulo_csController.text;
      ordem.display_retirado = "";
      ordem.display = _display_retiradoController.text;
      ordem.display_instalado = "";
      ordem.cs = _csController.text;
      ordem.trafo = _trafoController.text;
      ordem.anilha = _anilhaController.text;
      ordem.tipo_de_fase = _tipo_de_faseController.text;
      ordem.endereco = _enderecoController.text;
      ordem.coord_x = _coord_xController.text;
      ordem.coord_y = _coord_yController.text;
      ordem.tipo_ordem = _tipo_ordem;
      ordem.observacoes = "";
      ordem.obs_adm = _obs_admController.text;
      ordem.matricula = _matriculaController.text;
      ordem.status = "Atribuída";
      ordem.uidcriador = _uidcriador;
      ordem.execucao = "";
      ordem.finalizacao = "";

      if (_parceiroController.text.isNotEmpty){
        ordem.parceiro = _parceiroController.text;
      }else{
        ordem.parceiro = "sem parceiro";
      }

      Firestore db2 = Firestore.instance;
      db2
          .collection("OR")
          .document(_num_osr.split("/")[0])
          .setData(ordem.toMap())
          .then((onValue) {
        pr.hide();
        _displayDialog_Ok(context, "Ordem criada com sucesso.");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gerar Ordem",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/admor", (_) => false);
          },
        ),
        backgroundColor: Color(0xff9FA8DA),
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
                    "DADOS DO SERVIÇO",
                    style: _textStyle(15.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _programacaoController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Data de Programação - dd/mm/aaaa",
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
                  child: DropdownButton<String>(
                    elevation: 15,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    hint: Text(
                      _tipo_ordem,
                      style: _textStyle(11.5),
                    ),
                    items: <String>[
                      'Pendência de Display',
                      'Pendência de Módulo',
                      'Pendência Cadastral',
                      "Outros"
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: _textStyle(11.5),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _tipo_ordem = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _obraController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Obra",
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
                    controller: _med_antigoController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Medidor Antigo",
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
                    controller: _modulo_csController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Modulo CS",
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
                    controller: _display_retiradoController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Display",
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
                    controller: _csController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "CS",
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
                    controller: _trafoController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Trafo",
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
                    controller: _anilhaController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Anilha",
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
                    controller: _tipo_de_faseController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Tipo de Fase",
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
                    controller: _enderecoController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Endereço",
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
                    controller: _coord_xController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Coordenada x",
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
                    controller: _coord_yController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Coordenada y",
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
                    controller: _obs_admController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Observações do serviço",
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
                    controller: _matriculaController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Matrícula do executor",
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
                    controller: _parceiroController,
                    keyboardType: TextInputType.text,
                    style: _textStyle(11.5),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Matrícula do parceiro",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Gerar ordem",
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 15,
                          color: Color(0xffffffff),
                        ),
                      ),
                      color: Color(0xff9FA8DA),
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        if (_matriculaController.text.isNotEmpty) {
                          _validaCampos();
                        } else {
                          _displayDialog_NOk(
                              context, "Preencha a matrícula do executor");
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
