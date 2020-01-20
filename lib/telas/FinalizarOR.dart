import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:eletricapp/model/Ordem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FinalizarOR extends StatefulWidget {
  Ordem ordem;
  FinalizarOR(this.ordem);

  @override
  _FinalizarORState createState() => _FinalizarORState();
}

class _FinalizarORState extends State<FinalizarOR> {
  String _textoVisOrdem = "Visualizar os dados da ordem";
  String _textoVisMedidor = "\n Clique aqui para editar MEDIDOR \n";
  String _textoVisDisplayInst =
      "\n Clique aqui para editar DISPLAY INSTALADO \n";
  String _textoVisDisplayRet = "\n Clique aqui para editar DISPLAY RETIRADO \n";
  String _hintStatusExec = "";

  TextEditingController _controllerMedInst = TextEditingController();
  TextEditingController _controllerDisplayInst = TextEditingController();
  TextEditingController _controllerDisplayRet = TextEditingController();
  TextEditingController _controllerObs = TextEditingController();

  bool _isVisibleOrdem = false;
  bool _isVisibleMedidor = false;
  bool _isVisibleDisplayInst = false;
  bool _isVisibleDisplayRet = false;

  Color _coriconexec = Colors.white;
  Color _coriconparc = Colors.white;
  Color _coriconcanc = Colors.white;

  var display_retirado;
  var display_instalado;
  var med_inst;

  ProgressDialog pr;

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff311B92),
    );
  }

  Widget _insertTextField(controller, hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        style: _textStyle(12.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
          filled: true,
          fillColor: Color(0xffB5B6B3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context, mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              mensagem,
              style: _textStyle(14.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('REVISAR'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Salvar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _finalizaOrdem();
                },
              ),
            ],
          );
        });
  }

  //ALERT DIALOG
  _displayDialog_NOk(BuildContext context, mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              mensagem,
              style: _textStyle(14.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //ALERT DIALOG
  _displayDialog_Final(BuildContext context, mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              mensagem,
              style: _textStyle(14.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, "/home");
                },
              ),
            ],
          );
        });
  }

  _testarPreenchimento() {
    if (_hintStatusExec == "") {
      _displayDialog_NOk(context, "Marque um status de execução");
    } else if (_controllerObs.text.isEmpty) {
      _displayDialog_NOk(
          context, "Preencha o campo observações, ele é obrigatório");
    } else if (widget.ordem.tipo_ordem == 'Pendência de Módulo' &&
        _controllerMedInst.text.isEmpty) {
      _displayDialog_Ok(
          context,
          "Você deve prencher o número do medidor instalado. "
          "Tem certeza que deseja finalizar a nota sem anotar o medidor?");
    } else if (widget.ordem.tipo_ordem == 'Pendência de Display' &&
        _controllerDisplayInst.text.isEmpty) {
      _displayDialog_Ok(
          context,
          "Você deve prencher o número do display instalado. "
          "Tem certeza que deseja finalizar a nota sem anotar o display?");
    } else {
      //salva
      _finalizaOrdem();
    }
  }

  _stringToDateTime(string) {
    var recorte = string.split(" - ");
    var data = recorte[0].split("/");
    var hora = recorte[1].split(":");

    return DateTime(int.tryParse(data[2]), int.tryParse(data[1]),
        int.tryParse(data[0]), int.tryParse(hora[0]), int.tryParse(hora[1]));
  }

  _calculaTempo(inicio, termino, formato) {
    DateTime Tinicio = _stringToDateTime(inicio);
    DateTime Tfinal = _stringToDateTime(termino);

    if (formato == 1) {
      return Tfinal.difference(Tinicio).inMinutes;
    } else if (formato == 2) {
      return Tfinal.difference(Tinicio).inHours;
    }
  }

  _finalizaOrdem() {
    //calcula o tempo
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

    var tempo_atend = _calculaTempo(
            widget.ordem.inicio,
            formatDate(
                DateTime.now(), [dd, '/', mm, '/', yyyy, ' - ', H, ':', nn]),
            1)
        .toString();

    var observacoes = _controllerObs.text;
    var execucao = _hintStatusExec;
    var finalizacao = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);

    setState(() {
      display_retirado = _controllerDisplayRet.text;
      display_instalado = _controllerDisplayInst.text;
      med_inst = _controllerMedInst.text;
    });

    if (_controllerDisplayRet.text.isEmpty){
      setState(() {
        display_retirado = widget.ordem.display_retirado;
      });
    }

    if (_controllerDisplayInst.text.isEmpty){
      setState(() {
        display_instalado = widget.ordem.display_instalado;
      });
    }

    if (_controllerMedInst.text.isEmpty){
      setState(() {
        med_inst = widget.ordem.med_inst;
      });
    }

    Firestore db = Firestore.instance;

    db.collection("OR").document(widget.ordem.num_osr).updateData({
      "tempo_atend": tempo_atend,
      "observacoes": observacoes,
      "execucao": execucao,
      "display_retirado": display_retirado,
      "display_instalado": display_instalado,
      "status" : "Finalizada",
      "finalizacao" : finalizacao,
    }).then((onValue) {
      pr.hide();
      _displayDialog_Final(context, "Ordem finalizada com sucesso.");

    }).catchError((onError) {
      pr.hide();
      _displayDialog_Ok(context, "Ocorreu um errro ao salvar os dado.");

    }).timeout(Duration(seconds: 15), onTimeout: () {
      pr.hide();
      _displayDialog_Ok(
          context, "Tempo limite excedido. Tente novamente mais tarde.");

    });
  }

  Future<void> scanBarcodeNormal(String campo) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#9E0616", "Cancela", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Falha ao capturar a plataforma.';
    }

    if (!mounted) return;
    switch (campo) {
      case "medidor":
        setState(() {
          _controllerMedInst.text = barcodeScanRes;
        });
        break;

      case "display_inst":
        setState(() {
          _controllerDisplayInst.text = barcodeScanRes;
        });
        break;

      case "display_ret":
        setState(() {
          _controllerDisplayRet.text = barcodeScanRes;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Finalizar OSR nº " + widget.ordem.num_osr,
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffB5B6B3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  //-------------------- DADOS DA ORDEM ------------------------
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            _textoVisOrdem,
                            style: _textStyle(14.0),
                            textAlign: TextAlign.left,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                size: 36,
                                color: Color(0xffEE162D),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isVisibleOrdem = !_isVisibleOrdem;
                                  if (!_isVisibleOrdem) {
                                    _textoVisOrdem =
                                        "Visualizar os dados da ordem";
                                  } else {
                                    _textoVisOrdem =
                                        "Ocultar os dados da ordem";
                                  }
                                });
                              })
                        ],
                      ),
                      Visibility(
                        visible: _isVisibleOrdem,
                        child: Column(
                          children: <Widget>[
                            //textos da ordem
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "DATA DA PROGRAMAÇÃO: " +
                                    widget.ordem.programacao,
                                style: _textStyle(12.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "TIPO DA ORDEM: " + widget.ordem.tipo_ordem,
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
                    ],
                  ),
                ),

                //--------------------- STATUS ---------------------------
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  decoration: BoxDecoration(color: Color(0xffffffff)),
                  child: Column(
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Status",
                          style: _textStyle(14.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              RadioListTile(
                                title: Text(
                                  "Executado",
                                  style: _textStyle(12.0),
                                  textAlign: TextAlign.left,
                                ),
                                value: "Executado",
                                groupValue: _hintStatusExec,
                                onChanged: (valor) {
                                  setState(() {
                                    _hintStatusExec = valor;
                                    _coriconexec = Color(0xffEE162D);
                                    _coriconparc = Colors.white;
                                    _coriconcanc = Colors.white;
                                  });
                                },
                                activeColor: Color(0xffEE162D),
                                secondary: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: _coriconexec,
                                ),
                              ),
                              RadioListTile(
                                title: Text(
                                  "Parcial",
                                  style: _textStyle(12.0),
                                  textAlign: TextAlign.left,
                                ),
                                value: "Parcial",
                                groupValue: _hintStatusExec,
                                onChanged: (valor) {
                                  setState(() {
                                    _hintStatusExec = valor;
                                    _coriconexec = Colors.white;
                                    _coriconparc = Color(0xffEE162D);
                                    _coriconcanc = Colors.white;
                                  });
                                },
                                dense: true,
                                activeColor: Color(0xffEE162D),
                                secondary: Icon(
                                  Icons.pause,
                                  size: 30,
                                  color: _coriconparc,
                                ),
                              ),
                              RadioListTile(
                                title: Text(
                                  "Cancelado",
                                  style: _textStyle(12.0),
                                  textAlign: TextAlign.left,
                                ),
                                value: "Cancelado",
                                groupValue: _hintStatusExec,
                                onChanged: (valor) {
                                  setState(() {
                                    _hintStatusExec = valor;
                                    _coriconexec = Colors.white;
                                    _coriconparc = Colors.white;
                                    _coriconcanc = Color(0xffEE162D);
                                  });
                                },
                                dense: true,
                                activeColor: Color(0xffEE162D),
                                secondary: Icon(
                                  Icons.cancel,
                                  size: 30,
                                  color: _coriconcanc,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //----------------------- MEDIDOR ----------------------------
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
                          _textoVisMedidor,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleMedidor = !_isVisibleMedidor;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleMedidor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Container(
                                      width: 210,
                                      child: _insertTextField(
                                          _controllerMedInst,
                                          "Medidor Instalado"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      child: Image.asset("images/barcode2.png",
                                          width: 60, height: 60),
                                      onTap: () {
                                        scanBarcodeNormal("medidor");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //----------------------- DISPLAY INSTALADO ----------------------------
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
                          _textoVisDisplayInst,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleDisplayInst = !_isVisibleDisplayInst;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleDisplayInst,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Container(
                                      width: 210,
                                      child: _insertTextField(
                                          _controllerDisplayInst,
                                          "Display Instalado"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      child: Image.asset("images/barcode2.png",
                                          width: 60, height: 60),
                                      onTap: () {
                                        scanBarcodeNormal("display_inst");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //----------------------- DISPLAY RETIRADO ----------------------------
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
                          _textoVisDisplayRet,
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            _isVisibleDisplayRet = !_isVisibleDisplayRet;
                          });
                        },
                      ),
                      Visibility(
                        visible: _isVisibleDisplayRet,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Container(
                                      width: 210,
                                      child: _insertTextField(
                                          _controllerDisplayRet,
                                          "Display Retirado"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      child: Image.asset("images/barcode2.png",
                                          width: 60, height: 60),
                                      onTap: () {
                                        scanBarcodeNormal("display_ret");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //--------------------- Observaçoes ----------------------
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Observações",
                          style: _textStyle(14.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 15),
                        child: _insertTextField(_controllerObs, "Observações"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Finalizar Ordem",
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
                        _testarPreenchimento();
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
