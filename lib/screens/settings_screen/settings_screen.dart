import 'package:flutter/material.dart';
import 'package:foodlink/screens/settings_screen/widgets/custom_setting_tile.dart';
import 'package:foodlink/screens/settings_screen/widgets/custom_settings_container.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/profile_circle.dart';

import '../../core/utils/size_config.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizeConfig.customSizedBox(null, 50, null),
        const CustomText(
            isCenter: true,
            text: "settings",
            fontSize: 30,
            fontWeight: FontWeight.bold),
        SizeConfig.customSizedBox(null, 25, null),
        const ProfileCircle(
          height: 68,
          width: 68,
          iconSize: 50,
        ),
        SizeConfig.customSizedBox(null, 50, null),
         CustomSettingsContainer(height: 125, children: [
           CustomSettingTile(icon: Icons.manage_accounts, text: "edit_data"),
          Row(),
          Row()
        ]),
        CustomSettingsContainer(height: 103, children: [
          Row(),
          Row(),
        ]),
        CustomSettingsContainer(height: 103, children: [])
      ],
    );
  }
}
