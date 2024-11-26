import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../models/meal.dart';
import '../models/notification.dart';
import '../models/user_details.dart';
import '../services/meals_services.dart';
import '../services/translation_services.dart';

class MealsProvider with ChangeNotifier {
  static final MealsProvider _instance = MealsProvider._internal();

  factory MealsProvider() => _instance;

  MealsProvider._internal();

  List<Meal> meals = [];
  List<Meal> favoriteMeals = [];
  List<Notifications> notifications = [];
  final MealsServices _ms = MealsServices();
  bool isLoading = false;
  bool imageIsPicked = false;
  XFile? pickedFile;
  int numberOfIngredients = 8;
  List<TextEditingController> ingredientsControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<bool> checkboxValues = [];

  bool isIngredientChecked = false;

  Future<Meal> addMeal(Meal meal) async {
    var addedMeal = await _ms.addMeal(meal);
    return addedMeal;
  }

  Future<Meal> updateMeal(Meal meal) async {
    Meal updatedMeal = await _ms.updateMeal(meal);
    return updatedMeal;
  }

  Future<void> getFavorites(String userId, {bool forceRefresh = false}) async {
    if (isLoading || (!forceRefresh && favoriteMeals.isNotEmpty)) return;
    try {
      isLoading = true;
      favoriteMeals.clear();
      List<Meal> fetchedMeals = await _ms.getFavorites(userId);
      favoriteMeals.addAll(fetchedMeals);
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> toggleIsFavorite(Meal meal, bool isFavorite) async {
    await _ms.toggleIsFavorite(meal, isFavorite);
    await getFavorites(meal.userId, forceRefresh: true);
  }

  void getAllMealsByCategory(categoryId, userId) async {
    try {
      isLoading = true;
      meals.clear();
      List<Meal> fetchedMeals =
          await _ms.getAllMealsByCategory(categoryId, userId);
      for (var doc in fetchedMeals) {
        Meal meal = Meal(
            documentId: doc.documentId,
            name: doc.name,
            imageUrl: doc.imageUrl,
            categoryId: doc.categoryId,
            ingredients: doc.ingredients,
            recipe: doc.recipe,
            userId: doc.userId,
            isFavorite: doc.isFavorite);
        meals.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> pickImageFromSource(BuildContext context) async {
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

    XFile? file = await picker.pickImage(source: source!);

    if (file != null) {
      pickedFile = XFile(file.path);
      imageIsPicked = true;
    }
    notifyListeners();
  }

  Future<String> uploadImage(image) async {
    String? downloadUrl = await _ms.uploadImage(image);
    return downloadUrl!;
  }

  Future<Notifications> addNotification(Notifications notification) async {
    var addedNotification = await _ms.addNotification(notification);
    return addedNotification;
  }
  Future<void> getAllNotifications(userTypeId, userId) async {
    try {
      isLoading = true;
      notifications.clear();


      List<Notifications> fetchedNotifications =
      await _ms.getAllNotifications(userTypeId, userId);
      for (var doc in fetchedNotifications) {
        Notifications notification = Notifications(
            userId: doc.userId,
            imageUrl: doc.imageUrl,
            userTypeId: doc.userTypeId,
            mealName: doc.mealName,
            timestamp: doc.timestamp
        );
        notifications.add(notification);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
        isLoading = false;
      rethrow;
    }
  }

  void resetValues() {
    imageIsPicked = false;
    pickedFile = null;
    numberOfIngredients = 8;
    MealController().recipeController.clear();
    MealController().ingredientsController.clear();
    MealController().nameController.clear();
    ingredientsControllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
    ingredientsControllers.map((controller) => {controller.clear()});
    notifyListeners();
  }

  void increaseIngredients() {
    numberOfIngredients++;
    ingredientsControllers.add(TextEditingController());
    notifyListeners();
  }

  void fillDataForEdition(meal) {
    MealController().nameController.text = meal.name;
    MealController().recipeController.text = meal.recipe ?? "";
    numberOfIngredients = meal.ingredients.length;
    meal.ingredients.asMap().forEach((index, controller) {
      if (index + 1 > ingredientsControllers.length) {
        ingredientsControllers.add(TextEditingController());
      }
      ingredientsControllers[index].text = meal.ingredients[index];
    });
    notifyListeners();
  }

  void toggleCheckedIngredient(value, listIndex) {
    checkboxValues[listIndex] = value;
    notifyListeners();
  }
}
