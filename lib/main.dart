import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Ajuste o caminho conforme a estrutura do seu projeto
import 'package:risco_ambiental/screens/welcome_screen.dart';
import 'package:risco_ambiental/screens/login_screen.dart';
import 'package:risco_ambiental/screens/register_screen.dart';
import 'package:risco_ambiental/screens/comments_screen.dart';
import 'package:risco_ambiental/map_state.dart'; // Importa a classe MapState

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapState()), // Adiciona o MapState ao provedor
      ],
      child: MaterialApp(
        title: 'Firebase Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthenticationWrapper(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/welcome': (context) => WelcomeScreen(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return WelcomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
