import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/comment.dart'; // Ajuste o caminho conforme a estrutura do seu projeto

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<Comment>> _commentsStream;

  @override
  void initState() {
    super.initState();
    _commentsStream = _firestore.collection('comments').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return Comment(
          text: data['text'] ?? '',
          latitude: data['latitude'] ?? 0.0,
          longitude: data['longitude'] ?? 0.0,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentários'),
      ),
      body: StreamBuilder<List<Comment>>(
        stream: _commentsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum comentário encontrado.'));
          }

          final comments = snapshot.data!;

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                title: Text(comment.text),
                subtitle: Text('Latitude: ${comment.latitude}, Longitude: ${comment.longitude}'),
                trailing: IconButton(
                  icon: Icon(Icons.map),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/map',
                      arguments: {
                        'latitude': comment.latitude,
                        'longitude': comment.longitude,
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
