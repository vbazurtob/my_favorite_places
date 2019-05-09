import 'dart:async';
import 'dart:core' ;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_favorite_places/screens/home_page/custom_marker.dart';
import 'base_bloc.dart';
import 'package:my_favorite_places/provider/main_map_provider.dart';

class MainMapBloc implements BaseBloc{

  final MainMapProvider mainMapProvider = MainMapProvider();
  final markersController = StreamController();
  final addressSearchBarController = StreamController();
  final markerActionsDialogController = StreamController();
  final selectedMarkerController = StreamController();

  Stream get  getMarkersViaStream => markersController.stream;
  Stream get  addressSearchBarStream => addressSearchBarController.stream;
  Stream get  markerActionsDialogStream => markerActionsDialogController.stream;
  Stream get  getSelectedMarkerStream => selectedMarkerController.stream;


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
    mainMapProvider.searchByAddress = true;
    addressSearchBarController.sink.add(mainMapProvider.searchByAddress );
  }

  void hideAddressSearchBar(){
    mainMapProvider.searchByAddress = false;
    addressSearchBarController.sink.add(mainMapProvider.searchByAddress);
  }

  void showMarkerActionsDialog(){
    mainMapProvider.markerActions = true;
    markerActionsDialogController.sink.add(mainMapProvider.markerActions);
  }

  void hideMarkerActionsDialog(){
    mainMapProvider.markerActions = false;
    markerActionsDialogController.sink.add(mainMapProvider);
  }

  CustomMarker getSelectedMarker(){
    return mainMapProvider.selectedMarker;
  }

  void setSelectedMarker(CustomMarker marker){
    mainMapProvider.selectedMarker = marker;
    selectedMarkerController.sink.add(mainMapProvider.selectedMarker);
  }


  @override
  void dispose() {
    markersController.close();
    addressSearchBarController.close();
    markerActionsDialogController.close();
    selectedMarkerController.close();
  }

}

final mainMapBloc = MainMapBloc();