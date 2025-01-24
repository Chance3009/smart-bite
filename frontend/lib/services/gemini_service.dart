import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:smart_bite/utils/const.dart';

class GeminiService {
  final _model =
      GenerativeModel(model: 'gemini-1.5-pro', apiKey: GEMINI_API_KEY);
  String promptIntro = "You are Anna, a AI nutritionist(Mention at first time only).";
  
  Future<String> generateContent(String prompt) async {
    try {
      final response = await _model.generateContent([
        Content.text(
            "$promptIntro Your responsibility is to give the personalised diet tips for users when the user ask for the diet tips and provied customised meal plan to the users if they request (not more than 50 words) . The user input: $prompt")
      ]);
      return response.text ?? 'No response from Anna';
    } catch (e) {
      throw Exception('Error generating content: $e');
    }
  }

  Future<String> analyseImage(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final String mimeType = 'image/jpeg';
      final String prompt = "$promptIntro You need to analyse the nutrient and calories in the meal based on the picture";

      // final content = Content.data(mimeType, image);
      final response = await _model.generateContent([
        Content.multi([TextPart("$prompt"), DataPart(mimeType, bytes)])
      ]);

      final String geminiAnalysis =
          response.text ?? 'No analysis result from Anna';
      return geminiAnalysis;
    } catch (e) {
      throw Exception('Error generating content: $e');
    }
  }
}
