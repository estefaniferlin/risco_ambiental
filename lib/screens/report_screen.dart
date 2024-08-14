import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatefulWidget {
  final LatLng location;
  final String userName;

  ReportScreen({required this.location, required this.userName});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Caso seja um navegador web, utilize a galeria
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      }
    } else {
      // Caso seja um dispositivo Android, ofereça opções de câmera ou galeria
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      }
    }
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.isEmpty) return;

    String? imageUrl;

    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('reports/${DateTime.now().millisecondsSinceEpoch}.jpg');
      if (kIsWeb) {
        // Upload no caso de Web
        await storageRef.putData(await _image!.readAsBytes());
      } else {
        // Upload no caso de Android
        await storageRef.putFile(File(_image!.path));
      }
      imageUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('reports').add({
      'description': _descriptionController.text,
      'latitude': widget.location.latitude,
      'longitude': widget.location.longitude,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'user_name': widget.userName,
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reportar Problema')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição do Problema'),
            ),
            SizedBox(height: 10),
            _image == null
                ? Text('Nenhuma imagem selecionada.')
                : kIsWeb
                ? Image.network(_image!.path)
                : Image.file(File(_image!.path)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(kIsWeb ? 'Selecionar Imagem' : 'Capturar Imagem'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReport,
              child: Text('Enviar Reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
