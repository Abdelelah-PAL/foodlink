import 'package:flutter/material.dart';
import '../../controllers/general_controller.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/profile_circle.dart';
import 'widgets/custom_account_info_tile.dart';

class EditAccountInfoScreen extends StatelessWidget {
  const EditAccountInfoScreen(
      {super.key, required this.usersProvider, required this.settingsProvider});

  final UsersProvider usersProvider;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(50)),
          child: Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.getProportionalWidth(50),
                right: SizeConfig.getProportionalWidth(50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomBackButton(),
                CustomText(
                    isCenter: true,
                    text: "edit_data",
                    fontSize: settingsProvider.language == "en" ? 22 : 30,
                    fontWeight: FontWeight.bold),
              ],
            ),
          )),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizeConfig.customSizedBox(null, 30, null),
            const ProfileCircle(
              height: 68,
              width: 68,
              iconSize: 50,
            ),
            SizeConfig.customSizedBox(null, 10, null),

            const Icon(Icons.camera_alt_outlined),
            SizeConfig.customSizedBox(null, 50, null),
            CustomAccountInfoTile(
                text: "username",
                controller: GeneralController().usernameController),
            CustomAccountInfoTile(
                text: "email", controller: GeneralController().emailController)
          ],
        ),
      ),
    );
  }
}
