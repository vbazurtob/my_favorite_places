import 'dart:async';
import 'dart:core' ;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_bloc.dart';
import 'package:my_favorite_places/provider/main_map_provider.dart';

class MainMapBloc implements BaseBloc{

  final MainMapProvider mainMapProvider = MainMapProvider();
  final markersController = StreamController();

  Stream get  getMarkersViaStream => markersController.stream;

  Map<MarkerId, Marker> getMarkersViaProvider(){
    return mainMapProvider?.markers;
  }

  Marker getMarkerById(String id){
    MarkerId mId = MarkerId(id);
    Map<MarkerId, Marker> markers = getMarkersViaProvider();
    return markers != null ? (   markers.containsKey(mId) ? markers[mId] : markers    ) :  markers ;
  }

  void addMarker(Marker marker){
    mainMapProvider.addMarker(marker);
    markersController.sink.add(mainMapProvider.markers);
  }

  @override
  void dispose() {
    markersController.close();
  }

}

final mainMapBloc = MainMapBloc();