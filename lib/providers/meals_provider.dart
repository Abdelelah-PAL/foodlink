import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/meal_controller.dart';
import '../models/meal.dart';
import '../models/weekly_plan.dart';
import '../services/meals_services.dart';

class MealsProvider with ChangeNotifier {
  static final MealsProvider _instance = MealsProvider._internal();

  factory MealsProvider() => _instance;

  MealsProvider._internal();

  DateTime today = DateTime.now();

  List<Meal> meals = [];
  List<Meal> plannedMeals = [];
  List<Meal> favoriteMeals = [];
  List<WeeklyPlan> weeklyPlans = [];
  final MealsServices _ms = MealsServices();
  bool isLoading = false;
  bool imageIsPicked = false;
  bool chosenPressed = true;
  bool selfPressed = false;

  List<String?> selectedValues = List.filled(7, null);
  List<bool> showSelectedValues = List.filled(7, true); // 10 items, all false

  XFile? pickedFile;
  int numberOfIngredients = 2;
  int numberOfSteps = 2;
  List<TextEditingController> ingredientsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> stepsControllers = [
    TextEditingController(),
  ];
  List<bool> checkboxValues = [];
  DateTime? currentStartDate;
  List<Map<String, dynamic>> weeklyPlanList = [];
  WeeklyPlan? currentWeekPlan;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> days = List.generate(31, (index) => '${index + 1}');
  String? selectedDay;
  String? selectedMonth;
  String? selectedDayName;
  String? selectedPlanningMealValue;

  Future<Meal> addMeal(Meal meal) async {
    var addedMeal = await _ms.addMeal(meal);
    return addedMeal;
  }

  Future<Meal> updateMeal(Meal meal) async {
    Meal updatedMeal = await _ms.updateMeal(meal);
    return updatedMeal;
  }

  Future<void> deleteMeal(String docId) async {
    await _ms.deleteMeal(docId);
  }

  Future<Meal> getMealById(String docId) async {
    Meal meal = await _ms.getMealById(docId);
    return meal;
  }

  Future<Meal> getPlannedMealById(String docId) async {
    Meal meal = await _ms.getPlannedMealById(docId);
    return meal;
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
    await getFavorites(meal.userId!, forceRefresh: true);
  }

  Future<void> getAllMealsByCategory(categoryId, userId) async {
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
            isFavorite: doc.isFavorite,
            isPlanned: doc.isPlanned,
            source: doc.source);
        meals.add(meal);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  void getAllPlannedMeals() async {
    try {
      isLoading = true;
      plannedMeals.clear();
      List<Meal> fetchedMeals = await _ms.getAllPlannedMeals();
      for (var doc in fetchedMeals) {
        Meal meal = Meal(
            documentId: doc.documentId,
            name: doc.name,
            imageUrl: doc.imageUrl,
            ingredients: doc.ingredients,
            recipe: doc.recipe,
            day: doc.day,
            date: doc.date,
            isPlanned: doc.isPlanned,
            source: doc.source);
        plannedMeals.add(meal);
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

  Future<Map<String, dynamic>?> fetchLatestDishOfTheWeek() async {
    return await _ms.fetchLatestDishOfTheWeek();
  }

  Future<void> deleteImage(imageUrl) async {
    await _ms.deleteImage(imageUrl);
  }

  void resetValues() {
    imageIsPicked = false;
    pickedFile = null;
    numberOfIngredients = 2;
    numberOfSteps = 2;
    MealController().sourceController.clear();
    MealController().nameController.clear();
    ingredientsControllers = [
      TextEditingController(),
    ];
    stepsControllers = [
      TextEditingController(),
    ];
    ingredientsControllers.map((controller) => {controller.clear()});
    stepsControllers.map((controller) => {controller.clear()});
    notifyListeners();
  }

  void increaseIngredients() {
    numberOfIngredients++;
    ingredientsControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeIngredient(index) {
    numberOfIngredients--;
    ingredientsControllers.removeAt(index);
    notifyListeners();
  }

  void increaseSteps() {
    numberOfSteps++;
    stepsControllers.add(TextEditingController());
    notifyListeners();
  }
  void removeStep(index) {
    numberOfSteps--;
    stepsControllers.removeAt(index);
    notifyListeners();
  }

  void fillDataForEdition(meal) {
    MealController().nameController.text = meal.name;
    MealController().sourceController.text = meal.source ?? "";
    numberOfIngredients = meal.ingredients.length + 1;
    meal.ingredients.asMap().forEach((index, controller) {
      if (index + 1 > ingredientsControllers.length) {
        ingredientsControllers.add(TextEditingController());
      }
      ingredientsControllers[index].text = meal.ingredients[index];
    });
    numberOfSteps = meal.recipe.length + 1;
    meal.recipe.asMap().forEach((index, controller) {
      if (index + 1 > stepsControllers.length) {
        stepsControllers.add(TextEditingController());
      }
      stepsControllers[index].text = meal.recipe[index];
    });
    notifyListeners();
  }

  void toggleCheckedIngredient(value, listIndex) {
    checkboxValues[listIndex] = value;
    notifyListeners();
  }

  void setDefaultDate() {
    selectedDay = DateTime.now().day.toString();
    selectedMonth = months[DateTime.now().month - 1];
  }

  onChosenTapped() {
    chosenPressed = true;
    selfPressed = false;
    notifyListeners();
  }

  onSelfTapped() {
    chosenPressed = false;
    selfPressed = true;
    notifyListeners();
  }

  void goToPreviousWeek() {
    currentStartDate = currentStartDate!.subtract(const Duration(days: 7));
    notifyListeners();
  }

  void goToNextWeek() {
    currentStartDate = currentStartDate!.add(const Duration(days: 7));
    notifyListeners();
  }

  Future<void> resetDropdownValues() async {
    selectedValues = List.filled(7, null);
    notifyListeners();
  }

  void setPlanInterval() {
    currentStartDate = MealController.getPreviousSaturday(
        DateTime(today.year, today.month, today.day));
  }

  Future<WeeklyPlan> addWeeklyPlan(WeeklyPlan weeklyPlan) async {
    var addedWeeklyPlan = await _ms.addWeeklyPlan(weeklyPlan);
    return addedWeeklyPlan;
  }

  void resetWeeklyPlanList() {
    weeklyPlanList.clear();
    notifyListeners();
  }

  Future<void> getAllWeeklyPlans(userId) async {
    try {
      isLoading = true;
      weeklyPlans.clear();
      List<WeeklyPlan> fetchedWeeklyPlans = await _ms.getAllWeeklyPlans(userId);
      for (var doc in fetchedWeeklyPlans) {
        WeeklyPlan fetchedWeeklyPlan = WeeklyPlan(
            documentId: doc.documentId,
            daysMeals: doc.daysMeals,
            userId: userId,
            intervalEndTime: doc.intervalEndTime,
            intervalStartTime: doc.intervalStartTime);
        doc.daysMeals.sort((a, b) => a.entries.first.value
            .toDate()
            .compareTo(b.entries.first.value.toDate()));

        weeklyPlans.add(fetchedWeeklyPlan);
      }
      getCurrentWeekPlan();
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  void getCurrentWeekPlan() {
    if (weeklyPlans.isNotEmpty) {
      weeklyPlanList = [];
      currentWeekPlan = null;
      currentWeekPlan = weeklyPlans
          .where((object) =>
              object.intervalStartTime.year == currentStartDate!.year &&
              object.intervalStartTime.month == currentStartDate!.month &&
              object.intervalStartTime.day == currentStartDate!.day)
          .firstOrNull;
      if (currentWeekPlan != null) {
        Future.microtask(() {
          weeklyPlanList = currentWeekPlan!.daysMeals;
          notifyListeners();
        });
      }
    }
  }

  void resetShowSelectedValue(index) {
    showSelectedValues[index] = false;
    notifyListeners();
  }

  void setShowSelectedValue(index) {
    showSelectedValues[index] = true;
    notifyListeners();
  }

  Future<void> deleteWeeklyPlan() async {
    await _ms.deleteWeeklyPlan(currentWeekPlan!.documentId!);
  }
}
