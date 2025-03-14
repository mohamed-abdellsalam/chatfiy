import 'package:chatify/components/my_drawer.dart';
import 'package:chatify/components/user_tile.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/services/auth/auth_service.dart';
import 'package:chatify/services/chat/chat_services.dart';
import 'package:chatify/utils/app_styls.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  void logout() async {
    await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: Text(
          'Home',
          style: AppStyles.styleSemiBold20(context),
        ),
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
          return Center(
            child: Text(
              'Error loading users',
              style: AppStyles.styleRegular16(context),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No users available',
              style: AppStyles.styleRegular16(context),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(snapshot.data![index], context);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    final currentUserEmail = _authService.getCurrentUser()?.email;

    if (userData["email"] == currentUserEmail) {
      return const SizedBox(); // Hide current user from list
    }

    return UserTile(
      text: userData["name"] ?? userData["email"],
      textStyle: AppStyles.styleMedium16(context),
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
  }
}
