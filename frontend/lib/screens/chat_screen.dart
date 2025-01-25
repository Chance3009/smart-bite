import 'dart:convert';
import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_bite/services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1", firstName: "Anna", profileImage: "assets/chatbot_profile.png");
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
    final geminiResponse = _buildGeminiMessage(response);
    setState(() {
      messages = [geminiResponse, ...messages];
    });
  }

  ChatMessage _buildGeminiMessage(String response) {
    return ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: response,
    );
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
      final geminiResponse = _buildGeminiMessage(_formatGeminiResponse(response));
      setState(() {
        messages = [geminiResponse, ...messages];
      });
    }
  }

  String _formatGeminiResponse(String response) {
    String cleanedResponse =
        response.replaceAll(RegExp(r"^```json\s*|\s*```$"), "").trim();

    try {
      if (cleanedResponse.isEmpty) {
        return "Received an empty response from Gemini.";
      }

      final Map<String, dynamic> jsonResponse = jsonDecode(cleanedResponse);

      String formattedResponse = "";

      if (jsonResponse['food_items'] != null) {
        formattedResponse += "Food Items:\n";
        for (var item in jsonResponse['food_items']) {
          formattedResponse += "${item['name']} - ${item['quantity']}\n";
        }
      }

      if (jsonResponse['calories'] != null) {
        formattedResponse += "\nTotal Calories: ${jsonResponse['calories']}\n";
      }

      if (jsonResponse['macronutrients'] != null) {
        formattedResponse += "\nMacronutrients:\n";
        formattedResponse +=
            "Proteins: ${jsonResponse['macronutrients']['proteins']} grams\n";
        formattedResponse +=
            "Carbs: ${jsonResponse['macronutrients']['carbs']} grams\n";
        formattedResponse +=
            "Fats: ${jsonResponse['macronutrients']['fats']} grams\n";
      }

      return formattedResponse;
    } catch (e) {
      print("Error in parsing the response: $e");
      return "Error in parsing the response. Please check the data format.";
    }
  }

  Widget _buildGeminiResponse(String response) {
    final formattedResponse = _formatGeminiResponse(response);

    return Column(
      children: [
        _buildSection("Food Items", formattedResponse),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(content, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
