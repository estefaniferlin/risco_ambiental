import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:risco_ambiental/models/report.dart'; // Importa o modelo de dados

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReport(Report report) async {
    try {
      await _firestore.collection('reports').add(report.toMap());
    } catch (e) {
      print('Error adding report: $e');
    }
  }

  Future<List<Report>> getReports() async {
    try {
      final snapshot = await _firestore.collection('reports').get();
      final reports = <Report>[];
      for (var doc in snapshot.docs) {
        reports.add(Report.fromMap(doc.data()));
      }
      return reports;
    } catch (e) {
      print('Error fetching reports: $e');
      return [];
    }
  }
}