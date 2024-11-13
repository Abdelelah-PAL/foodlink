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
  List<Meal> favoriteMeals = [];
  final MealsServices _ms = MealsServices();
  bool isLoading = false;
  bool imageIsUploaded = false;
  String? imageUrl;

  Future<Meal> addMeal(Meal meal) async {
    var addedMeal = await _ms.addMeal(meal);
    return addedMeal;
  }

  Future<void> toggleIsFavorite(Meal meal, isFavorite) async {
    await _ms.toggleIsFavorite(meal, isFavorite);
  }

  void getAllMealsByCategory(categoryId, userId) async {
    try {
      isLoading = true;
      meals.clear();
      List<Meal> fetchedMeals = await _ms.getAllMealsByCategory(categoryId, userId);
      for (var doc in fetchedMeals) {
        Meal meal = Meal(
          documentId: doc.documentId,
          name: doc.name,
          imageUrl: doc.imageUrl,
          categoryId: doc.categoryId,
          ingredients: doc.ingredients,
          recipe: doc.recipe,
          userId: doc.userId,
          isFavorite: doc.isFavorite
        );
        meals.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  void getFavorites(userId) async {
    try {
      isLoading = true;
      favoriteMeals.clear();
      List<Meal> fetchedMeals = await _ms.getFavorites(userId);
      for (var doc in fetchedMeals) {
        Meal meal = Meal(
          documentId: doc.documentId,
          name: doc.name,
          imageUrl: doc.imageUrl,
          categoryId: doc.categoryId,
          ingredients: doc.ingredients,
          recipe: doc.recipe,
          userId: doc.userId,
          isFavorite: doc.isFavorite,
        );
        favoriteMeals.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
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
    if (downloadUrl != null && downloadUrl.isNotEmpty) {
      imageIsUploaded = true;
      imageUrl = downloadUrl;
      notifyListeners();
    }
    return downloadUrl!;
  }
}
