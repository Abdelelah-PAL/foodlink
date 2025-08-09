import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../services/translation_services.dart';

class AddBox extends StatelessWidget {
  const AddBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(20)),
      width: SizeConfig.getProportionalWidth(105),
      height: SizeConfig.getProportionalHeight(73),
      decoration: BoxDecoration(
        color: AppColors.widgetsColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.add,
        size: 60,
      ),
    );
  }
}
