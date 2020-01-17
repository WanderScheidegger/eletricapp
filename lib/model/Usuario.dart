import 'dart:core';

class Usuario {
  String _nome;
  String _sobrenome;
  String _matricula;
  String _email;
  String _senha;
  String _equipe;
  String _adm;
  String _servico;
  String _latitude;
  String _longitude;
  String _time;
  String _uid;


  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "nome" : this.nome,
      "sobrenome" : this.sobrenome,
      "matricula" : this.matricula,
      "email" : this.email,
      "equipe" : this.equipe,
      "adm" : this.adm,
      "servico" : this._servico,
      "latitude" : this._latitude,
      "longitude" : this._longitude,
      "time" : this._time,
      "uid" : this._uid,
    };
    return map;
  }

  Usuario();


  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  String get servico => _servico;

  set servico(String value) {
    _servico = value;
  }

  String get adm => _adm;

  set adm(String value) {
    _adm = value;
  }

  String get equipe => _equipe;

  set equipe(String value) {
    _equipe = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
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

  String get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
  }

}

