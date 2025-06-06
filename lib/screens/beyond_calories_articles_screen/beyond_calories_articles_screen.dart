import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../controllers/general_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../providers/features_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/image_container.dart';

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
    final FeaturesProvider featuresProvider =
        Provider.of<FeaturesProvider>(context, listen: true);
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(SizeConfig.getProperVerticalSpace(7)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(50),
                  horizontal: SizeConfig.getProportionalWidth(20)),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomBackButton(),
                  SizedBox(
                    width: SizeConfig.getProperHorizontalSpace(4),
                  ),
                  const CustomText(
                      isCenter: true,
                      text: "healthy_life",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(10),
                  horizontal: SizeConfig.getProportionalWidth(25)),
              child: Align(
                alignment: settingsProvider.language == 'en'
                    ? Alignment.topLeft
                    : Alignment.topRight,
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
                    return GestureDetector(
                      onTap: () => GeneralController().launchURL(context,
                          Uri.parse(featuresProvider.articles[index].url)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Image.network(
                          featuresProvider.articles[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  childCount: featuresProvider.articles.length,
                ),
              ),
            )
          ],
        ));
  }
}
