import 'dart:core';

class Ordem {

  String _emissao;
  String _inicio;
  String _tempo_atend;
  String _num_osr;
  String _programacao;
  String _finalizacao;
  String _obra;
  String _med_antigo;
  String _med_inst;
  String _modulo_cs;
  String _display;
  String _display_retirado;
  String _display_instalado;
  String _cs;
  String _trafo;
  String _anilha;
  String _tipo_de_fase;
  String _endereco;
  String _coord_x;
  String _coord_y;
  String _tipo_ordem;
  String _observacoes;
  String _obs_adm;
  String _matricula;
  String _status;
  String _uidcriador;
  String _execucao;
  String _parceiro;


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "emissao" : this._emissao,
      "inicio" : this._inicio,
      "tempo_atend" : this._tempo_atend,
      "num_osr" : this._num_osr,
      "programacao" : this._programacao,
      "finalizacao" : this._finalizacao,
      "obra" : this._obra,
      "med_antigo" : this._med_antigo,
      "med_inst" : this._med_inst,
      "modulo_cs" : this._modulo_cs,
      "display" : this._display,
      "display_retirado" : this._display_retirado,
      "display_instalado" : this._display_instalado,
      "cs" : this._cs,
      "anilha" : this._anilha,
      "trafo" : this._trafo,
      "tipo_de_fase" : this._tipo_de_fase,
      "endereco" : this._endereco,
      "coord_x" : this._coord_x,
      "coord_y" : this._coord_y,
      "tipo_ordem" : this._tipo_ordem,
      "observacoes" : this._observacoes,
      "obs_adm" : this._obs_adm,
      "matricula" : this._matricula,
      "status" : this._status,
      "uidcriador" : this._uidcriador,
      "execucao" : this._execucao,
      "parceiro" : this._parceiro,

    };
    return map;
  }

  Ordem();


  String get display => _display;

  set display(String value) {
    _display = value;
  }

  String get parceiro => _parceiro;

  set parceiro(String value) {
    _parceiro = value;
  }

  String get finalizacao => _finalizacao;

  set finalizacao(String value) {
    _finalizacao = value;
  }

  String get execucao => _execucao;

  set execucao(String value) {
    _execucao = value;
  }

  String get tempo_atend => _tempo_atend;

  set tempo_atend(String value) {
    _tempo_atend = value;
  }

  String get med_inst => _med_inst;

  set med_inst(String value) {
    _med_inst = value;
  }

  String get inicio => _inicio;

  set inicio(String value) {
    _inicio = value;
  }

  String get num_osr => _num_osr;

  set num_osr(String value) {
    _num_osr = value;
  }

  String get uidcriador => _uidcriador;

  set uidcriador(String value) {
    _uidcriador = value;
  }

  String get obs_adm => _obs_adm;

  set obs_adm(String value) {
    _obs_adm = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get matricula => _matricula;

  set matricula(String value) {
    _matricula = value;
  }

  String get observacoes => _observacoes;

  set observacoes(String value) {
    _observacoes = value;
  }

  String get tipo_ordem => _tipo_ordem;

  set tipo_ordem(String value) {
    _tipo_ordem = value;
  }

  String get coord_y => _coord_y;

  set coord_y(String value) {
    _coord_y = value;
  }

  String get coord_x => _coord_x;

  set coord_x(String value) {
    _coord_x = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get tipo_de_fase => _tipo_de_fase;

  set tipo_de_fase(String value) {
    _tipo_de_fase = value;
  }

  String get anilha => _anilha;

  set anilha(String value) {
    _anilha = value;
  }

  String get trafo => _trafo;

  set trafo(String value) {
    _trafo = value;
  }

  String get cs => _cs;

  set cs(String value) {
    _cs = value;
  }

  String get display_instalado => _display_instalado;

  set display_instalado(String value) {
    _display_instalado = value;
  }

  String get display_retirado => _display_retirado;

  set display_retirado(String value) {
    _display_retirado = value;
  }

  String get modulo_cs => _modulo_cs;

  set modulo_cs(String value) {
    _modulo_cs = value;
  }

  String get med_antigo => _med_antigo;

  set med_antigo(String value) {
    _med_antigo = value;
  }

  String get obra => _obra;

  set obra(String value) {
    _obra = value;
  }

  String get programacao => _programacao;

  set programacao(String value) {
    _programacao = value;
  }

  String get emissao => _emissao;

  set emissao(String value) {
    _emissao = value;
  }


}