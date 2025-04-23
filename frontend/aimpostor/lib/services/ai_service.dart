// lib/services/ai_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIService {
  // Base URL for Anthropic API
  final String baseUrl = 'https://api.anthropic.com/v1';

  // API key
  final String apiKey = 'test';

  // Model to use (use the haiku model for quicker responses)
  final String model = 'claude-3-haiku-20240307';

  // Set to false to use the actual API
  bool useMockData = false;

  // Analyze a plant disease from an image
  Future<Map<String, dynamic>> analyzePlantDisease(File imageFile) async {
    try {
      // If using mock data for testing
      if (useMockData) {
        // Simulate API delay
        await Future.delayed(const Duration(seconds: 2));

        // Return mock analysis results
        return {
          'disease_name': 'Late Blight',
          'severity': 'medium',
          'confidence_percentage': 87,
          'symptoms': 'Dark brown spots on leaves with yellowish borders, white fuzzy growth on the underside of leaves in humid conditions',
          'treatment_options': [
            'Remove and destroy infected plant parts',
            'Apply copper-based fungicide',
            'Ensure proper spacing between plants for airflow',
            'Water at the base, avoid wetting leaves'
          ],
          'prevention_tips': [
            'Use resistant varieties',
            'Crop rotation (3-4 year cycle)',
            'Avoid overhead irrigation',
            'Ensure good air circulation',
            'Use disease-free seeds/seedlings'
          ]
        };
      }

      // Convert image to base64
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      print('Image encoded successfully. Size: ${base64Image.length} characters');

      // Prepare the payload
      final Map<String, dynamic> payload = {
        'model': model,
        'max_tokens': 1000,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': 'Analyze this image and determine if it shows a plant with a disease. If it shows a plant with a potential disease, provide a detailed analysis in JSON format with these fields: disease_name, severity (low, medium, high), confidence_percentage (numeric value between 0-100), symptoms, treatment_options (as an array), and prevention_tips (as an array). If the image does not show a plant or a plant with disease, respond with a JSON containing a single field "error" with a message explaining that the image needs to show a plant with disease symptoms.'
              },
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': base64Image
                }
              }
            ]
          }
        ]
      };

      print('Sending request to Anthropic API...');

      // Make API call
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode(payload),
      );

      print('API response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('API call successful. Parsing response...');

        final responseData = jsonDecode(response.body);
        final content = responseData['content'][0]['text'];

        print('API response content: $content');

        // Extract JSON from response
        // Find the start and end of the JSON in the text
        final jsonStart = content.indexOf('{');
        final jsonEnd = content.lastIndexOf('}');

        if (jsonStart != -1 && jsonEnd != -1) {
          final jsonString = content.substring(jsonStart, jsonEnd + 1);
          print('Extracted JSON: $jsonString');

          try {
            final Map<String, dynamic> result = jsonDecode(jsonString);
            print('JSON parsing successful');
            return result;
          } catch (e) {
            print('JSON parsing failed: $e');
            return {
              'error': 'Could not parse the structured data from the response'
            };
          }
        } else {
          print('No JSON found in the response');
          return {
            'error': 'Could not extract structured data from the response'
          };
        }
      } else {
        print('API call failed with status ${response.statusCode}. Body: ${response.body}');
        return {
          'error': 'Failed to analyze image: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error in AI service: $e');
      return {
        'error': 'Failed to analyze image: $e'
      };
    }
  }

  // Chat with the AI about plant health
  Future<String> chatWithAI(String message, {String? context}) async {
    try {
      // For testing purposes
      if (useMockData) {
        await Future.delayed(const Duration(seconds: 1));

        final lowerMessage = message.toLowerCase();

        if (lowerMessage.contains('late blight')) {
          return "Late blight is a serious disease that affects tomatoes and potatoes, caused by the pathogen Phytophthora infestans. It can rapidly kill plants and spread to others.";
        }
        else if (lowerMessage.contains('treatment')) {
          return "For treating plant diseases like late blight, I recommend cultural controls, chemical controls as needed, and preventative measures.";
        }
        else {
          return "I'm happy to help with your plant health questions! To give you the most accurate advice, could you provide more specific details about the symptoms you're seeing?";
        }
      }

      print('Preparing to send chat request to Anthropic API...');

      // Prepare the system prompt
      final systemPrompt = 'You are an agricultural expert assistant. Provide helpful, accurate advice about plant diseases, treatments, and farming best practices. If you\'re unsure about something, acknowledge your limitations and suggest consulting with a local agricultural expert.';

      // Prepare user message with context if available
      final userMessage = context != null
          ? 'Context: $context\n\nQuestion: $message'
          : message;

      // Prepare the payload
      final Map<String, dynamic> payload = {
        'model': model,
        'max_tokens': 1000,
        'messages': [
          {
            'role': 'system',
            'content': systemPrompt
          },
          {
            'role': 'user',
            'content': userMessage
          }
        ]
      };

      print('Sending chat request to Anthropic API with message: $message');

      // Make API call
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode(payload),
      );

      print('Chat API response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Chat API call successful. Parsing response...');
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('content') &&
            responseData['content'] is List &&
            responseData['content'].isNotEmpty &&
            responseData['content'][0].containsKey('text')) {
          final text = responseData['content'][0]['text'];
          print('Extracted response text: ${text.substring(0, min(50, text.length))}...');
          return text;
        } else {
          print('Unexpected response format: $responseData');
          return "I received a response but couldn't understand it. Please try again.";
        }
      } else {
        print('Chat API call failed with status ${response.statusCode}. Body: ${response.body}');
        return "Sorry, I couldn't connect to my knowledge base. Please try again later. (Error ${response.statusCode})";
      }
    } catch (e) {
      print('Error in AI chat service: $e');
      return "Sorry, I encountered an error while processing your request: $e";
    }
  }

  // Helper function for min value
  int min(int a, int b) {
    return a < b ? a : b;
  }
}