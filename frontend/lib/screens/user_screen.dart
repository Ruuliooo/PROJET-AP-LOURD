import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import '../services/session.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Session.isLoggedIn();
    final user = Session.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Espace Utilisateur',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          if (isLoggedIn) ...[
            Text(
              '✅ Connecté avec : ${user!.email}',
              style: const TextStyle(color: Colors.greenAccent),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Session.logout();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Se déconnecter'),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('S\'inscrire'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Se connecter'),
            ),
          ]
        ],
      ),
    );
  }
}
