import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/settings_controller.dart';
import '../../core/utils/size_config.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../authentication_screens/widgets/custom_auth_textfield.dart';
import '../authentication_screens/widgets/custom_auth_textfield_header.dart';
import '../authentication_screens/widgets/custom_error_txt.dart';
import '../widgets/custom_button.dart';
import 'widgets/custom_top_bar.dart';
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
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);
    AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
        child: CustomTopBar(
          text: 'edit_data',
          rightPadding: 85,
          settingsProvider: widget.settingsProvider,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: SizeConfig.getProportionalHeight(100), // enough bottom padding so content won't be hidden behind button
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.getProportionalHeight(35),
                      ),
                      child: ProfilePictureContainer(
                        settingsProvider: widget.settingsProvider,
                        usersProvider: widget.usersProvider,
                        circleSize: 68,
                        iconSize: 50,
                      ),
                    ),
                    SizeConfig.customSizedBox(null, 10, null),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () {
                        widget.usersProvider.pickImageFromSource(context);
                      },
                    ),
                    CustomErrorTxt(
                      text: TranslationService()
                          .translate(widget.usersProvider.errorText),
                      settingsProvider: widget.settingsProvider,
                    ),
                    SizeConfig.customSizedBox(null, 10, null),
                    CustomAuthTextFieldHeader(
                      text: TranslationService().translate('name'),
                      settingsProvider: widget.settingsProvider,
                    ),
                    CustomAuthenticationTextField(
                      hintText: null,
                      obscureText: false,
                      textEditingController: widget.usersProvider.usernameController,
                      borderColor: widget.usersProvider.usernameTextFieldBorderColor,
                      settingsProvider: widget.settingsProvider,
                      borderWidth: 3,
                      isSettings: true,
                    ),
                    CustomAuthTextFieldHeader(
                      text: TranslationService().translate('email'),
                      settingsProvider: widget.settingsProvider,
                    ),
                    CustomAuthenticationTextField(
                      hintText: null,
                      obscureText: false,
                      textEditingController: widget.usersProvider.emailController,
                      borderColor: widget.usersProvider.emailTextFieldBorderColor,
                      settingsProvider: widget.settingsProvider,
                      borderWidth: 3,
                      isSettings: true,
                    ),
                    CustomAuthTextFieldHeader(
                      text: TranslationService().translate('password'),
                      settingsProvider: widget.settingsProvider,
                    ),
                    CustomAuthenticationTextField(
                      hintText: "enter_password",
                      obscureText: true,
                      textEditingController: widget.usersProvider.passwordController,
                      borderColor: widget.usersProvider.passwordTextFieldBorderColor,
                      settingsProvider: widget.settingsProvider,
                      borderWidth: 3,
                      isSettings: true,
                    ),
                    CustomAuthTextFieldHeader(
                      text: TranslationService().translate('confirm_password'),
                      settingsProvider: widget.settingsProvider,
                    ),
                    CustomAuthenticationTextField(
                      hintText: "confirm_password",
                      obscureText: true,
                      textEditingController: widget.usersProvider.confirmedPasswordController,
                      borderColor: widget.usersProvider.confirmPasswordTextFieldBorderColor,
                      settingsProvider: widget.settingsProvider,
                      borderWidth: 3,
                      isSettings: true,
                    ),
                    // add extra bottom padding if needed to avoid content getting hidden behind the button
                    SizedBox(height: SizeConfig.getProportionalHeight(60)),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 30, // fixed 30 px from bottom
              child: Center(
                child: CustomButton(
                  onTap: () async {
                    widget.usersProvider.checkEmptyFields();
                    if (!widget.usersProvider.noneIsEmpty) {
                      setState(() {
                        widget.usersProvider.changeTextFieldsColors();
                      });
                      return;
                    }
                    widget.usersProvider.checkMatchedPassword();
                    if (!widget.usersProvider.isMatched) {
                      setState(() {
                        widget.usersProvider.changeTextFieldsColors();
                      });
                      return;
                    }
                    widget.usersProvider.checkValidPassword();
                    if (!widget.usersProvider.passwordIsValid) {
                      setState(() {
                        widget.usersProvider.changeTextFieldsColors();
                      });
                      return;
                    }
                    if (widget.usersProvider.isMatched &&
                        widget.usersProvider.passwordIsValid) {
                      setState(() {
                        widget.usersProvider.changeTextFieldsColors();
                      });

                      await SettingsController().updateUserDetails(
                        widget.usersProvider,
                        dashboardProvider,
                        authenticationProvider,
                        widget.usersProvider.selectedUser!.userId,
                        widget.usersProvider.usernameController.text,
                        widget.usersProvider.emailController.text,
                        widget.usersProvider.passwordController.text.trim(),
                        widget.usersProvider.selectedUser!.userTypeId!,
                        context,
                      );
                    }
                  },
                  text: "save",
                  width: SizeConfig.getProportionalWidth(137),
                  height: SizeConfig.getProportionalHeight(45),
                  fontSize: widget.settingsProvider.language == 'en' ? 24 : 30,
                  fontWeight: FontWeight.w700,
                  isDisabled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
