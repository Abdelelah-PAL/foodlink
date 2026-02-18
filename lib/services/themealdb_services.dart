import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../controllers/meal_types.dart';

class TheMealDBService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> searchMealsByIngredient(String ingredient) async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?i=$ingredient'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];

      List<Meal> meals = [];
      for (var mealData in data['meals']) {
        meals.add(Meal(
          documentId: mealData['idMeal'],
          name: mealData['strMeal'],
          imageUrl: mealData['strMealThumb'],
          ingredients: [],
          typeId: MealTypes.suggestedMeal,
        ));
      }
      return meals;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<Meal> getMealDetails(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) throw Exception('Meal not found');

      final mealData = data['meals'][0];
      
      List<String> ingredients = [];
      for (int i = 1; i <= 20; i++) {
        final ingredient = mealData['strIngredient$i'];
        final measure = mealData['strMeasure$i'];
        if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
          ingredients.add("${measure ?? ''} $ingredient".trim());
        }
      }

      List<String> recipe = [];
      if (mealData['strInstructions'] != null) {
        String instructions = mealData['strInstructions'].toString();
        
        // Normalize newlines
        String text = instructions.replaceAll('\r\n', '\n').trim();
        
        // regex for "Step 1", "STEP 1", "(step 1)", etc.
        final stepMarkerRegex = RegExp(r'\b\(*Step\s*\d+[:\s\-\)]*', caseSensitive: false);
        
        // If the text contains multiple "Step X" markers, use them as primary splitters
        if (stepMarkerRegex.allMatches(text).length > 1) {
          recipe = text.split(stepMarkerRegex)
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
        } else {
          // Otherwise split by newline and clean each line
          recipe = text.split('\n')
              .map((s) => s.trim())
              .map((s) {
                String cleaned = s;
                // Remove "(Step 1)", "Step 1:", etc. at the start
                cleaned = cleaned.replaceFirst(RegExp(r'^[\(\[\s]*Step\s*\d+[\s\:\-\)\]]*', caseSensitive: false), '');
                // Remove numeric labels like "1." at the start
                cleaned = cleaned.replaceFirst(RegExp(r'^\d+[\.\)\s\-]+'), '');
                return cleaned.trim();
              })
              .where((s) => s.isNotEmpty)
              .toList();
        }
      }

      return Meal(
        documentId: mealData['idMeal'],
        name: mealData['strMeal'],
        imageUrl: mealData['strMealThumb'],
        ingredients: ingredients,
        recipe: recipe,
        typeId: MealTypes.suggestedMeal,
        source: mealData['strSource'],
        categoryId: 1,
      );
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
