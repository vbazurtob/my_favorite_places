import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_bloc.dart';
import 'package:my_favorite_places/provider/main_map_provider.dart';

class MainMapBloc implements BaseBloc{

  final MainMapProvider mainMapProvider = MainMapProvider();
  final markersController = StreamController();

  Stream get  getMarkers => markersController.stream;

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