import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/meal.dart';
import '../services/meals_services.dart';

class MealsProvider with ChangeNotifier {
  static final MealsProvider _instance = MealsProvider._internal();

  factory MealsProvider() => _instance;

  MealsProvider._internal();

  List<Meal> meals = [];
  final MealsServices _ms = MealsServices();
  bool isLoading = false;
  bool imageIsUploaded = false;
  String? imageUrl;

  void addMeal(Meal meal) async {
    await _ms.addMeal(meal);
  }

  void getAllMealsByCategory(categoryId, userId) async {
    try {
      meals = [];
      isLoading = true;
      QuerySnapshot<Map<String, dynamic>> mealQuery =
          await _ms.getAllMealsByCategory(categoryId, userId);
      for (var doc in mealQuery.docs) {
        Meal meal = Meal(
            name: doc['name'],
            imageUrl: doc['image_url'],
            categoryId: doc['category_id'],
            ingredients: doc['ingredients'],
            recipe: doc['recipe'],
            userId: doc['user_id']);
        meals.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      rethrow;
    }
  }

  Future<String> pickImageFromSource(context) async {
    final picker = ImagePicker();
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );

    final pickedFile = await picker.pickImage(source: source!);
    String? downloadUrl = await _ms.uploadImage(pickedFile!);
    if (downloadUrl != null && downloadUrl!.isNotEmpty) {
      imageIsUploaded = true;
      notifyListeners();
    }
    return downloadUrl!;
  }
}
