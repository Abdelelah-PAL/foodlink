import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/providers/authentication_provider.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/providers/meal_categories_provider.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/splash_screen/splash_screen.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'core/constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (ctx) => GeneralProvider()),
    ChangeNotifierProvider(create: (ctx) => AuthProvider()),
    ChangeNotifierProvider(create: (ctx) => UsersProvider()),
    ChangeNotifierProvider(create: (ctx) => MealCategoriesProvider()),
    ChangeNotifierProvider(create: (ctx) => DashboardProvider()),
    ChangeNotifierProvider(create: (ctx) => MealsProvider()),
    ChangeNotifierProvider(create: (ctx) => SettingsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadTranslations() async {
    await TranslationService().loadTranslations(context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadTranslations();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.primaryColor),
        checkColor: WidgetStateProperty.all(AppColors.backgroundColor),
      )),
      home: _isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : const SplashScreen(),
    );
  }
}
