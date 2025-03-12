import 'package:chatify/components/my_button.dart';
import 'package:chatify/components/my_text_field.dart';
import 'package:chatify/services/auth/auth_service.dart';
import 'package:chatify/themes/theme_provider.dart';
import 'package:chatify/utils/app_styls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isButtonPressed = false;
  bool _isNameChanged = false;
  String _originalName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _nameController.addListener(_checkNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _loadUserName() async {
    try {
      String userId = _authService.getCurrentUser()!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        String fetchedName = userDoc['name'] ?? '';
        setState(() {
          _nameController.text = fetchedName;
          _originalName = fetchedName;
          _isNameChanged = false;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to load user name: $e');
    }
  }

  void _checkNameChanged() {
    String trimmedName = _nameController.text.trim();
    setState(() {
      _isNameChanged = trimmedName.isNotEmpty && trimmedName != _originalName;
    });
  }

  void _saveUserName() async {
    String newName = _nameController.text.trim();

    if (newName.isEmpty) {
      _showErrorDialog('Name cannot be empty.');
      return;
    }

    try {
      String userId = _authService.getCurrentUser()!.uid;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'name': newName});
      setState(() {
        _originalName = newName;
        _isNameChanged = false;
      });

      _showSuccessDialog('Name updated successfully!');
    } catch (e) {
      _showErrorDialog('Failed to update name: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message, style: AppStyles.styleRegular16(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message, style: AppStyles.styleRegular16(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: Text('Settings', style: AppStyles.styleSemiBold20(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              hintText: 'Name',
              obscureText: false,
              controller: _nameController,
            ),
            const SizedBox(height: 16),

            // Show button only if name is changed
            if (_isNameChanged)
              GestureDetector(
                onTapDown: (_) => setState(() => _isButtonPressed = true),
                onTapUp: (_) {
                  setState(() => _isButtonPressed = false);
                  _saveUserName();
                },
                onTapCancel: () => setState(() => _isButtonPressed = false),
                child: AnimatedOpacity(
                  opacity: _isButtonPressed ? 0.6 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: MyButton(
                    text: 'Save',
                    onTap: _saveUserName,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Dark Mode Toggle
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dark Mode', style: AppStyles.styleMedium16(context)),
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
