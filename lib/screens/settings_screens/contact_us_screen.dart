import 'package:flutter/material.dart';
import '../../controllers/general_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_text.dart';
import 'widgets/custom_contact_container.dart';
import 'widgets/custom_top_bar.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key, required this.settingsProvider});

  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
          child: CustomTopBar(
              text: 'contact_us',
              rightPadding: 150,
              settingsProvider: settingsProvider)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: CustomText(
              isCenter: true,
              text: "contacting_header",
              fontSize: 20,
              fontWeight: FontWeight.w400,
              maxLines: 2,
            ),
          ),
          SizeConfig.customSizedBox(null, 81, null),
          CustomContactContainer(
              settingsProvider: settingsProvider,
              text: "+962792953645",
              underlinedText: false,
              icon: Assets.phone),
          CustomContactContainer(
              settingsProvider: settingsProvider,
              text: "Foodlinkapp2024@gmail.com",
              underlinedText: false,
              icon: Assets.email),
          SizeConfig.customSizedBox(null, 40, null),
          const CustomText(
              isCenter: true,
              text: "social_media",
              fontSize: 30,
              fontWeight: FontWeight.w700),
          SizeConfig.customSizedBox(null, 35, null),
          CustomContactContainer(
              settingsProvider: settingsProvider,
              text: "FoodLink",
              icon: Assets.facebook,
              underlinedText: true,
              onTap: () => GeneralController().launchURL(
                  context,
                  Uri.parse(
                      'https://www.facebook.com/profile.php?id=61569316632773'))),
          CustomContactContainer(
              settingsProvider: settingsProvider,
              text: "foodlink_app2024",
              icon: Assets.instagram,
              underlinedText: true,
              onTap: () => GeneralController().launchURL(context,
                  Uri.parse('https://www.instagram.com/foodlink_app2024/'))),
        ],
      ),
    );
  }
}
