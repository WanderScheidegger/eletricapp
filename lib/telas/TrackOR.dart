import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackOR extends StatefulWidget {
  @override
  _TrackORState createState() => _TrackORState();
}

class _TrackORState extends State<TrackOR> {
  List<DocumentSnapshot> _localiza;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _marcadores = <MarkerId, Marker>{};

  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(-20.210935, -40.253392),
    zoom: 10.5,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _recuperarLocalizacoes() async {

    CollectionReference reference = Firestore.instance.collection('usuarios');
    reference.snapshots().listen((querySnapshot) {
      var listaLoc = querySnapshot.documents.toList();
      //var somaLat = 0;
      //var somaLong = 0;
      //var n_users = listaLoc.length;

      //insere cada marca de usuário
      listaLoc.forEach((user) {
        double pixelRatio = MediaQuery.of(context).devicePixelRatio;

        var nome = user.data['nome'] + " " + user.data['sobrenome'];
        var servico = user.data['servico'];
        var mat = user.data['matricula'];
        var tempo = user.data['time'];
        var lat = user.data['latitude'];
        var long = user.data['longitude'];

        //somaLat += int.parse(lat);
        //somaLong += int.parse(long);

        BitmapDescriptor.fromAssetImage(
                ImageConfiguration(devicePixelRatio: pixelRatio),
                "images/carro.png")
            .then((BitmapDescriptor icone) {
          print(user.data['nome']);
          Marker marc = Marker(
              markerId: MarkerId(mat),
              position: LatLng(lat, long),
              infoWindow: InfoWindow(
                  title: nome + "-" + tempo + "-" + servico),
              icon: icone);

          setState(() {
            _marcadores[MarkerId(mat)] = marc;
          });

        });
      });


    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    _recuperarLocalizacoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Localização",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
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
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_marcadores.values),
            ),
          ],
        ),
      ),
    );
  }
}
