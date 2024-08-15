// report_list_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:risco_ambiental/services/report_service.dart';
import 'package:risco_ambiental/models/report.dart';

class ReportListScreen extends StatefulWidget {
  final GoogleMapController mapController;

  ReportListScreen({required this.mapController});

  @override
  _ReportListScreenState createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ReportService _reportService = ReportService();
  List<Report> _reports = [];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final reports = await _reportService.getReports();
      setState(() {
        _reports = reports;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os relatórios.')),
      );
    }
  }

  void _centerMap(LatLng location) {
    widget.mapController.animateCamera(
      CameraUpdate.newLatLng(location),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
      ),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return ListTile(
            title: Text(report.description),
            subtitle: Text('Lat: ${report.latitude}, Lng: ${report.longitude}'),
            trailing: IconButton(
              icon: Icon(Icons.map),
              onPressed: () {
                _centerMap(LatLng(report.latitude, report.longitude));
              },
            ),
          );
        },
      ),
    );
  }
}
