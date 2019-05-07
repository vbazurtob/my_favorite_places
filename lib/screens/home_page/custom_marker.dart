
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker extends Marker{
  final bool bookmarked;

  CustomMarker({this.bookmarked, markerId, position, infoWindow, onTap}) : super(


        markerId: markerId,
        position: position,
        infoWindow: infoWindow,
        onTap: onTap
  );

}