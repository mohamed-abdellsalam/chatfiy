import 'package:chatify/components/my_button.dart';
import 'package:chatify/components/my_text_field.dart';
import 'package:chatify/services/auth/auth_service.dart';
import 'package:chatify/utils/app_styls.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Show error message
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Registration Failed",
          style: AppStyles.styleSemiBold16(context),
        ),
        content: Text(
          message,
          style: AppStyles.styleRegular14(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: AppStyles.styleMedium16(context),
            ),
          ),
        ],
      ),
    );
  }

  // Register function
  Future<void> register() async {
    final auth = AuthService();

    // Input validation
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

    // Validate email format
    if (!_isValidEmail(_emailController.text.trim())) {
      _showErrorDialog("Please enter a valid email address.");
      return;
    }

    // Password match validation
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    // Set loading state
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      await auth.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(), // Pass the name
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 50),
                Text(
                  "Let's create an account for you",
                  style: AppStyles.styleMedium20(context),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  hintText: 'Email',
                  obscureText: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: 'Your name',
                  obscureText: false,
                  controller: _nameController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: 'Password',
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: 'Confirm Password',
                  obscureText: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: 'Register',
                        onTap: register,
                      ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppStyles.styleRegular16(context),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now',
                        style: AppStyles.styleBold16(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
