//import 'ma';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker extends Marker{
  bool bookmarked = false;

  CustomMarker({this.bookmarked, markerId, position, infoWindow, onTap}) : super(


        markerId: markerId,
        position: position,
        infoWindow: infoWindow,
        onTap: onTap
  );

//  Marker(
//  markerId: MarkerId(newMarkerId),
//  position: position,
//  infoWindow: InfoWindow(title: "Marker $newMarkerId", snippet: "*"),
//
//  onTap: () => onTapMarker(newMarkerId)
//  );
}