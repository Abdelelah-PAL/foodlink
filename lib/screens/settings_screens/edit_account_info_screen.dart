import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_textfield.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import '../../controllers/general_controller.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../auth_screens/widgets/custom_auth_textfield_header.dart';
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
                right: SizeConfig.getProportionalWidth(85)),
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
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ProfileCircle(
                  height: 68,
                  width: 68,
                  iconSize: 50,
                ),
                SizeConfig.customSizedBox(null, 10, null),
                const Icon(Icons.camera_alt_outlined),
                SizeConfig.customSizedBox(null, 50, null),
                // CustomAccountInfoTile(
                //     text: "name",
                //     controller: GeneralController().usernameController),
                // CustomAccountInfoTile(
                //     text: "email",
                //     controller: GeneralController().emailController),
                // CustomAccountInfoTile(
                //     text: "password",
                //     controller: GeneralController().passwordController),
                // CustomAccountInfoTile(
                //     text: "confirm_password",
                //     controller:
                //         GeneralController().confirmedPasswordController),
                CustomAuthTextFieldHeader(
                  text: TranslationService().translate('name'),
                  settingsProvider: settingsProvider,
                ),
                CustomAuthenticationTextField(
                    hintText: null,
                    obscureText: false,
                    textEditingController:
                        GeneralController().usernameController,
                    borderColor: AppColors.widgetsColor,
                    settingsProvider: settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('email'),
                    settingsProvider: settingsProvider),
                CustomAuthenticationTextField(
                    hintText: null,
                    obscureText: false,
                    textEditingController: GeneralController().emailController,
                    borderColor: AppColors.widgetsColor,
                    settingsProvider: settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('password'),
                    settingsProvider: settingsProvider),
                CustomAuthenticationTextField(
                    hintText: null,
                    obscureText: true,
                    textEditingController:
                        GeneralController().passwordController,
                    borderColor: AppColors.widgetsColor,
                    settingsProvider: settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('confirm_password'),
                    settingsProvider: settingsProvider),
                CustomAuthenticationTextField(
                    hintText: null,
                    obscureText: true,
                    textEditingController:
                        GeneralController().confirmedPasswordController,
                    borderColor: AppColors.widgetsColor,
                    settingsProvider: settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                SizeConfig.customSizedBox(null, 100, null),
                CustomButton(
                    onTap: () => {},
                    text: "save",
                    width: 137,
                    height: 45,
                    fontSize: settingsProvider.language == 'en' ? 24 : 30,
                    fontWeight: FontWeight.w700,
                    isDisabled: false)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
