

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMapProvider {
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool searchByAddress = false;
  bool markerActions = false;

  bool get searchBarIsVisible => searchByAddress == true;
  bool get searchBarIsNotVisible => searchByAddress != true;

  bool get markerActionsDialogIsVisible => markerActions == true;
  bool get markerActionsDialogIsNotVisible => markerActions != true;


  void addMarker(Marker marker){
    markers.putIfAbsent( marker.markerId, () => marker );
  }

  void updateMarkerData(Marker updatedMarker){
    if( markers.containsKey(updatedMarker.markerId) ) {
      markers[updatedMarker.markerId] = updatedMarker;
    }
  }

  void deleteMarker(Marker marker){
    markers.remove(marker.markerId);
  }

}