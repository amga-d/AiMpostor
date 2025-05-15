import 'dart:io';

import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class HttpService {
  final String baseUrl =
      'https://aimpostor-889491896780.asia-southeast2.run.app/';

  Future<void> signupUser(String token, String name) async {
    final endpoint = "api/v1/user/signup";
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      // TODO
      body: jsonEncode({'name': name}),
    );
    final result = jsonDecode(response.body);
    print("Backend response: ${result['message']}");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to sign up user');
    }
  }

  Future<Map<String, dynamic>> predictDisease(XFile imageFile) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final endpoint = "api/v1/chats/upload";

    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final fileName = path.basename(imageFile.path);

    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'))
          ..headers['Authorization'] = 'Bearer $token'
          ..files.add(
            await http.MultipartFile.fromPath(
              'plantImage',
              imageFile.path,
              contentType: MediaType.parse(mimeType),
              filename: fileName,
            ),
          );
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Failed to predict disease: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getChatHistory(String chatId) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final endpoint = "api/v1/chats/$chatId";

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        return List<Map<String, dynamic>>.from(responseBody['data']);
      } else {
        throw Exception(
          'Failed to fetch chat history: ${responseBody['message']}',
        );
      }
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Failed to fetch chat history: $error');
    }
  }

  Future<Map<String, dynamic>> predictSeedQuality(File imageFile) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final endpoint = "api/v1/seed/assess";
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final fileName = path.basename(imageFile.path);

    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'))
          ..headers['Authorization'] = 'Bearer $token'
          ..files.add(
            await http.MultipartFile.fromPath(
              'seedImage',
              imageFile.path,
              contentType: MediaType.parse(mimeType),
              filename: fileName,
            ),
          );
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Failed to Assess Seed Quality: $error');
    }
  }

  Future<Map<String, dynamic>> getSeedQualityHistory() async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final endpoint = "api/v1/seed/assessments";
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        return (responseBody['data']);
      } else {
        return {};
      }
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Failed to fetch seed quality history: $error');
    }
  }

  Future<Map<String, dynamic>> getSeedQualityById(String assessmentId) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final endpoint = "api/v1/chats";
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint/$assessmentId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        return (responseBody['data']);
      } else {
        return {};
      }
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Failed to fetch disease history: $error');
    }
  }

  Future<Map<String, dynamic>> getFertilizerRecipe(
    String plant,
    String availableMaterials,
  ) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final endpoint = "api/v1/fertilizer-recipe";
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'plant': plant,
        'availableMaterials': availableMaterials,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['response'] != null &&
          responseBody['response']['message'] == 'success') {
        return responseBody['response']['data'];
      } else {
        throw Exception(
          responseBody['response']?['error'] ?? 'Unknown error occurred',
        );
      }
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body)['error'] ?? 'Invalid input';
      throw Exception('Failed to generate fertilizer recipe: $error');
    } else {
      throw Exception(
        'Failed to generate fertilizer recipe: Internal server error',
      );
    }
  }
}
