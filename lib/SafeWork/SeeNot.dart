import 'package:eletricapp/SafeWork/model/OrdemSt.dart';
import 'package:flutter/material.dart';

class SeeNot extends StatefulWidget {
  OrdemSt ordem;
  SeeNot(this.ordem);

  @override
  _SeeNotState createState() => _SeeNotState();
}

class _SeeNotState extends State<SeeNot> {
  bool _isVisPlaca = false;
  bool _isVisFinaliza = false;

  bool _isVisirreg1 = false;
  bool _isVisirreg2 = false;
  bool _isVisirreg3 = false;
  bool _isVisirreg4 = false;
  bool _isVisirreg5 = false;

  //padrão de TextStyle
  static _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  _testaIrreg(){
    if (widget.ordem.placa != ""){
      setState(() {
        _isVisPlaca = true;
      });
    }
    if (widget.ordem.irregularidade1 != ""){
      setState(() {
        _isVisirreg1 = true;
      });
    }
    if (widget.ordem.irregularidade2 != ""){
      setState(() {
        _isVisirreg2 = true;
      });
    }
    if (widget.ordem.irregularidade3 != ""){
      setState(() {
        _isVisirreg3 = true;
      });
    }
    if (widget.ordem.irregularidade4 != ""){
      setState(() {
        _isVisirreg4 = true;
      });
    }
    if (widget.ordem.irregularidade5 != ""){
      setState(() {
        _isVisirreg5 = true;
      });
    }

    if (widget.ordem.observacoes != ""){
      setState(() {
        _isVisFinaliza = true;
      });
    }

  }

  @override
  void initState() {
    _testaIrreg();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OST nº " + widget.ordem.num_ost,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffB5B6B3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "DADOS DO NOTIFICADO",
                        style: _textStyle(14.0),
                      ),
                    ),
                  //------------------------------------------------------------
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "NOME: " + widget.ordem.nome + "\n" +
                        "SOBRENOME: " + widget.ordem.sobrenome + "\n" +
                        "MATRÍCULA: " + widget.ordem.matricula,
                        style: _textStyle(13.0),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffEE162D),
                    ),
                    //----------------------------------------------------------
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "STATUS DA NOTIFICAÇÃO",
                        style: _textStyle(14.0),
                      ),
                    ),
                    //----------------------------------------------------------
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "SETOR: " + widget.ordem.setor + "\n" +
                            "TIPO: " + widget.ordem.opcao + "\n" +
                            "DATA: " + widget.ordem.data + "\n" +
                            "RESPONSÁVEL: " + widget.ordem.responsavel + "\n" +
                            "Ciente: " + widget.ordem.ciencia + "\n" +
                            "Em aberto: " + widget.ordem.em_aberto
                        ,
                        style: _textStyle(13.0),
                      ),
                    ),
                    Visibility(
                      visible: _isVisPlaca,
                      child: Text(
                        "PLACA: " + widget.ordem.placa,
                        style: _textStyle(13.0),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffEE162D),
                    ),
                    //----------------------------------------------------------
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "IRREGULARIDADES APONTADAS",
                        style: _textStyle(14.0),
                      ),
                    ),
                    //--------------------------1-------------------------------
                    Visibility(
                      visible: _isVisirreg1,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "IRREGULARIDADE 1: " + widget.ordem.irregularidade1 + "\n" +
                                  "RISCO: " + widget.ordem.risco1 + "\n" +
                                  "AÇÕES: " + widget.ordem.acoes1 + "\n" +
                                  "RETORNO: " + widget.ordem.retorno1,
                              style: _textStyle(13.0),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xffEE162D),
                          ),
                        ],
                      ),
                    ),
                    //--------------------------2-------------------------------
                    Visibility(
                      visible: _isVisirreg2,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "IRREGULARIDADE 2: " + widget.ordem.irregularidade2 + "\n" +
                                  "RISCO: " + widget.ordem.risco2 + "\n" +
                                  "AÇÕES: " + widget.ordem.acoes2 + "\n" +
                                  "RETORNO: " + widget.ordem.retorno2,
                              style: _textStyle(13.0),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xffEE162D),
                          ),
                        ],
                      ),
                    ),
                    //--------------------------3-------------------------------
                    Visibility(
                      visible: _isVisirreg3,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "IRREGULARIDADE 3: " + widget.ordem.irregularidade3 + "\n" +
                                  "RISCO: " + widget.ordem.risco3 + "\n" +
                                  "AÇÕES: " + widget.ordem.acoes3 + "\n" +
                                  "RETORNO: " + widget.ordem.retorno3,
                              style: _textStyle(13.0),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xffEE162D),
                          ),
                        ],
                      ),
                    ),
                    //--------------------------4-------------------------------
                    Visibility(
                      visible: _isVisirreg4,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "IRREGULARIDADE 4: " + widget.ordem.irregularidade4 + "\n" +
                                  "RISCO: " + widget.ordem.risco4 + "\n" +
                                  "AÇÕES: " + widget.ordem.acoes4 + "\n" +
                                  "RETORNO: " + widget.ordem.retorno4,
                              style: _textStyle(13.0),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xffEE162D),
                          ),
                        ],
                      ),
                    ),
                    //--------------------------5-------------------------------
                    Visibility(
                      visible: _isVisirreg5,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "IRREGULARIDADE 5: " + widget.ordem.irregularidade5 + "\n" +
                                  "RISCO: " + widget.ordem.risco5 + "\n" +
                                  "AÇÕES: " + widget.ordem.acoes5 + "\n" +
                                  "RETORNO: " + widget.ordem.retorno5,
                              style: _textStyle(13.0),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xffEE162D),
                          ),
                        ],
                      ),
                    ),
                    //------------------------obs-------------------------------
                    Visibility(
                      visible: _isVisFinaliza,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "FINALIZADA EM: " + widget.ordem.zdata_finaliza + "\n" +
                                  "OBSERVAÇÕES: " + widget.ordem.observacoes,
                              style: _textStyle(13.0),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xffEE162D),
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
      ),
    );
  }
}
