import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:risco_ambiental/screens/report_screen.dart'; // Importa o diálogo de relatório
import 'package:risco_ambiental/services/report_service.dart'; // Importa o serviço de relatório
import 'package:risco_ambiental/models/report.dart'; // Importa o modelo de dados

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  bool _isDialogOpen = false;
  final ReportService _reportService = ReportService();
  final Map<MarkerId, Marker> _markersDescription = {}; // Mapa para armazenar marcadores e suas descrições

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
          if (!_isDialogOpen) {
            _handleMapTap(location);
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(-29.44927826353563, -52.19958823509937), // Um ponto inicial padrão
          zoom: 15,
        ),
        markers: _markersDescription.values.toSet(), // Atualizado para usar valores dos marcadores
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return _markersDescription.values.toSet();
  }

  void _handleMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _showReportDialog(location);
  }

  void _showReportDialog(LatLng location) async {
    if (_isDialogOpen) return;

    setState(() {
      _isDialogOpen = true;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você precisa estar logado para enviar um relatório.')),
      );
      setState(() {
        _isDialogOpen = false;
      });
      return;
    }

    final userName = user.displayName ?? 'Usuário Desconhecido';

    showDialog(
      context: context,
      barrierDismissible: false, // Não permite fechar o diálogo clicando fora
      builder: (context) {
        return ReportDialog(
          location: location,
          userName: userName,
          onSubmit: (description) async {
            final markerId = MarkerId('marker_${DateTime.now().millisecondsSinceEpoch}');
            final report = Report(
              description: description,
              timestamp: DateTime.now(),
              latitude: location.latitude,
              longitude: location.longitude,
              userName: userName,
            );
            try {
              await _reportService.addReport(report); // Adiciona o relatório ao Firestore
              setState(() {
                _markersDescription[markerId] = Marker(
                  markerId: markerId,
                  position: location,
                  infoWindow: InfoWindow(
                    title: description,
                  ),
                ); // Adiciona o marcador com descrição
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Relatório enviado com sucesso!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao enviar o relatório.')),
              );
            }
            Navigator.of(context).pop(); // Fecha o diálogo
            setState(() {
              _isDialogOpen = false;
            });
          },
        );
      },
    ).then((_) {
      setState(() {
        _isDialogOpen = false;
      });
    });
  }
}