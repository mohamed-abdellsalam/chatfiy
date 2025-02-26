import 'package:chatify/auth/login_or_register.dart';
import 'package:chatify/themes/light_mode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Chatify());
}

class Chatify extends StatelessWidget {
  const Chatify({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginOrRegister(),
        theme: lightMode,
      ),
    );
  }
}
