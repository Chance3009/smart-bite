import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/dialogflow/v3.dart' as df;

class AuthService {
  static const _scopes = [df.DialogflowApi.cloudPlatformScope];

  static Future<df.DialogflowApi> getDialogflowApi() async {
    final serviceAccountJson = await rootBundle.loadString('assets/credentials.json');
    final credentials = ServiceAccountCredentials.fromJson(json.decode(serviceAccountJson));
    final client = await clientViaServiceAccount(credentials, _scopes);
    const location = 'asia-southeast1';
    const endpoint = 'https://$location-dialogflow.googleapis.com/';
    return df.DialogflowApi(client, rootUrl: endpoint);
  }
}

class ChatbotService {
  final String projectId;
  final String agentId;
  final String location;

  ChatbotService({
    required this.projectId,
    required this.agentId,
    required this.location,
  });

  Future<String> sendMessage(String sessionId, String message) async {
    final dialogflow = await AuthService.getDialogflowApi();
    final sessionPath = 'projects/$projectId/locations/$location/agents/$agentId/sessions/$sessionId';
    final queryInput = df.GoogleCloudDialogflowCxV3QueryInput(
      languageCode: 'en',
      text: df.GoogleCloudDialogflowCxV3TextInput(text: message),
    );

    final response = await dialogflow.projects.locations.agents.sessions.detectIntent(
      df.GoogleCloudDialogflowCxV3DetectIntentRequest(queryInput: queryInput),
      sessionPath,
    );

    final queryResult = response.queryResult;
    if (queryResult != null && queryResult.responseMessages != null && queryResult.responseMessages!.isNotEmpty) {
      return queryResult.responseMessages!.first.text!.text!.first;
    } else {
      return 'No response from chatbot';
    }
  }
}
