import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';

class ListHeader extends StatelessWidget {
  const ListHeader(
      {super.key,
      required this.text,
      required this.isEmpty,
      required this.favorites,
      required this.onTap,
      this.backOnTap});

  final String text;
  final bool isEmpty;
  final bool favorites;
  final VoidCallback onTap;
  final VoidCallback? backOnTap;

  @override
  Widget build(BuildContext context) {
    return isEmpty && !favorites
        ? Row(
            children: [
              CustomBackButton(
                onPressed: backOnTap,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.getPrimaryFont(context)),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.getProperHorizontalSpace(10),
              )
            ],
          )
        : Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.getProportionalHeight(10),
              left: SizeConfig.getProportionalWidth(10),
              right: SizeConfig.getProportionalWidth(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(
                  onPressed: backOnTap,
                ),
                CustomText(
                  isCenter: true,
                  text: text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                if (!favorites)
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: SizeConfig.getProportionalWidth(30),
                      height: SizeConfig.getProportionalHeight(30),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.widgetsColor),
                      child: const Icon(Icons.add),
                    ),
                  ),
              ],
            ),
          );
  }
}
