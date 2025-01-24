import 'dart:convert';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_bite/services/gemini_service.dart';
import 'package:smart_bite/utils/const.dart';

class ChatScreenTest extends StatefulWidget {
  const ChatScreenTest({super.key});

  @override
  State<ChatScreenTest> createState() => _ChatScreenTestState();
}

class _ChatScreenTestState extends State<ChatScreenTest> {
  final TextEditingController messageController = TextEditingController();
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Anna",
      profileImage: "assets/chatbot_profile.png");
  List<ChatMessage> messages = [];
  final ImagePicker picker = ImagePicker();
  final GeminiService _geminiService = GeminiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: AssetImage('assets/chatbot_profile.png')),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Anna", style: TextStyle(fontSize: 20)),
                Text("Online", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: _buildUI(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: "Chatbot",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            //Current page, no action required
          } else if (index == 1) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      messageOptions:
          MessageOptions(currentUserContainerColor: Colors.green.shade400),
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            onPressed: _selectImage,
            icon: Icon(Icons.image),
          ),
        ],
        alwaysShowSend: true,
        sendOnEnter: true,
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    final String response =
        await _geminiService.generateContent(chatMessage.text);
    final geminiResponse = ChatMessage(
        user: geminiUser, createdAt: DateTime.now(), text: response);
    setState(() {
      messages = [geminiResponse, ...messages];
    });
  }

  Future<void> _selectImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final chatMedia = ChatMedia(
          url: pickedFile!.path,
          fileName: 'image message',
          type: MediaType.image);
      final imageMessage = ChatMessage(
          createdAt: DateTime.now(), user: currentUser, medias: [chatMedia]);
      setState(() {
        messages = [imageMessage, ...messages];
      });

      final response = await _geminiService.analyseImage(File(pickedFile.path));
      final geminiResponse = ChatMessage(
          user: geminiUser, createdAt: DateTime.now(), text: response);
      setState(() {
        messages = [geminiResponse, ...messages];
      });
    }
  }
}
