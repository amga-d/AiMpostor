import "package:http/http.dart" as http;
import 'dart:convert';

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
}
