import 'dart:core';

class OrdemRot {

  String _emissao;
  String _inicio;
  String _tempo_atend;
  String _num_rot;
  String _programacao;
  String _diagrama;
  String _endereco;
  String _coord_x;
  String _coord_y;
  String _observacoes;
  String _obs_adm;
  String _matricula;
  String _status;
  String _uidcriador;
  String _parceiro;


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "emissao" : this._emissao,
      "inicio" : this._inicio,
      "tempo_atend" : this._tempo_atend,
      "num_rot" : this._num_rot,
      "programacao" : this._programacao,
      "diagrama" : this._diagrama,
      "endereco" : this._endereco,
      "coord_x" : this._coord_x,
      "coord_y" : this._coord_y,
      "observacoes" : this._observacoes,
      "obs_adm" : this._obs_adm,
      "matricula" : this._matricula,
      "status" : this._status,
      "uidcriador" : this._uidcriador,
      "parceiro" : this._parceiro,

    };
    return map;
  }

  OrdemRot();

  String get parceiro => _parceiro;

  set parceiro(String value) {
    _parceiro = value;
  }

  String get uidcriador => _uidcriador;

  set uidcriador(String value) {
    _uidcriador = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get matricula => _matricula;

  set matricula(String value) {
    _matricula = value;
  }

  String get obs_adm => _obs_adm;

  set obs_adm(String value) {
    _obs_adm = value;
  }

  String get observacoes => _observacoes;

  set observacoes(String value) {
    _observacoes = value;
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

  String get diagrama => _diagrama;

  set diagrama(String value) {
    _diagrama = value;
  }

  String get programacao => _programacao;

  set programacao(String value) {
    _programacao = value;
  }

  String get num_rot => _num_rot;

  set num_rot(String value) {
    _num_rot = value;
  }

  String get tempo_atend => _tempo_atend;

  set tempo_atend(String value) {
    _tempo_atend = value;
  }

  String get inicio => _inicio;

  set inicio(String value) {
    _inicio = value;
  }

  String get emissao => _emissao;

  set emissao(String value) {
    _emissao = value;
  }


}