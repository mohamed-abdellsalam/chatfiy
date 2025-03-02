import 'package:flutter/material.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble(
      {super.key, required this.message, required this.isCurrentUser});
  final String message;
  final bool isCurrentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 25,
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
