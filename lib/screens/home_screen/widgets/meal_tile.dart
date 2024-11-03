import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/services/translation_services.dart';

class MealTile extends StatelessWidget {
  const MealTile({super.key, required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              width: SizeConfig.getProportionalWidth(66),
              height: SizeConfig.getProportionalHeight(68),
              child: Image.asset(imageUrl),
            ),
            Text(
              TranslationService().translate(name),
              style: TextStyle(
                  fontFamily: AppFonts.primaryFont,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
        SizedBox(
          width: SizeConfig.getProportionalWidth(5),
        ),
      ],
    );
  }
}
