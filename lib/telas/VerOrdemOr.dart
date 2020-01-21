import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eletricapp/model/Ordem.dart';
import 'package:flutter/material.dart';

class VerOrdemOr extends StatefulWidget {
  Ordem ordem;
  VerOrdemOr(this.ordem);

  @override
  _VerOrdemOrState createState() => _VerOrdemOrState();
}

class _VerOrdemOrState extends State<VerOrdemOr> {
  static Firestore db = Firestore.instance;
  static String numero;
  var dados;

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OSR nº " + widget.ordem.num_osr,
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
            Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
          },
        ),
        backgroundColor: Color(0xff9FA8DA),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffB5B6B3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    //textos da ordem
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, top: 10),
                      child: Text(
                        "DADOS DO SERVIÇO",
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "DATA DA PROGRAMAÇÃO: " + widget.ordem.programacao,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "TIPO DA ORDEM: " +
                            widget.ordem.tipo_ordem,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "MEDIDOR ANTIGO: " + widget.ordem.med_antigo,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "MODULO CS: " + widget.ordem.modulo_cs,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "DISPLAY: " + widget.ordem.display,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "CS: " + widget.ordem.cs,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "TRAFO: " + widget.ordem.trafo,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "ANILHA: " + widget.ordem.anilha,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "TIPO DE FASE: " + widget.ordem.tipo_de_fase,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "ENDEREÇO: " + widget.ordem.endereco,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "COORDENADA X: " + widget.ordem.coord_x,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "COORDENADA Y: " + widget.ordem.coord_y,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "OBSERVAÇÕES: " + widget.ordem.obs_adm,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "EMISSOR: " + widget.ordem.uidcriador,
                        style: _textStyle(12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
