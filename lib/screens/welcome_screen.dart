import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import para o mapa
import 'package:firebase_auth/firebase_auth.dart';

import 'map_screen.dart';
import 'comments_screen.dart'; // Importe a tela de comentários

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-Vindo'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        backgroundColor: Colors.green[700], // Cor de fundo do AppBar
      ),
      body: DefaultTabController(
        length: 3, // Número de abas
        child: Column(
          children: [
            Container(
              color: Colors.green[200], // Cor de fundo do TabBar
              child: TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorWeight: 4.0,
                tabs: [
                  Tab(text: 'Bem-Vindo'),
                  Tab(text: 'Mapa'),
                  Tab(text: 'Comentários'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildWelcomeTab(),
                  MapScreen(), // Tela do mapa
                  CommentsScreen(), // Tela de comentários
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Bem-Vindo ao App!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Com essa aplicação você pode reportar problemas ambientais que encontrar por onde passar. O meio ambiente agradece sua ajuda!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
