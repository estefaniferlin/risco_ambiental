import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ReportDialog extends StatefulWidget {
  final LatLng location;
  final String userName;
  final Function(String) onSubmit;

  ReportDialog({
    required this.location,
    required this.userName,
    required this.onSubmit,
  });

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enviar apontamento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Descrição'),
          ),
          SizedBox(height: 16),
          Text('Localização: ${widget.location.latitude}, ${widget.location.longitude}'),
          SizedBox(height: 16),
          Text('Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'), // Formata a data
          SizedBox(height: 16),
          Text('Usuário: ${widget.userName}'), // Exibe o nome do usuário
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o diálogo sem enviar o relatório
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final description = _descriptionController.text;
            if (description.isNotEmpty) {
              widget.onSubmit(description);
            }
          },
          child: Text('Enviar'),
        ),
      ],
    );
  }
}
