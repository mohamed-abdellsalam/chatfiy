import 'package:chatify/firebase_options.dart';
import 'package:chatify/services/auth/auth_gate.dart';
import 'package:chatify/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const Chatify(),
    ),
  );
}

class Chatify extends StatelessWidget {
  const Chatify({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}
