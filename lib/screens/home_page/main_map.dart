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

//  bool _markerActions = false;
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
          _getSearchAddressBar(),

          _MainMapStateProvider(
            child: MarkerOptionsDialog(),
            mapBloc: mainMapBloc,
          ),

//          (_markerActions) ? WidgetOptionsDialog(
//            _selectedMarker
//          ) : Text(''),

//          (!_markerActions)
          mainMapBloc.mainMapProvider.markerActionsDialogIsNotVisible
              ? _getFabButtonLayer()
              : Text(''),
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
    print(
        'ACTIONS ${mainMapBloc.mainMapProvider.markerActionsDialogIsVisible}');
    mainMapBloc.hideMarkerActionsDialog();
//    setState(() {
//      _markerActions = false;
//    });

    var uuid = new Uuid();

    final newMarkerId = "place_${uuid.v4()}";

    Marker newMarker = CustomMarker(
        markerId: MarkerId(newMarkerId),
        position: position,
        infoWindow: InfoWindow(title: "Marker $newMarkerId", snippet: "*"),
        onTap: () => onTapMarker(newMarkerId));
    mainMapBloc.addMarker(newMarker);
  }

  void _showSearchBar() {
    mainMapBloc.showAddressSearchBar();
  }

  void onTapMarker(String markerId) {

    mainMapBloc.showMarkerActionsDialog();
    //TODO: Should Hide FAB HERE TOO


    setState(() {
      _selectedMarker = mainMapBloc.getMarkerById(markerId);
//        print('Selected : $_selectedMarker ');
    });

  }

  Widget _getFabButtonLayer() {
    return Column(
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

//class WidgetOptionsDialog extends StatelessWidget {
//
//  final CustomMarker _marker;
//
//  WidgetOptionsDialog(this._marker);
//
//
//
//  @override
//  Widget build(BuildContext context)
//  {
//
//    return _MainMapStateProvider(
//      mapBloc: mainMapBloc,
//      child: MarkerOptionsDialog(marker: _marker, onFavPlace: (){
//        _onFavPlace(context);
//      }),
//    )
//
//
//
//
//      ;
//  }
//
//  void _onFavPlace(BuildContext context) {
//    print('Faved');
////    _MainMapStateProvider.of(context);
//  }
//
//  void _onDeleteMarker(BuildContext context) {
//
////    context.of();
////    mainMapBloc.removeMarker(_marker);
//
////    _MainMapStateProvider.of(context).mapBloc.;
//
//
//
//
//  }
//
//}

class MarkerOptionsDialog extends StatelessWidget {
  final CustomMarker marker;
  final Function onFavPlace;
  final Function onDeleteMarker;

  MarkerOptionsDialog(
      {@required this.marker, @required this.onFavPlace, this.onDeleteMarker});

  @override
  Widget build(BuildContext context) {
    MainMapBloc mapBloc = _MainMapStateProvider.of(context).mapBloc;

    return StreamBuilder(
        stream: mapBloc.markerActionsDialogStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return (snapshot.data)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Card(
                        child: Container(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            color:
                                (marker != null && marker?.bookmarked == true)
                                    ? Colors.red
                                    : Colors.blueGrey,
                            icon: Icon(Icons.favorite),
                            iconSize: 30,
                            onPressed: onFavPlace,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            iconSize: 30,
                            onPressed: () => onDeleteMarker(context),
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),
                    ))
                  ],
                )
              : Text("");
        });
  }
}

class _MainMapStateProvider extends InheritedWidget {
  final MainMapBloc mapBloc;

  const _MainMapStateProvider(
      {Key key, @required Widget child, @required this.mapBloc})
      : assert(child != null),
        super(key: key, child: child);

  static _MainMapStateProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(_MainMapStateProvider);
  }

  @override
  bool updateShouldNotify(_MainMapStateProvider old) {
    return old.mapBloc.mainMapProvider.markerActionsDialogIsNotVisible !=
            mapBloc.mainMapProvider.markerActionsDialogIsNotVisible ||
        old.mapBloc.mainMapProvider.searchBarIsNotVisible !=
            mapBloc.mainMapProvider.searchBarIsNotVisible ||
        old.mapBloc.mainMapProvider.markers.length !=
            mapBloc.mainMapProvider.markers.length;
  }
}
