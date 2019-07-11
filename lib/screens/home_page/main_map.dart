import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_favorite_places/bloc/main_map_bloc.dart';
import 'package:my_favorite_places/provider/main_map_provider.dart';
import 'package:my_favorite_places/screens/home_page/marker_properties.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'marker_options_dialog.dart';

class MainMap extends StatefulWidget {
  @override
  State<MainMap> createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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
          _getSearchAddressBar(), // Search Bar

          Provider<MainMapBloc>.value(
            child: MarkerOptionsDialog(
              onFavPlace: (){
                mainMapBloc.favMarker(mainMapBloc.getSelectedMarker());
              },
              onUnFavPlace: (){
                mainMapBloc.unFavMarker(mainMapBloc.getSelectedMarker());

              },
              onDeleteMarker: (){
                mainMapBloc.removeMarker(mainMapBloc.getSelectedMarker());
                mainMapBloc.hideMarkerActionsDialog();
              },
            ),
            value: mainMapBloc,
          ),

          _getFabButtonLayer(), // FAB Button
        ],
      ),
      appBar: AppBar(
        title: Text('Demo Gmaps'),
      ),
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

  Widget _getSearchAddressBar() {
    return StreamBuilder(
      stream: mainMapBloc.addressSearchBarStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return (snapshot.data == true)
            ? Column(
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
                                    hintText:
                                        'Please enter an address or place name...'),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () async {
                                mainMapBloc.hideAddressSearchBar();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Text('');
      },
    );
  }

  void _onTapMap(LatLng position) {
    mainMapBloc.hideMarkerActionsDialog();

    // Generate new marker
    var uuid = new Uuid();
    final newMarkerId = "place_${uuid.v4()}";

    Marker newMarker = Marker(
        markerId: MarkerId(newMarkerId),
        position: position,
        infoWindow: InfoWindow(title: "Marker $newMarkerId", snippet: "*"),
        onTap: () => onTapMarker(newMarkerId));
//    CustomMarker customMarker = CustomMarker( bookmarked: false, marker: newMarker );
    mainMapBloc.addMarker(newMarker);
  }

  void _showSearchBar() {
    mainMapBloc.showAddressSearchBar();
  }

  void onTapMarker(String markerId) {
    mainMapBloc.showMarkerActionsDialog();
    mainMapBloc.setSelectedMarker(mainMapBloc.getMarkerById(markerId));
    //Get marker properties and update marker dialog
    MarkerProperties mp = mainMapBloc.getSelectedMarkerProperties(mainMapBloc.getSelectedMarker());
    mainMapBloc.markerFavUnfavController.sink.add(mp);
  }

  Widget _getFabButtonLayer() {
    return StreamBuilder(
      stream: mainMapBloc.markerActionsDialogStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return (mainMapBloc.mainMapProvider.markerActionsDialogIsNotVisible)
            ? Column(
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
                  ),
                ],
              )
            : Text('');
      },
    );
  }
}

