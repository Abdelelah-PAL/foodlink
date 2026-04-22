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
  bool _isPrecaching = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final featuresProvider = context.read<FeaturesProvider>();
    final mealCategoriesProvider = context.read<MealCategoriesProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final usersProvider = context.read<UsersProvider>();

    // Start fetching slider images
    featuresProvider.getAllSliderImages();

    // Wait for data to finish loading (triggered here and in RolesScreen)
    while (featuresProvider.isLoading || mealCategoriesProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    // Now data is ready, precache all network images
    List<Future<void>> imageFutures = [];

    // Slider images
    for (String url in featuresProvider.sliderImages) {
      imageFutures.add(precacheImage(NetworkImage(url), context));
    }

    // Feature images
    List<dynamic> features = usersProvider.selectedUser?.userTypeId == UserTypes.cooker
        ? featuresProvider.cookerFeatures
        : featuresProvider.userFeatures;

    for (var feature in features) {
      String url = settingsProvider.language == 'en' ? feature.enImageURL : feature.arImageURL;
      if (url.isNotEmpty) {
        imageFutures.add(precacheImage(NetworkImage(url), context));
      }
    }

    // Wait for all images to precache (with a timeout so it doesn't hang forever on bad network)
    try {
      await Future.wait(imageFutures).timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint("Image precaching timed out or failed: $e");
    }

    if (mounted) {
      setState(() {
        _isPrecaching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);
    FeaturesProvider featuresProvider = Provider.of<FeaturesProvider>(context);
    MealCategoriesProvider mealCategoriesProvider =
        context.watch<MealCategoriesProvider>();
    UsersProvider usersProviderWatcher = context.watch<UsersProvider>();

    if (_isPrecaching || mealCategoriesProvider.isLoading || featuresProvider.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: AppHeader(
                userId: usersProviderWatcher.selectedUser!.userId,
                userTypeId: usersProviderWatcher.selectedUser!.userTypeId!,
              ),
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionalHeight(28),
                0,
                SizeConfig.getProportionalHeight(28),
                0,
              ),
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
                      userDetails: usersProviderWatcher.selectedUser!,
                    ),
            ),
          );
  }
}
