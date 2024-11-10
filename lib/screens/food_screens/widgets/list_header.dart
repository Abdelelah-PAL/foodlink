import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GeneralProvider().language == 'en'
        ? Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.getProportionalHeight(70),
              left: SizeConfig.getProportionalWidth(50),
              right: SizeConfig.getProportionalWidth(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.primaryFont),
                ),
                SizedBox(width: SizeConfig.getProportionalWidth(20)),
                Container(
                  width: SizeConfig.getProportionalWidth(30),
                  height: SizeConfig.getProportionalHeight(30),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.widgetsColor),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.getProportionalWidth(30),
                height: SizeConfig.getProportionalHeight(30),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.widgetsColor),
                child: const Icon(Icons.add),
              ),
              SizedBox(width: SizeConfig.getProportionalWidth(20)),
              Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.primaryFont),
              )
            ],
          );
  }
}
