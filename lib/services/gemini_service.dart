import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class GeminiService {
  String getBaseUrl() {
      return 'http://127.0.0.1:3500/api';
  }

  Future<List<Meal>> generateMealsFromIngredients(String ingredients) async {
    try {
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/meals/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ingredients': ingredients}),
      );
      print(response);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Meal.fromJson(json as Map<String, dynamic>, null)).toList();
      } else {
        throw Exception('Failed to generate meals. Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception while generating meals: $e');
    }
  }
}
