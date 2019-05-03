import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_favorite_places/bloc/main_map_bloc.dart';
import 'package:my_favorite_places/provider/main_map_provider.dart';
import 'package:uuid/uuid.dart';
import 'custom_marker.dart';

class MainMap extends StatefulWidget {
  @override
  State<MainMap> createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  Completer<GoogleMapController> _controller = Completer();

  bool _searchByAddress = false;
  bool _markerActions = false;
  CustomMarker _selectedMarker;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

//  static final CameraPosition _kLake = CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(37.43296265331129, -122.08832357078792),
//      tilt: 59.440717697143555,
//      zoom: 19.151926040649414);

  static final CameraPosition _home = CameraPosition(
    target: LatLng(-141.555, -56.4555),
    zoom: 5,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: mainMapBloc.getMarkersViaStream,
            initialData: MainMapProvider()
                .markers, //Empty, Just to comply with the provider internal structure
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return mapWidget(snapshot);
            },
          ),
          (_searchByAddress) ? _getControlButtons() : Text(''),
          (_markerActions) ? WidgetOptionsDialog(
            _selectedMarker
          ) : Text(''),

          (!_markerActions) ?_getFabButtonLayer(): Text(''),
        ],
      ),
      appBar: AppBar(
        title: Text('Demo Gmaps'),
      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: _showSearchBar,
//        label: Text('By Address'),
//        icon: Icon(Icons.search),
//        elevation: 0.0,
//
//      ),
    );
  }

  Widget mapWidget(AsyncSnapshot snapshot) {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          controller.moveCamera(CameraUpdate.newCameraPosition(_home));
          _controller.complete(controller);
        },
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        scrollGesturesEnabled: true,
        onTap: _onTapMap,
        markers: Set<Marker>.of(snapshot.data.values),
      ),
    );
  }

  Widget _getControlButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Card(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Please enter an address or place name...'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      setState(() {
                        _searchByAddress = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onTapMap(LatLng position) {

    setState(() {
      _markerActions = false;
    });

    var uuid = new Uuid();

    final newMarkerId = "place_${uuid.v4()}";

    Marker newMarker = CustomMarker(
        markerId: MarkerId(newMarkerId),
        position: position,
        infoWindow: InfoWindow(title: "Marker $newMarkerId", snippet: "*"),

        onTap: () => onTapMarker(newMarkerId)
    );
    mainMapBloc.addMarker(newMarker);
  }

  void _showSearchBar() {
    setState(() {
      _searchByAddress = true;
    });
  }

  void onTapMarker(String markerId){

    setState(() {
        _markerActions = true;
        _selectedMarker =  mainMapBloc.getMarkerById(markerId)  ;
//        print('Selected : $_selectedMarker ');
      });

  }

  Widget _getFabButtonLayer() {

    return Column(
//      crossAxisAlignment: CrossAxisAlignment.stretc,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[

         ButtonBar(
           children: <Widget>[
             FloatingActionButton.extended(
               onPressed: _showSearchBar,
               label: Text('By Address'),
               icon: Icon(Icons.search),
               elevation: 0.0,
             ),
           ],
//          child:


        ),


      ],



    );

  }

  /// UNUSED DEMO CODE
  ///

//
//  Future<void> _goToHome() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_home));
//  }

// GOOGLE PLACES CODE
//
//  Prediction p = await PlacesAutocomplete.show(
//  context: context,
//  apiKey: GMapsApiKey
//      .apiKey, //Places has a quota of 1 request.
//  mode: Mode.overlay, // Mode.fullscreen
//  language: "en",
//  components: [new Component(Component.country, "us")]);
//
//  print('Prediction ' + p.toString());
}

class WidgetOptionsDialog extends StatelessWidget {

  final CustomMarker _marker;

  WidgetOptionsDialog(this._marker);



  @override
  Widget build(BuildContext context) {
    return

      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          Card(
              child: Container(
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      color: ( _marker != null && _marker?.bookmarked == true ) ? Colors.red : Colors.blueGrey ,
                      icon: Icon(Icons.favorite),
                      iconSize: 30,
                      onPressed: _onFavPlace,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 30,
                      onPressed: _onDeleteMarker,
                      color: Colors.blueGrey ,
                    ),
                  ],
                ),
              ))

        ],
      )


      ;
  }

  void _onFavPlace() {


  }

  void _onDeleteMarker() {

  }

}
