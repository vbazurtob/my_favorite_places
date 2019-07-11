import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_favorite_places/bloc/main_map_bloc.dart';
import 'package:provider/provider.dart';

import 'marker_properties.dart';

class MarkerOptionsDialog extends StatelessWidget {
  final Function onFavPlace;
  final Function onUnFavPlace;
  final Function onDeleteMarker;

  MarkerOptionsDialog(
      { this.onFavPlace, this.onUnFavPlace, this.onDeleteMarker }
      );

  @override
  Widget build(BuildContext context) {
    MainMapBloc mapBloc = Provider.of<MainMapBloc>(context);

    return StreamBuilder(
        stream: mapBloc.markerActionsDialogStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return (snapshot.data == true)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Card(
                  child: Container(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[

                        StreamBuilder(
                            stream: mapBloc.markerFavUnfavStream,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {

                              Marker marker = mapBloc.getSelectedMarker();
                              MarkerProperties markerProperties = snapshot.data;

                              print('Stream Builder received FAV/UNFAV');
                              print(markerProperties);
                              return IconButton(
                                color:
                                (marker != null && markerProperties?.bookmarked == true)
                                    ? Colors.red
                                    : Colors.blueGrey,
                                icon: Icon(Icons.favorite),
                                iconSize: 30,
                                //The received item from the stream is already changed. That is why the inverted position
                                //of the methods
                                onPressed: (marker != null && markerProperties?.bookmarked != true)? onFavPlace : onUnFavPlace  ,
                              );
                            }
                        ),


                        IconButton(
                          icon: Icon(Icons.delete),
                          iconSize: 30,
                          onPressed: onDeleteMarker,
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
  final Widget child;

  const _MainMapStateProvider(
      {Key key, @required this.child, @required this.mapBloc})
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
            mapBloc.mainMapProvider.markers.length ||
        old.mapBloc.mainMapProvider.selectedMarker !=
            mapBloc.mainMapProvider.selectedMarker;
  }
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
