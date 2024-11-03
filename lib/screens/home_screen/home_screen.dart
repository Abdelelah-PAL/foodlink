import 'package:flutter/material.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/home_screen/widgets/cooker_body.dart';
import 'package:foodlink/screens/home_screen/widgets/home_screen_header.dart';
import 'package:foodlink/screens/home_screen/widgets/user_body.dart';
import 'package:foodlink/services/translation_services.dart';

import '../../core/utils/size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String template = TranslationService().translate("greeting");
    template = template.replaceFirst(
        '{name}', GeneralProvider().selectedUser!.username);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(63),
            horizontal: SizeConfig.getProportionalHeight(28)),
        child: Column(
          children: [
            const HomeScreenHeader(),
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
            GeneralProvider().selectedUser!.userTypeId == UserTypes.cooker
                ? const CookerBody()
                : const UserBody()
          ],
        ),
      ),
    );
  }
}
