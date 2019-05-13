

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_favorite_places/screens/home_page/custom_marker.dart';
import 'package:my_favorite_places/screens/home_page/marker_properties.dart';

class MainMapProvider {
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Map<MarkerId, MarkerProperties> markerProperties = <MarkerId, MarkerProperties>{};
  bool searchByAddress = false;
  bool markerActions = false;
  Marker selectedMarker;

  bool get searchBarIsVisible => searchByAddress == true;
  bool get searchBarIsNotVisible => searchByAddress != true;

  bool get markerActionsDialogIsVisible => markerActions == true;
  bool get markerActionsDialogIsNotVisible => markerActions != true;


  void addMarker(Marker marker){
    markers.putIfAbsent( marker.markerId, () => marker );
    markerProperties.putIfAbsent(marker.markerId, () => MarkerProperties(markerId: marker.markerId.toString(), bookmarked:  false) );
  }

  void updateMarkerData(Marker updatedMarker){
    if( markers.containsKey(updatedMarker.markerId) ) {
      markers[updatedMarker.markerId] = updatedMarker;
    }
  }

  void deleteMarker(Marker marker){
    markers.remove(marker.markerId);
  }

  MarkerProperties getMarkerProperties(MarkerId markerId){
    if( markerProperties.containsKey(markerId.toString()) ){
      return markerProperties[markerId.toString()];
    }
    return null;
  }

  void favMarker(MarkerId markerId){
    MarkerProperties mp = getMarkerProperties(markerId);
    mp.bookmarked = true;
  }

  void unFavMarker(MarkerId markerId){
    MarkerProperties mp = getMarkerProperties(markerId);
    mp.bookmarked = false;
  }

}

