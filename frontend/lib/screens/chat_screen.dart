import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../services/chatbot_service.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ChatbotService _chatClient = ChatbotService(
    projectId: 'smart-bite-444717',
    agentId: 'fc6dc903-2b3b-4d44-a3b3-7899ca1892fb',
    location: 'asia-southeast1',
  );

  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;

    final userMessage = ChatMessage(text: text, name: "You", type: true);
    setState(() {
      _messages.insert(0, userMessage);
    });

    _chatController.clear();

    final response = await _chatClient.sendMessage('1', text);
    final botMessage = ChatMessage(text: response, name: "Bot", type: false);

    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF325C2D),
        title: const Text("SMART BITE", style: TextStyle(color: Color(0xFFF6E08A))),
      ),
      body: Container(
        color: Color(0xFFF5EDCA),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (context, index) => ChatBubble(message: _messages[index]),
                itemCount: _messages.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _chatController,
                      onSubmitted: _handleSubmitted,
                      decoration: const InputDecoration.collapsed(hintText: "Type a message"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_chatController.text),
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
