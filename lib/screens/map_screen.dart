import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Description'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Describe the issue',
            ),
            onSubmitted: (description) {
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId(position.toString()),
                    position: position,
                    infoWindow: InfoWindow(title: description),
                  ),
                );
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onTap,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default location (San Francisco)
          zoom: 10,
        ),
      ),
    );
  }
}
