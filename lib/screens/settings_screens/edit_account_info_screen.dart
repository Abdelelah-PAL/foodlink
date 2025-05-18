import 'package:flutter/material.dart';
import '../../controllers/settings_controller.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../auth_screens/widgets/custom_auth_textfield.dart';
import '../auth_screens/widgets/custom_auth_textfield_header.dart';
import '../auth_screens/widgets/custom_error_txt.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'widgets/profile_picture_container.dart';

class EditAccountInfoScreen extends StatefulWidget {
  const EditAccountInfoScreen(
      {super.key, required this.usersProvider, required this.settingsProvider});

  final UsersProvider usersProvider;
  final SettingsProvider settingsProvider;

  @override
  State<EditAccountInfoScreen> createState() => _EditAccountInfoScreenState();
}

class _EditAccountInfoScreenState extends State<EditAccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
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
                    fontSize:
                        widget.settingsProvider.language == "en" ? 22 : 30,
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
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getProportionalHeight(35)),
                  child: ProfilePictureContainer(
                    settingsProvider: widget.settingsProvider,
                    usersProvider: widget.usersProvider,
                  ),
                ),
                SizeConfig.customSizedBox(null, 10, null),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    widget.usersProvider.pickImageFromSource(context);
                  },
                ),
                SizeConfig.customSizedBox(null, 40, null),
                CustomErrorTxt(
                  text: TranslationService()
                      .translate(SettingsController().errorText),
                  settingsProvider: widget.settingsProvider,
                ),
                SizeConfig.customSizedBox(null, 10, null),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('name'),
                    settingsProvider: widget.settingsProvider),
                CustomAuthenticationTextField(
                    hintText: null,
                    obscureText: false,
                    textEditingController:
                        SettingsController().usernameController,
                    borderColor:
                        SettingsController().usernameTextFieldBorderColor,
                    settingsProvider: widget.settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('email'),
                    settingsProvider: widget.settingsProvider),
                CustomAuthenticationTextField(
                    hintText: null,
                    obscureText: false,
                    textEditingController: SettingsController().emailController,
                    borderColor: SettingsController().emailTextFieldBorderColor,
                    settingsProvider: widget.settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('password'),
                    settingsProvider: widget.settingsProvider),
                CustomAuthenticationTextField(
                    hintText: "enter_password",
                    obscureText: true,
                    textEditingController:
                        SettingsController().passwordController,
                    borderColor:
                        SettingsController().passwordTextFieldBorderColor,
                    settingsProvider: widget.settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('confirm_password'),
                    settingsProvider: widget.settingsProvider),
                CustomAuthenticationTextField(
                    hintText: "confirm_password",
                    obscureText: true,
                    textEditingController:
                        SettingsController().confirmedPasswordController,
                    borderColor: SettingsController()
                        .confirmPasswordTextFieldBorderColor,
                    settingsProvider: widget.settingsProvider,
                    borderWidth: 3,
                    isSettings: true),
                SizeConfig.customSizedBox(null, 80, null),
                CustomButton(
                    onTap: () async {
                      SettingsController().checkEmptyFields();
                      if (!SettingsController().noneIsEmpty) {
                        setState(() {
                          SettingsController().changeTextFieldsColors();
                        });
                        return;
                      }
                      SettingsController().checkMatchedPassword();
                      if (!SettingsController().isMatched) {
                        setState(() {
                          SettingsController().changeTextFieldsColors();
                        });
                        return;
                      }
                      SettingsController().checkValidPassword();
                      if (!SettingsController().passwordIsValid) {
                        setState(() {
                          SettingsController().changeTextFieldsColors();
                        });
                        return;
                      }
                      if (SettingsController().isMatched &&
                          SettingsController().passwordIsValid) {
                        setState(() {
                          SettingsController().changeTextFieldsColors();
                        });

                        await SettingsController().updateUserDetails(
                            widget.usersProvider,
                            widget.usersProvider.selectedUser!.userId,
                            widget.usersProvider.selectedUser!.username!,
                            widget.usersProvider.selectedUser!.email,
                            SettingsController().passwordController.text,
                            widget.usersProvider.selectedUser!.userTypeId!);
                      }
                    },
                    text: "save",
                    width: 137,
                    height: 45,
                    fontSize:
                        widget.settingsProvider.language == 'en' ? 24 : 30,
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
