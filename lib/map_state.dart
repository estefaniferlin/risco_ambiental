import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  Map<MarkerId, Marker> get markers => _markers;

  void addMarker(Marker marker) {
    _markers[marker.markerId] = marker;
    notifyListeners();
  }

  void removeMarker(MarkerId markerId) {
    _markers.remove(markerId);
    notifyListeners();
  }
}
