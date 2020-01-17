import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eletricapp/model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MOdificaUsuario extends StatefulWidget {
  Usuario usuario;
  MOdificaUsuario(this.usuario);

  @override
  _MOdificaUsuarioState createState() => _MOdificaUsuarioState();
}

class _MOdificaUsuarioState extends State<MOdificaUsuario> {
  String _selectedItemServico;
  String _selectedItemAdm = "";
  String _selectedEquipe = "";
  ProgressDialog pr;

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
  }

  _modificaCampos(){

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
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

    //salva os dados
    Firestore db = Firestore.instance;
    var novo_servico = _selectedItemServico;
    var nova_equipe = _selectedEquipe;
    var novo_adm = _selectedItemAdm;

    if (_selectedItemServico=="" || _selectedItemServico == null){
    novo_servico = widget.usuario.equipe;
    }else{
      novo_servico = _selectedItemServico;
    }

    if (_selectedEquipe == "" || _selectedEquipe == null){
      nova_equipe = widget.usuario.equipe;
    }else{
      nova_equipe = _selectedEquipe;
    }

    if (_selectedItemAdm=="" || _selectedItemAdm == null){
      novo_adm = widget.usuario.adm;
    }else{
      novo_adm = _selectedItemAdm;
    }

    db.collection("usuarios")
        .document(widget.usuario.uid)
        .updateData({"servico" : novo_servico, "equipe" : nova_equipe, "adm" : novo_adm })
        .then((onValue){
          pr.hide();
          _displayDialog_Ok(context);

    }).timeout(Duration(seconds: 15), onTimeout: () {
      pr.hide();
      _displayDialog_NOk(context);

    });

  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Dados Salvos com sucesso",
              style: _textStyle(12.0),
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
  _displayDialog_NOk(BuildContext context) async {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.usuario.nome,
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xff9FA8DA),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 100),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Sobrenome: " + widget.usuario.sobrenome,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 14,
                      color: Color(0xff311B92),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Matrícula: " + widget.usuario.matricula,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 14,
                      color: Color(0xff311B92),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "E-mail: " + widget.usuario.email,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 14,
                      color: Color(0xff311B92),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 1, right: 5),
                      child: Text(
                        "Equipe: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 14,
                          color: Color(0xff311B92),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: DropdownButton<String>(
                        elevation: 15,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        hint: Text(
                          widget.usuario.equipe,
                          style: TextStyle(
                            fontFamily: "EDP Preon",
                            fontSize: 14,
                            color: Color(0xff311B92),
                          ),
                        ),
                        items: <String>["sem equipe", "equipe 1", "equipe 2"]
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(
                                fontFamily: "EDP Preon",
                                fontSize: 14,
                                color: Color(0xff311B92),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.usuario.equipe = value;
                            _selectedEquipe = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 1, right: 5),
                      child: Text(
                        "Serviço: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 14,
                          color: Color(0xff311B92),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: DropdownButton<String>(
                        elevation: 15,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        hint: Text(
                          widget.usuario.servico,
                          style: TextStyle(
                            fontFamily: "EDP Preon",
                            fontSize: 14,
                            color: Color(0xff311B92),
                          ),
                        ),
                        items: <String>["OR", "outros"]
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(
                                fontFamily: "EDP Preon",
                                fontSize: 14,
                                color: Color(0xff311B92),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.usuario.servico = value;
                            _selectedItemServico = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 1, right: 20),
                      child: Text(
                        "ADM: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 14,
                          color: Color(0xff311B92),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: DropdownButton<String>(
                        elevation: 15,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        hint: Text(
                          widget.usuario.adm,
                          style: TextStyle(
                            fontFamily: "EDP Preon",
                            fontSize: 14,
                            color: Color(0xff311B92),
                          ),
                        ),
                        items: <String>['não', 'sim']
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(
                                fontFamily: "EDP Preon",
                                fontSize: 14,
                                color: Color(0xff311B92),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.usuario.adm = value;
                            _selectedItemAdm = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: RaisedButton(
                          child: Text(
                            "Atribuir",
                            style: TextStyle(
                              fontFamily: "EDP Preon",
                              fontSize: 15,
                              color: Color(0xffffffff),
                            ),
                          ),
                          color: Color(0xff9FA8DA),
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            _modificaCampos();
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
