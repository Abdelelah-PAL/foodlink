import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CustomAccountInfoTile extends StatelessWidget {
  const CustomAccountInfoTile({
    super.key,
    required this.text,
    required this.controller,
  });

  final String text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
    Provider.of<SettingsProvider>(context, listen: true);
    return Container(
      height: SizeConfig.getProportionalHeight(60), // increased height
      width: SizeConfig.getProportionalHeight(342),
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportionalHeight(7),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionalWidth(10),
        vertical: SizeConfig.getProportionalHeight(8),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 3.0, color: AppColors.widgetsColor),
      ),
      child: Column(
        crossAxisAlignment: settingsProvider.language == "en"
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          CustomText(
            text: text,
            isCenter: false,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          TextField(
            controller: controller,
            enabled: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            textAlign: settingsProvider.language == 'en'
                ? TextAlign.right
                : TextAlign.left,
            maxLines: 1,
            style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
