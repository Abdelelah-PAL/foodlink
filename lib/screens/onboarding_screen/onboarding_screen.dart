import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../models/onboarding_content.dart';
import '../../services/translation_services.dart';
import '../OnBoarding_screen/widgets/dot.dart';
import '../auth_screens/sign_up_screen.dart';
import 'widgets/onboarding_body.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<OnBoardingContent> onBoardingContentList = [];

  void goToNextPage() {
    _pageController.jumpToPage(_currentIndex + 1);
  }

  void _startAutoPageJump() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentIndex == 2) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
          AuthController().completeOnboarding();
        }
        _startAutoPageJump();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoPageJump();
  }

  @override
  Widget build(BuildContext context) {
    List<OnBoardingContent> onBoardingContentList = [
      OnBoardingContent(
        imageURL: Assets.onBoarding1,
        firstTextSpan: TranslationService().translate('on_boarding_1_A'),
        secondTextSpan: TranslationService().translate('on_boarding_1_B'),
        thirdTextSpan: TranslationService().translate('on_boarding_1_C'),
      ),
      OnBoardingContent(
        imageURL: Assets.onBoarding2,
        firstTextSpan: TranslationService().translate('on_boarding_2_A'),
        secondTextSpan: TranslationService().translate('on_boarding_2_B'),
      ),
      OnBoardingContent(
        imageURL: Assets.pureLogo,
        firstTextSpan: TranslationService().translate('on_boarding_3_A'),
        secondTextSpan: TranslationService().translate('on_boarding_3_B'),
        thirdTextSpan: TranslationService().translate('on_boarding_3_C'),
      )
    ];
    return GestureDetector(
      onTap: goToNextPage,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizeConfig.customSizedBox(
              null,
              SizeConfig.screenHeight! * 0.8,
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                // Disable swiping
                onPageChanged: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                itemCount: onBoardingContentList.length,
                itemBuilder: (context, index) {
                  return SizeConfig.customSizedBox(
                    double.infinity,
                    null,
                    OnBoardingBody(
                      content: onBoardingContentList[index],
                    ),
                  );
                },
              ),
            ),
            SizeConfig.customSizedBox(null, 60, null),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(onBoardingContentList.length, (index) {
                  return Dot(isSelected: index == _currentIndex);
                }),
              ],
            ),
            _currentIndex == onBoardingContentList.length - 1
                ? Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.getProportionalWidth(10),
                  top: SizeConfig.getProportionalHeight(20),
                  bottom: SizeConfig.getProportionalHeight(70)),
            )
                : Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.getProportionalWidth(10),
                    top: SizeConfig.getProportionalHeight(20),
                    bottom: SizeConfig.getProportionalHeight(20)),
                child: TextButton(
                  onPressed: () {
                    AuthController().completeOnboarding();
                    Get.to(() => const SignUpScreen());
                  },
                  child: Text(
                    TranslationService().translate('skip'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.fontColor,
                        fontFamily: AppFonts.getPrimaryFont(context),
                        fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
