import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Diagrama extends StatefulWidget {
  @override
  _DiagramaState createState() => _DiagramaState();
}

class _DiagramaState extends State<Diagrama> {
  static Firestore db = Firestore.instance;

  StreamBuilder stream = StreamBuilder(
    stream: db
        .collection("OR")
        .where('status', isEqualTo: "Finalizada")
        .snapshots(),
    // ignore: missing_return
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Expanded(
            child: Text(
              "Você não tem conexão com a internet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "EDP Preon",
                fontSize: 12,
                color: Color(0xff311B92),
              ),
            ),
          );
          break;
        case ConnectionState.waiting:
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Carregando as ordens...",
                  style: TextStyle(
                    fontFamily: "EDP Preon",
                    fontSize: 12,
                    color: Color(0xff311B92),
                  ),
                ),
                CircularProgressIndicator(),
              ],
            ),
          );
          break;
        case ConnectionState.active:
        case ConnectionState.done:
          QuerySnapshot querySnapshot = snapshot.data;
          //Recupara as ordens
          List<DocumentSnapshot> ordens = querySnapshot.documents.toList();

          return DataTable(
            columnSpacing: 0,

            columns: [
              DataColumn(label: Text('Seleção')),
              DataColumn(label: Text('Nº da OSR')),
              DataColumn(label: Text('Programação')),
              DataColumn(label: Text('Status')),
            ],
            rows: ordens
                .map(
                  ((element) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                            SizedBox.expand(
                              child: Container(
                                child: Checkbox(
                                    value: false,
                                    onChanged: null
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox.expand(
                              child: Container(
                                child: Card(
                                  elevation: 10,
                                  color: Color(0xff9FA8DA),
                                  borderOnForeground: true,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        element["num_osr"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "EDP Preon",
                                          fontSize: 12,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox.expand(
                              child: Container(
                                child: Card(
                                  elevation: 10,
                                  color: Color(0xff9FA8DA),
                                  borderOnForeground: true,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        element["programacao"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "EDP Preon",
                                          fontSize: 12,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox.expand(
                              child: Container(
                                child: Card(
                                  elevation: 6,
                                  color: Color(0xffB5B6B3),
                                  borderOnForeground: true,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child:
                                        Text(
                                          element["status"],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: "EDP Preon",
                                            fontSize: 12,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                )
                .toList(),
          );
          break;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tabela",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/diagrama", (_) => false);
          },
        ),
        backgroundColor: Color(0xff9FA8DA),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: <Widget>[
                stream,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
