import 'package:flutter/material.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/user_types.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/users_provider.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow(
      {super.key,
      required this.meal,
      required this.fontSize,
      required this.settingsProvider,
      required this.usersProvider,
      });

  final Meal meal;
  final double fontSize;
  final SettingsProvider settingsProvider;
  final UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(meal.recipe!);
    return Container(
      padding: EdgeInsets.only(left: SizeConfig.getProportionalWidth(10)) ,
      width: 348,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1.0, color: AppColors.widgetsColor),
      ),
      child: Row(
        textDirection: settingsProvider.language == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: settingsProvider.language == 'en'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            Assets.mealRecipe,
            scale: 1.3,
          ),
          SizeConfig.customSizedBox(
            280,
            usersProvider.selectedUser!.userTypeId == UserTypes.cooker
                ? 200
                : 225,
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                maxLines: 100,
                meal.recipe!,
                textDirection: writtenLanguage == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                textAlign:
                    writtenLanguage == 'en' ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                    fontSize: fontSize,
                    fontFamily:
                        writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
