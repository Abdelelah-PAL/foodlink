import 'package:flutter/material.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/main.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/home_screen/widgets/cooker_body.dart';
import 'package:foodlink/screens/home_screen/widgets/home_screen_header.dart';
import 'package:foodlink/screens/home_screen/widgets/user_body.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';

import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    MealCategoriesProvider().getAllMealCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealCategoriesProvider mealCategoriesProvider = context.watch<MealCategoriesProvider>();
    String template = TranslationService().translate("greeting");
    template =
        template.replaceFirst('{name}', UsersProvider().selectedUser!.username);
    return mealCategoriesProvider.isLoading == true
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalHeight(63),
                  horizontal: SizeConfig.getProportionalHeight(28)),
              child: Column(
                children: [
                  HomeScreenHeader(
                    onUpdate: () {
                      setState(() {});
                    },
                  ),
                  Align(
                    alignment: GeneralProvider().language == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      template,
                      textDirection: GeneralProvider().language == 'en'
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.getProperHorizontalSpace(10),
                  ),
                  UsersProvider().selectedUser!.userTypeId == UserTypes.cooker
                      ? const CookerBody()
                      : const UserBody()
                ],
              ),
            ),
          );
  }
}
