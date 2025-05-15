import 'dart:convert';
import 'package:agriwise/services/http_service.dart';
import 'package:agriwise/models/chat_message.dart';

class ChatService {
  Future<Map<String, dynamic>> getMessagesHistory(String chatId) async {
    try {
      final response = await HttpService().getMessagesHistory(chatId);
      // Filter out system messages and parse to ChatMessage objects
      List<ChatMessage> messages = [];
      Map<String, dynamic> reportData = {};
      // print(response);
      for (var message in response.reversed) {
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
            reportData = {
              'content': jsonDecode(message['content']),
              'publicUrl': message['publicUrl'],
              'detectionDate':
                  message['createdAt'] != null &&
                          message['createdAt']['_seconds'] != null
                      ? DateTime.fromMillisecondsSinceEpoch(
                        (message['createdAt']['_seconds'] * 1000).toInt(),
                      ).toLocal().toString().substring(0, 16)
                      : DateTime.now().toLocal().toString().substring(5, 16),
            };
            // You can handle the report data here if needed
            continue; // Skip adding this to regular chat messages
          } catch (e) {
            // If parsing fails, treat as a regular message
          }
        }
        messages.add(ChatMessage.fromJson(message));
      }
      return {"messages": messages, "reportData": reportData};
    } catch (e) {
      print(e);
      throw Exception('Error fetching chat history: $e');
    }
  }

  Future<String> sendMessage(String chatId, String message) async {
    try {
      final response = await HttpService().sendMessage(chatId, message);
      return response;
    } catch (e) {
      print(e);
      throw Exception('Error sending message: $e');
    }
  }
}
