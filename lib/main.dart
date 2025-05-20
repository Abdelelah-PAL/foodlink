import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/colors.dart';
import 'providers/authentication_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/features_provider.dart';
import 'providers/general_provider.dart';
import 'providers/meal_categories_provider.dart';
import 'providers/meals_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/task_provider.dart';
import 'providers/users_provider.dart';
import 'screens/auth_screens/login_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'services/translation_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (ctx) => GeneralProvider()),
    ChangeNotifierProvider(create: (ctx) => AuthenticationProvider()),
    ChangeNotifierProvider(create: (ctx) => UsersProvider()),
    ChangeNotifierProvider(create: (ctx) => MealCategoriesProvider()),
    ChangeNotifierProvider(create: (ctx) => DashboardProvider()),
    ChangeNotifierProvider(create: (ctx) => MealsProvider()),
    ChangeNotifierProvider(create: (ctx) => SettingsProvider()),
    ChangeNotifierProvider(create: (ctx) => NotificationsProvider()),
    ChangeNotifierProvider(create: (ctx) => FeaturesProvider()),
    ChangeNotifierProvider(create: (ctx) => TaskProvider()),
  ], child:  MyApp(startingWidget: onboardingComplete == true ? const LoginScreen(firstScreen: true,) : const SplashScreen())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.startingWidget});
  final Widget startingWidget;

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
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
        scaffoldBackgroundColor: AppColors.backgroundColor,
          checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors
                .primaryColor;
          }
          return AppColors.backgroundColor;
        }),
        checkColor: WidgetStateProperty.all(AppColors.backgroundColor),
      )),
      home: _isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          :  widget.startingWidget,
    );
  }
}
