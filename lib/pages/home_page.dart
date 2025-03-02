import 'package:chatify/components/my_drawer.dart';
import 'package:chatify/components/user_tile.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/services/auth/auth_service.dart';
import 'package:chatify/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
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
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatServices.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>(
                (userData) => _buildUserListItem(userData, context),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Return an empty container if the user is the current user
    }
  }
}
