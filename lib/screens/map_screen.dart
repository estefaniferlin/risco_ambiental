import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'report_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (LatLng location) {
          setState(() {
            _selectedLocation = location;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Um ponto inicial padrão
          zoom: 10,
        ),
        markers: _selectedLocation != null
            ? {
          Marker(
            markerId: MarkerId('selected-location'),
            position: _selectedLocation!,
          ),
        }
            : {},
      ),
      floatingActionButton: _selectedLocation != null
          ? FloatingActionButton(
        onPressed: _navigateToReportScreen,
        child: Icon(Icons.report_problem),
      )
          : null,
    );
  }

  void _navigateToReportScreen() async {
    // Obtenha o nome do usuário atual (assumindo que o usuário está logado)
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'Usuário Desconhecido';

    if (_selectedLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportScreen(
            location: _selectedLocation!,
            userName: userName,
          ),
        ),
      );
    }
  }
}
