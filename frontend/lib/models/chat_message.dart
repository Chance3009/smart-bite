class ChatMessage {
  final String? text;
  final String? name;
  final bool? type; // true for user message, false for bot message

  ChatMessage({this.text, this.name, this.type});
}
