import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eletricapp/model/Usuario.dart';
import 'package:flutter/material.dart';

class Pessoal extends StatefulWidget {
  @override
  _PessoalState createState() => _PessoalState();
}

class _PessoalState extends State<Pessoal> {
  static Firestore db = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection("usuarios").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Carregando os usuários...",
                      style: TextStyle(
                        fontFamily: "EDP Preon",
                        fontSize: 12,
                        color: Color(0xff311B92),
                      ),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar dados"),
              );
            } else {
              return Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                child: ListView.separated(
                  // ignore: missing_return
                    separatorBuilder: (context, indice) => Divider(
                      color: Color(0xff9E0616),
                      thickness: 0.2,
                    ),
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {
                      //Recupara as ordens
                      List<DocumentSnapshot> usuarios =
                      querySnapshot.documents.toList();
                      DocumentSnapshot item = usuarios[indice];

                      var dados = item.data;
                      Usuario usuario = Usuario();

                      usuario.nome = dados["nome"];
                      usuario.sobrenome = dados["sobrenome"];
                      usuario.matricula = dados["matricula"];
                      usuario.email = dados["email"];
                      usuario.adm = dados["adm"];
                      usuario.equipe = dados["equipe"];
                      usuario.servico = dados["servico"];
                      usuario.time = dados["time"];
                      usuario.uid = dados["uid"];

                      return Card(
                        elevation: 8,
                        color: Color(0xffBDBDBD),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, "/modificausuario",
                                arguments: usuario);
                          },
                          title: Text(
                            "Nome: " + item['nome'] + " " + item['sobrenome'],
                            style: TextStyle(
                              fontFamily: "EDP Preon",
                              fontSize: 14,
                              color: Color(0xff311B92),
                            ),
                          ),
                          subtitle: Text(
                            "Matrícula: " + item['matricula'] +
                            "\n" +
                                "Serviço: " + item['servico'] +
                            "\n\n" +
                            "Última atual.: " + item['time'],
                            style: TextStyle(
                              fontFamily: "EDP Preon",
                              fontSize: 12,
                              color: Color(0xff311B92),
                            ),
                          ),
                          trailing: Text(
                            "ADM: " + item['adm'],
                            style: TextStyle(
                              fontFamily: "EDP Preon",
                              fontSize: 10,
                              color: Color(0xffEE162D),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
            break;
        }
      },
    );
  }
}

