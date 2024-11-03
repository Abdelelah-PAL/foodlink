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
                      : const UserBody(),

                  NavigationBar(
                      marginR: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getProportionalWidth(10),
                          vertical: SizeConfig.getProportionalHeight(20)),
                      paddingR: EdgeInsets.symmetric(vertical: SizeConfig.getProportionalHeight(5)),
                      currentIndex: dashBoardController.tabIndex.value,
                      dotIndicatorColor: const Color(0xffDBA514),
                      selectedItemColor: const Color(0xffDBA514),
                      unselectedItemColor: Colors.grey[300],
                      enableFloatingNavBar: true,
                      onTap: dashBoardController.handleIndexChanged,
                      enablePaddingAnimation: false,

                      items: [
                        /// Home
                        DotNavigationBarItem(
                          icon: Image.asset(
                            dashBoardController.tabIndex.value == 0
                                ? Assets.ic_home_selected
                                : Assets.ic_home,
                            height: SizeConfig.getProportionalHeight(18),
                            color: dashBoardController.tabIndex.value == 0
                                ? const Color(0xffDBA514)
                                : null,
                          ),

                        ),

                        /// Search
                        DotNavigationBarItem(
                          icon: Image.asset(
                            Assets.ic_search,
                            height: SizeConfig.getProportionalHeight(18),
                          ),

                        ),

                        /// Email
                        DotNavigationBarItem(
                          icon: Image.asset(
                            Assets.ic_message,
                            height: SizeConfig.getProportionalHeight(18),
                          ),
                        ),

                        /// Notification
                        DotNavigationBarItem(
                          icon: Image.asset(
                            Assets.ic_notification,
                            height: SizeConfig.getProportionalHeight(18),
                          ),
                        ),

                        /// Profile
                        DotNavigationBarItem(
                          icon: Image.asset(
                            Assets.ic_profile,
                            height: SizeConfig.getProportionalHeight(18),
                          ),
                        ),
                      ], destinations: [

                  ],
                    ),
                  )
                ],
              ),
            ),

          );
  }
}
