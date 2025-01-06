class ChatbotService {
  Future<String> getResponse(String userInput) async {
   // Simulate delay
    await Future.delayed(Duration(seconds: 1));
    // Return the simulated response
    return "This is the AI's response：$userInput";
  }
}
