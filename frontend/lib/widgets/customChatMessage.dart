import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

// Custom ChatMessage widget to format the message as desired
class CustomChatMessage extends StatelessWidget {
  final ChatUser user;
  final DateTime createdAt;
  final String text;
  final Map<String, dynamic> customData;  // Additional data for customized formatting

  const CustomChatMessage({
    Key? key,
    required this.user,
    required this.createdAt,
    required this.text,
    required this.customData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can format and customize the chat message display here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMessageBody(),    // Body of the message with text content
      ],
    );
  }

  // Body that displays the message text
  Widget _buildMessageBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (customData['formatted'] != null) 
            _buildFormattedResponse(customData['formatted']),
        ],
      ),
    );
  }

  // Display a formatted response from Gemini's API
  Widget _buildFormattedResponse(String formattedResponse) {
    return Text(
      formattedResponse,
      style: TextStyle(fontSize: 16, color: Colors.blueAccent),  // Style the formatted response differently
    );
  }

  // Helper function to format the timestamp
  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute}";
  }
}
