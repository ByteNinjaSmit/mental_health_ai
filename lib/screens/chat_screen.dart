import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/chat_model.dart';
import '../services/gemini_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // We reversed the list order in the logic to use reverse: true in ListView
  List<ChatMessage> messages = [
    ChatMessage(message: "Hi! I'm your AI therapist. How can I support you today?", isUser: false)
  ];

  bool loading = false;

  void sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.insert(0, ChatMessage(message: userMessage, isUser: true));
      loading = true;
    });

    _controller.clear();

    String response = await _geminiService.sendMessage(userMessage);

    if (mounted) {
      setState(() {
        messages.insert(0, ChatMessage(message: response, isUser: false));
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("AI Companion"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // Standard for chat: scrolls from bottom
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(chat: messages[index]);
              },
            ),
          ),

          if (loading) 
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Companion is thinking",
                        style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 12, height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, 
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fade().scale(alignment: Alignment.bottomLeft),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03), 
                  blurRadius: 10, 
                  offset: const Offset(0, -5)
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: "Speak your mind...",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        onSubmitted: (_) => sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                    ),
                  ).animate(target: loading ? 0 : 1).scale(duration: 200.ms),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}