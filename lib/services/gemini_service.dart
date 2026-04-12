import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class GeminiService {
  final http.Client _client = http.Client();

  String getBaseUrl() {
    // 192.168.1.76 is your computer's local IP address on the current network.
    // This allows physical devices (phones) to connect while on the same Wi-Fi.
    // if (Platform.isAndroid || Platform.isIOS) {
    //   return 'http://192.168.1.76:8080/api';
    // } else {
    //   return 'http://localhost:8080/api';
    // }
    return 'http://194.146.13.53:9000/api';
  }

  Future<bool> testConnection() async {
    try {
      final url = getBaseUrl().replaceFirst('/api', '');
      print('GenAI: Testing connection to: $url');
      final response =
          await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      print('GenAI: Ping response status: ${response.statusCode}');
      return true;
    } catch (e) {
      print('GenAI: Ping failed: $e');
      return false;
    }
  }

  Future<List<Meal>> generateMealsFromIngredients(String ingredients) async {
    try {
      final String fullUrl = '${getBaseUrl()}/meals/generate';
      print('GenAI: Sending request to: $fullUrl');
      print('GenAI: Ingredients: $ingredients');

      final response = await _client
          .post(
            Uri.parse(fullUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'ingredients': ingredients}),
          )
          .timeout(const Duration(seconds: 120));

      print('GenAI: Response status: ${response.statusCode}');
      // Log the body carefully - it might be long
      if (response.body.length > 500) {
        print(
            'GenAI: Response body starts with: ${response.body.substring(0, 500)}...');
      } else {
        print('GenAI: Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = jsonDecode(response.body);
          return data
              .map((json) => Meal.fromJson(json as Map<String, dynamic>, null))
              .toList();
        } catch (parseError) {
          print('GenAI: Parsing error: $parseError');
          throw Exception(
              'Failed to understand server response. Format error.');
        }
      } else {
        throw Exception(
            'Server error: ${response.statusCode}. Please try again later.');
      }
    } catch (e) {
      print('GenAI: Error caught during request: $e');
      if (e is http.ClientException ||
          e.toString().contains('SocketException')) {
        throw Exception(
            'Network error. Ensure your phone is on the same Wi-Fi as your computer (IP: 192.168.1.76) and port 3500 is open in your firewall.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception(
            'The Chef is taking too long (over 2 mins). Please try a simpler request.');
      }
      throw Exception('Oops! $e');
    }
  }
}
