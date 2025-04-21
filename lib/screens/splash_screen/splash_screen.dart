import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/screens/onBoarding_screen/onboarding_screen.dart';
import 'package:get/get.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../core/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToNextView();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.logo),
          SizeConfig.customSizedBox(null, 30, null),
          Text(
            'FoodLink',
            style: TextStyle(
              fontFamily: AppFonts.titleFont,
              fontSize: 50,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void goToNextView() {
  Future.delayed(const Duration(seconds: 2), () {
    Get.to(() => const OnBoardingScreen(), transition: Transition.fade);
  });
}
