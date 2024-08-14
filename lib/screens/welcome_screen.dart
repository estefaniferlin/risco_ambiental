import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import para o mapa
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login'); // Redireciona para a tela de login
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Welcome'),
                Tab(text: 'Map'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text('Welcome to the app! Here you can report environmental issues.'),
                  ),
                  MapScreen(), // Chama a tela do mapa
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela do Mapa
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

  void _onLongPress(LatLng location) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report Issue'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Describe the issue',
            ),
            onSubmitted: (description) {
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId(location.toString()),
                    position: location,
                    infoWindow: InfoWindow(
                      title: description,
                    ),
                  ),
                );
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      onLongPress: _onLongPress,
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: LatLng(-23.550520, -46.633308), // Coordenadas de São Paulo como exemplo
        zoom: 12,
      ),
    );
  }
}
