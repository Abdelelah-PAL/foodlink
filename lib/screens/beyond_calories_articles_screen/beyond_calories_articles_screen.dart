import 'package:flutter/material.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import '../../providers/beyond_calories_articles_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/image_container.dart';
import '../widgets/profile_circle.dart';

class BeyondCaloriesArticlesScreen extends StatefulWidget {
  const BeyondCaloriesArticlesScreen({super.key});

  @override
  State<BeyondCaloriesArticlesScreen> createState() =>
      _BeyondCaloriesArticlesScreenState();
}

class _BeyondCaloriesArticlesScreenState
    extends State<BeyondCaloriesArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    final BeyondCaloriesArticlesProvider beyondCaloriesArticlesProvider =
        Provider.of<BeyondCaloriesArticlesProvider>(context, listen: true);
    final SettingsProvider settingsProvider =
    Provider.of<SettingsProvider>(context, listen: true);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(SizeConfig.getProportionalHeight(100)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(50),
                  horizontal: SizeConfig.getProportionalWidth(20)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  CustomText(
                      isCenter: true,
                      text: "healthy_life",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  ProfileCircle(height: 50, width: 50, iconSize: 25)
                ],
              ),
            )),
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            // Header Image
            ImageContainer(imageUrl: Assets.healthyLifeHeaderImage),
            // Custom Text
            Padding(
              padding:  EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(10),
                  horizontal: SizeConfig.getProportionalWidth(25)),
              child: Align(
                alignment: settingsProvider.language == 'en'
                ?Alignment.topLeft
                :Alignment.topRight,
                child: const CustomText(
                  isCenter: false,
                  text: "beyond_calories",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // GridView inside a fixed-height container
            Expanded(

               child: GridView.custom(
                 padding: EdgeInsets.symmetric(
                   horizontal: SizeConfig.getProportionalWidth(5),
                 ),
                 gridDelegate: SliverWovenGridDelegate.count(
                   crossAxisCount: 2,
                   pattern: [
                     const WovenGridTile(1),
                     const WovenGridTile(
                       5 / 7,
                       crossAxisRatio: 0.9,
                       alignment: AlignmentDirectional.center,
                     ),
                   ],
                 ),
                 childrenDelegate: SliverChildBuilderDelegate(
                   (context, index) {
                     return Image.asset(Assets.resourcesAdvertising, fit: BoxFit.fill,);
                   },
                   childCount: beyondCaloriesArticlesProvider.articles.length, // Define the number of items
                 ),
               ),
            ),
          ],
        ));
  }
}
