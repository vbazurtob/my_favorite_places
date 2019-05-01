import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  Completer<GoogleMapController> _controller = Completer();
//  GoogleMapController  _mapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final CameraPosition _home =  CameraPosition(
    target: LatLng(-141.555,-56.4555),
    zoom: 5,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:

          Stack(
            children: <Widget>[

              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {

                  controller.moveCamera( CameraUpdate.newCameraPosition( _home ) );

                  _controller.complete(controller);


                },
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                scrollGesturesEnabled: true,
              ),

              _getControlButtons(),


            ],
          ),


      appBar: AppBar(
        title: Text('Demo Gmaps'),
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void>_goToHome() async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  Widget _getControlButtons() {
    return

      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Card(
            color: Colors.white,
            child:
              Column(
                children: <Widget>[

                  Row(
                    children: <Widget>[
                              Expanded(
                                child:
                                TextField(

                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Please enter an address or place name...'
                                  ),
                                ),
                              ),


                      IconButton(
                              icon: Icon(Icons.close),
                              onPressed: (){

                              },
                      ),

                    ],
                  ),

//                        Row(
//                          children: <Widget>[
//
//
//                            ListTile(
//                              title:  Text('ABC'),
//
//
////                              TextField(
////                                decoration: InputDecoration(
////                                    border: InputBorder.none,
////                                    hintText: 'Please enter an address or place name...'
////                                ),
////                              ),
//
//
//                              subtitle: Text('Find an address'),
//
//
//                          ),
//
////
////                          IconButton(
////                              icon: Icon(Icons.close),
////                              onPressed: (){
////
////                              },
////                          ),
//                        ]
//                  ),

                ],
              ),

          ),

//          ButtonBar(
//            alignment: MainAxisAlignment.center,
//            children: <Widget>[
//              IconButton(
//                icon: Icon( Icons.home ),
//                onPressed: _goToHome,
//              ),
//
//              IconButton(
//                icon: Icon( Icons.search ),
//                onPressed: _goToHome,
//              ),
//
//            ],
//          ),

        ],
      );


  }

}