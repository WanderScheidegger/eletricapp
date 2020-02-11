import 'dart:core';

class OrdemSt{

  String _opcao;
  String _num_ost;
  String _nome;
  String _sobrenome;
  String _matricula;
  String _placa;
  String _setor;
  String _data;
  String _data_ciencia;
  String _em_aberto;
  String _risco1;
  String _retorno1;
  String _irregularidade1;
  String _acoes1;
  String _risco2;
  String _retorno2;
  String _irregularidade2;
  String _acoes2;
  String _risco3;
  String _retorno3;
  String _irregularidade3;
  String _acoes3;
  String _risco4;
  String _retorno4;
  String _irregularidade4;
  String _acoes4;
  String _risco5;
  String _retorno5;
  String _irregularidade5;
  String _acoes5;
  String _responsavel;
  String _supervisor;
  String _matSupervisor;
  String _ciencia;


  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "opcao" : this._opcao,
      "num_ost": this._num_ost,
      "nome" : this._nome,
      "sobrenome" : this._sobrenome,
      "matricula" : this._matricula,
      "placa" : this._placa,
      "setor" : this._setor,
      "data" : this._data,
      "data_ciencia" : this._data_ciencia,
      "em_aberto" : this._em_aberto,
      "risco1" : this._risco1,
      "retorno1" : this._retorno1,
      "irregularidade1" : this._irregularidade1,
      "acoes1" : this._acoes1,
      "risco2" : this._risco2,
      "retorno2" : this._retorno2,
      "irregularidade2" : this._irregularidade2,
      "acoes2" : this._acoes2,
      "risco3" : this._risco3,
      "retorno3" : this._retorno3,
      "irregularidade3" : this._irregularidade3,
      "acoes3" : this._acoes3,
      "risco4" : this._risco4,
      "retorno4" : this._retorno4,
      "irregularidade4" : this._irregularidade4,
      "acoes4" : this._acoes4,
      "risco5" : this._risco5,
      "retorno5" : this._retorno5,
      "irregularidade5" : this._irregularidade5,
      "acoes5" : this._acoes5,
      "responsavel" : this._responsavel,
      "supervisor" : this._supervisor,
      "matSupervisor" : this._matSupervisor,
      "ciencia" : this._ciencia
    };
    return map;
  }

  OrdemSt();


  String get em_aberto => _em_aberto;

  set em_aberto(String value) {
    _em_aberto = value;
  }

  String get data_ciencia => _data_ciencia;

  set data_ciencia(String value) {
    _data_ciencia = value;
  }

  String get ciencia => _ciencia;

  set ciencia(String value) {
    _ciencia = value;
  }

  String get matSupervisor => _matSupervisor;

  set matSupervisor(String value) {
    _matSupervisor = value;
  }

  String get supervisor => _supervisor;

  set supervisor(String value) {
    _supervisor = value;
  }

  String get responsavel => _responsavel;

  set responsavel(String value) {
    _responsavel = value;
  }

  String get acoes5 => _acoes5;

  set acoes5(String value) {
    _acoes5 = value;
  }

  String get irregularidade5 => _irregularidade5;

  set irregularidade5(String value) {
    _irregularidade5 = value;
  }

  String get retorno5 => _retorno5;

  set retorno5(String value) {
    _retorno5 = value;
  }

  String get risco5 => _risco5;

  set risco5(String value) {
    _risco5 = value;
  }

  String get acoes4 => _acoes4;

  set acoes4(String value) {
    _acoes4 = value;
  }

  String get irregularidade4 => _irregularidade4;

  set irregularidade4(String value) {
    _irregularidade4 = value;
  }

  String get retorno4 => _retorno4;

  set retorno4(String value) {
    _retorno4 = value;
  }

  String get risco4 => _risco4;

  set risco4(String value) {
    _risco4 = value;
  }

  String get acoes3 => _acoes3;

  set acoes3(String value) {
    _acoes3 = value;
  }

  String get irregularidade3 => _irregularidade3;

  set irregularidade3(String value) {
    _irregularidade3 = value;
  }

  String get retorno3 => _retorno3;

  set retorno3(String value) {
    _retorno3 = value;
  }

  String get risco3 => _risco3;

  set risco3(String value) {
    _risco3 = value;
  }

  String get acoes2 => _acoes2;

  set acoes2(String value) {
    _acoes2 = value;
  }

  String get irregularidade2 => _irregularidade2;

  set irregularidade2(String value) {
    _irregularidade2 = value;
  }

  String get retorno2 => _retorno2;

  set retorno2(String value) {
    _retorno2 = value;
  }

  String get risco2 => _risco2;

  set risco2(String value) {
    _risco2 = value;
  }

  String get acoes1 => _acoes1;

  set acoes1(String value) {
    _acoes1 = value;
  }

  String get irregularidade1 => _irregularidade1;

  set irregularidade1(String value) {
    _irregularidade1 = value;
  }

  String get retorno1 => _retorno1;

  set retorno1(String value) {
    _retorno1 = value;
  }

  String get risco1 => _risco1;

  set risco1(String value) {
    _risco1 = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get setor => _setor;

  set setor(String value) {
    _setor = value;
  }

  String get placa => _placa;

  set placa(String value) {
    _placa = value;
  }

  String get matricula => _matricula;

  set matricula(String value) {
    _matricula = value;
  }

  String get sobrenome => _sobrenome;

  set sobrenome(String value) {
    _sobrenome = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get num_ost => _num_ost;

  set num_ost(String value) {
    _num_ost = value;
  }

  String get opcao => _opcao;

  set opcao(String value) {
    _opcao = value;
  }


}