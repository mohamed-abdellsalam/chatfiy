import 'package:chatify/components/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
        // actions: [
        //   IconButton(
        //     onPressed: logout,
        //     icon: const Icon(
        //       Icons.logout,
        //     ),
        //   ),
        // ],
      ),
      drawer: const MyDrawer(),
    );
  }
}
