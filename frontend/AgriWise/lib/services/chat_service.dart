import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agriwise/models/chat_message.dart';

class ChatService {
  final String baseUrl =
      'YOUR_API_BASE_URL'; // Replace with your actual API URL

  Future<List<ChatMessage>> getChatHistory(String chatId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats/$chatId/history'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          List<dynamic> messagesJson = responseData['data'];

          // Filter out system messages and parse to ChatMessage objects
          List<ChatMessage> messages = [];

          for (var message in messagesJson) {
            // Skip the first message with "I uploaded a plant image for disease analysis"
            if (message['sender'] == 'user' &&
                message['content'] ==
                    "I uploaded a plant image for disease analysis.") {
              continue;
            }

            // Handle special model responses that contain disease reports
            if (message['sender'] == 'model' && message['publicUrl'] != null) {
              try {
                // Parse the JSON content that contains the disease report
                final reportData = jsonDecode(message['content']);
                // You can handle the report data here if needed
                continue; // Skip adding this to regular chat messages
              } catch (e) {
                // If parsing fails, treat as a regular message
              }
            }

            messages.add(ChatMessage.fromJson(message));
          }

          // Reverse the order to show oldest messages first
          return messages;
        }
      }
      throw Exception('Failed to load chat history');
    } catch (e) {
      throw Exception('Error fetching chat history: $e');
    }
  }
}
