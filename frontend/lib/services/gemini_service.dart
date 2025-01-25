import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:smart_bite/services/firebase_service.dart';
import 'package:smart_bite/utils/const.dart';

class GeminiService {
  final _model =
      GenerativeModel(model: 'gemini-1.5-pro', apiKey: GEMINI_API_KEY);
  String promptIntro =
      "You are Anna, a AI nutritionist(Mention at first time only).";

  Future<String> generateContent(String prompt) async {
    try {
      // Fetch user data from Firebase
      final userData = await getUserData("BOKkvLQxmnastiwoj7zTit2Ypti2");

      final response = await _model.generateContent([
        Content.text('''
          You are an advanced AI assistant specializing in nutrition and health. Your primary role is to assist users by providing personalized diet tips and creating customized meal plans. Be professional, empathetic, and concise. When the user asks for diet tips, analyze their input, including any specific preferences, goals (e.g., weight loss, muscle gain, maintaining health), dietary restrictions (e.g., allergies, vegetarianism), or cultural considerations. Provide actionable advice tailored to the user’s unique needs. If the user requests a meal plan, craft a detailed, balanced, and practical plan that includes breakfast, lunch, dinner, and snacks, adhering to the provided constraints. Include key nutritional information where relevant, such as calories or macronutrient breakdowns. Always ensure your response is user-friendly, easy to implement, and factually accurate. 
          - Age: ${userData['age']}
          - Gender: ${userData['gender']}
          - Height: ${userData['height']} cm
          - Weight: ${userData['weight']} kg
          - Activity Level: ${userData['activity']}
          - Goal: ${userData['goal']}
          The user’s input is as follows: $prompt
            
            ''')
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

      final String prompt = """
    Analyze the image provided and identify the food items.
    Estimate the calorie content and macronutrient breakdown (proteins, carbs, fats).
    Return the analysis in a JSON format with the following structure:
    {
      "food_items": [
        {"name": "food1", "quantity": "x grams"},
        {"name": "food2", "quantity": "y grams"}
      ],
      "calories": "xxx kcal",
      "macronutrients": {
        "proteins": "x grams",
        "carbs": "y grams",
        "fats": "z grams"
      }
    }
    """;

      final response = await _model.generateContent([
        Content.multi([TextPart("$prompt"), DataPart(mimeType, bytes)])
      ]);

      // Parse and return JSON
      final String geminiAnalysis =
          response.text ?? '{"error": "No analysis result from Anna"}';
      return geminiAnalysis;
    } catch (e) {
      throw Exception('Error generating content: $e');
    }
  }
}
