import 'package:chatify/auth/auth_gate.dart';
import 'package:chatify/firebase_options.dart';
import 'package:chatify/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Chatify());
}

class Chatify extends StatelessWidget {
  const Chatify({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
        theme: lightMode,
      ),
    );
  }
}
