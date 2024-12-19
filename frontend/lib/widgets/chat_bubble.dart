import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.type == true ? myMessage(context) : otherMessage(context),
      ),
    );
  }

  List<Widget> myMessage(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(message.name ?? "", style: Theme.of(context).textTheme.titleMedium),
            Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(message.text ?? "", style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(message.name?[0] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ];
  }

  List<Widget> otherMessage(BuildContext context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: const CircleAvatar(
          child: Text('B'),
          backgroundColor: Colors.white,
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(message.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(message.text ?? ""),
            ),
          ],
        ),
      ),
    ];
  }
}
