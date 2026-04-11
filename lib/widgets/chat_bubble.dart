import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage chat;

  const ChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final isUser = chat.isUser;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isUser 
                  ? primaryColor.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: isUser ? null : Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Text(
          chat.message,
          style: TextStyle(
            color: isUser ? Colors.white : const Color(0xFF03045E),
            fontSize: 15,
            height: 1.5,
            fontWeight: isUser ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ).animate().fade(duration: 300.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad),
    );
  }
}