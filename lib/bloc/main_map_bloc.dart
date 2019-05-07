import 'dart:async';
import 'dart:core' ;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_bloc.dart';
import 'package:my_favorite_places/provider/main_map_provider.dart';

class MainMapBloc implements BaseBloc{

  final MainMapProvider mainMapProvider = MainMapProvider();
  final markersController = StreamController();
  final addressSearchBarController = StreamController();
  final markerActionsDialogController = StreamController();


  Stream get  getMarkersViaStream => markersController.stream;
  Stream get  addressSearchBarStream => addressSearchBarController.stream;
  Stream get  markerActionsDialogStream => markerActionsDialogController.stream;


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

  void removeMarker(Marker marker){
    mainMapProvider.deleteMarker(marker);
    markersController.sink.add(mainMapProvider.markers);
  }

  void showAddressSearchBar(){
    addressSearchBarController.sink.add(true);
  }

  void hideAddressSearchBar(){
    addressSearchBarController.sink.add(false);
  }

  void showMarkerActionsDialog(){
    markerActionsDialogController.sink.add(true);
  }

  void hideMarkerActionsDialog(){
    markerActionsDialogController.sink.add(false);
  }


  @override
  void dispose() {
    markersController.close();
    addressSearchBarController.close();
    markerActionsDialogController.close();
  }

}

final mainMapBloc = MainMapBloc();