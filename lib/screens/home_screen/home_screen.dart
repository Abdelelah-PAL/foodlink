import 'package:flutter/material.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/home_screen/widgets/cooker_body.dart';
import 'package:foodlink/screens/home_screen/widgets/user_body.dart';
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
    MealCategoriesProvider mealCategoriesProvider =
        context.watch<MealCategoriesProvider>();
    UsersProvider usersProviderWatcher = context.watch<UsersProvider>();

    return mealCategoriesProvider.isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.getProportionalHeight(28),
                  SizeConfig.getProportionalHeight(0),
                  SizeConfig.getProportionalHeight(28),
                  0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.getProperHorizontalSpace(25),
                    ),
                    Container(
                      child: usersProviderWatcher.selectedUser!.userTypeId ==
                              UserTypes.cooker
                          ? const CookerBody()
                          : const UserBody(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
