import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eletricapp/model/Ordem.dart';
import 'package:flutter/material.dart';

class EditaOR extends StatefulWidget {
  Ordem ordem;
  EditaOR(this.ordem);

  @override
  _EditaORState createState() => _EditaORState();
}

class _EditaORState extends State<EditaOR> {
  static Firestore db = Firestore.instance;
  static String numero;
  var dados;
  var _escolha = "Escolha o campo que deseja modificar";
  var _mensagem = "";

  TextEditingController _campoeditadoController = TextEditingController();

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
  }

  _modificaOrdem(){

    Map<String, String> opcoes = {
      "Data da programação" : "programacao",
      "Medidor antigo" : "med_antigo",
      "Modulo cs" : "modulo_cs",
      "Display" : "display_retirado",
      "Cs" : "cs",
      "Trafo" : "trafo",
      "Anilha" : "anilha",
      "Tipo de fase" : "tipo_de_fase",
      "Endereço" : "endereco",
      "Coordenada x" : "coord_x",
      "Coordenada y" : "coord_y",
      "Observações" : "obs_adm"
    };

    Firestore db = Firestore.instance;
    db.collection("OR").document(widget.ordem.num_osr).
    updateData({opcoes[_escolha]: _campoeditadoController.text})
        .then((onValue){
          _displayDialog_Ok(context, "Dado alterado com sucesso.");

    }).catchError((onError) {

      _displayDialog_NOk(context, "Ocorreu um errro ao salvar o dado.");
      
    }).timeout(Duration(seconds: 15), onTimeout: () {

      _displayDialog_NOk(context, "Tempo limite excedido.");

    });

  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context, String _mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              _mensagem,
                style: _textStyle(13.0)
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

  //ALERT DIALOG
  _displayDialog_NOk(BuildContext context, String _mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              _mensagem,
                style: _textStyle(13.0)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar OSR nº " + widget.ordem.num_osr,
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
            Navigator.pushNamedAndRemoveUntil(context, "/admor", (_) => false);
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
                        "DISPLAY: " + widget.ordem.display_retirado,
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
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DropdownButton<String>(
                        elevation: 15,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        hint: Text(
                          _escolha,
                          style: _textStyle(13.0),
                        ),
                        items: <String>[
                          "Data da programação",
                          "Medidor antigo",
                          "Modulo cs",
                          "Display",
                          "Cs",
                          "Trafo",
                          "Anilha",
                          "Tipo de fase",
                          "Endereço",
                          "Coordenada x",
                          "Coordenada y",
                          "Observações"
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: _textStyle(13.0),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _escolha = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: _campoeditadoController,
                        keyboardType: TextInputType.text,
                        style: _textStyle(11.5),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          hintText: "Digite a alteração",
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
                            "Modificar",
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
                            _modificaOrdem();
                          }),
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
