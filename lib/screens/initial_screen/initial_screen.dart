import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/size_config.dart';
import '../authentication_screens/login_screen.dart';
import '../onboarding_screen/onboarding_screen.dart';
import '../roles_screen/roles_screen.dart';
import '../splash_screen/splash_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for the next frame to ensure context is available
    await Future.delayed(Duration.zero);
    
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Load necessary data
        await Provider.of<UsersProvider>(context, listen: false).getUsersById(currentUser.uid);
        await Provider.of<SettingsProvider>(context, listen: false).getSettingsByUserId(currentUser.uid);
        
        // Navigate to RolesScreen
        Get.offAll(() => RolesScreen(user: currentUser));
      } catch (e) {
        // If loading data fails, go to login
        Get.offAll(() => const LoginScreen(firstScreen: true));
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

      if (onboardingComplete) {
        Get.offAll(() => const LoginScreen(firstScreen: true));
      } else {
        Get.offAll(() => const SplashScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
