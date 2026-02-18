import 'package:flutter/material.dart';

import '../../../../controllers/general_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class TheMealDBTile extends StatelessWidget {
  const TheMealDBTile({
    super.key,
    required this.meal,
    required this.onTap,
    required this.settingsProvider,
    this.isLoading = false,
  });

  final Meal meal;
  final VoidCallback onTap;
  final SettingsProvider settingsProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(meal.name);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.getProportionalWidth(355),
        height: SizeConfig.getProportionalHeight(110),
        margin: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(10)),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 7,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          textDirection: settingsProvider.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          children: [
            Container(
              width: SizeConfig.getProportionalWidth(150),
              height: SizeConfig.getProportionalHeight(110),
              decoration: const BoxDecoration(
                color: AppColors.widgetsColor,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  meal.imageUrl != null && meal.imageUrl!.isNotEmpty
                      ? Image.network(
                          meal.imageUrl!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        )
                      : Image.asset(
                          Assets.defaultMealImage,
                        ),
                  if (isLoading)
                    const CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalHeight(10),
                  horizontal: SizeConfig.getProportionalWidth(15),
                ),
                child: Column(
                  crossAxisAlignment: settingsProvider.language == 'en'
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: settingsProvider.language == 'en'
                          ? TextAlign.start
                          : TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
