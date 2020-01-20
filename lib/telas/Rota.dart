import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Rota extends StatefulWidget {
  @override
  _RotaState createState() => _RotaState();
}

class _RotaState extends State<Rota> {

  Completer<GoogleMapController> _controller = Completer();
  var _latAtual;
  var _longAtual;


  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(-20.210935, -40.253392),
    zoom: 9.8,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _posicaoAtual(){

    Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    ).then((Position position){

      setState(() {
        _latAtual = position.latitude;
        _longAtual = position.longitude;
      });

    }).timeout(Duration(seconds: 5), onTimeout: () {

    });

  }

  @override
  void initState() {
    _posicaoAtual();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
          ],
        ),
      ),


    );
  }
}
