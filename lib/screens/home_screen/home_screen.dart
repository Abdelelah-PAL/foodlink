import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_types.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/features_provider.dart';
import '../../providers/meal_categories_provider.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../widgets/app_header.dart';
import 'widgets/cooker_body.dart';
import 'widgets/user_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);
    FeaturesProvider featuresProvider = Provider.of<FeaturesProvider>(context);
    MealCategoriesProvider mealCategoriesProvider =
        context.watch<MealCategoriesProvider>();
    UsersProvider usersProviderWatcher = context.watch<UsersProvider>();



    return mealCategoriesProvider.isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(135)),
              child: AppHeader(
                userId: usersProviderWatcher.selectedUser!.userId,
                userTypeId: usersProviderWatcher.selectedUser!.userTypeId!,
              ),
            ),
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
                    SizeConfig.customSizedBox(null, 15, null),
                    Container(
                      child: usersProviderWatcher.selectedUser!.userTypeId ==
                              UserTypes.cooker
                          ? CookerBody(
                              settingsProvider: settingsProvider,
                              mealsProvider: mealsProvider,
                              featuresProvider: featuresProvider,
                              userDetails: usersProviderWatcher.selectedUser!,
                            )
                          : UserBody(
                              settingsProvider: settingsProvider,
                              userDetails: usersProviderWatcher.selectedUser!),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
