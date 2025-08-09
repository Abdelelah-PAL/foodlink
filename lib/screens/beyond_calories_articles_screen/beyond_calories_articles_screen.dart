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
import 'widgets/article_tile.dart';

class BeyondCaloriesArticlesScreen extends StatefulWidget {
  const BeyondCaloriesArticlesScreen({super.key});

  @override
  State<BeyondCaloriesArticlesScreen> createState() =>
      _BeyondCaloriesArticlesScreenState();
}

class _BeyondCaloriesArticlesScreenState
    extends State<BeyondCaloriesArticlesScreen> {
  final List<double> columnHeights = [0.0, 0.0];

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
              child: Row(
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
        body:  Padding(
          padding: EdgeInsets.only(
            bottom: SizeConfig.getProportionalWidth(30),
          ),
          child: Column(
            children: [
              ImageContainer(imageUrl: Assets.healthyLifeHeaderImage),
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

              Expanded(
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final List<double> columnHeights = [0, 0];
                      final List<Widget> positionedTiles = [];
                      const verticalPadding = 10.0;
                      const horizontalPadding = 5.0;

                      for (int i = 0; i < featuresProvider.articles.length; i++) {
                        final row = (i / 2).floor();
                        final isShort = (row.isOdd && i.isOdd) || (!row.isOdd && i.isEven);
                        final height = isShort ? 200.0 : 250.0;
                        final column = i % 2;

                        final topPadding = columnHeights[column] > 0 ? verticalPadding : 0;

                        positionedTiles.add(
                            Positioned(
                              top: columnHeights[column] + topPadding,
                              left: column == 0
                                  ? horizontalPadding
                                  : constraints.maxWidth / 2 + horizontalPadding,
                              width: constraints.maxWidth / 2 - (2 * horizontalPadding),
                              height: height,
                              child: ArticleTile(article: featuresProvider.articles[i]),
                            )
                        );

                        columnHeights[column] += height + topPadding;
                      }

                      return SizedBox(
                        height: columnHeights.reduce((a, b) => a > b ? a : b), // Total height
                        child: Stack(
                          children: positionedTiles,
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
