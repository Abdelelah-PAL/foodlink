import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/authentication_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/user_details.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_text.dart';
import 'login_screen.dart';
import 'widgets/custom_auth_btn.dart';
import 'widgets/custom_auth_footer.dart';
import 'widgets/custom_auth_textfield.dart';
import 'widgets/custom_error_txt.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AuthenticationController _authController;

  @override
  void dispose() {
    _authController.confirmedPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authController = AuthenticationController();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionalWidth(10),
            vertical: SizeConfig.getProportionalWidth(45)),
        child: SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                SizeConfig.customSizedBox(
                    179, 179, Image.asset(Assets.pureLogo)),
                Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.getProportionalHeight(10),
                        bottom: SizeConfig.getProportionalHeight(13)),
                    child: const CustomText(
                      isCenter: true,
                      text: "create_an_account",
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: AppColors.fontColor,
                    )),
                CustomErrorTxt(
                  text:
                      TranslationService().translate(_authController.signUpErrorText),
                  settingsProvider: settingsProvider,
                ),
                CustomAuthenticationTextField(
                  hintText: TranslationService().translate('enter_email'),
                  obscureText: false,
                  textEditingController: _authController.signUpEmailController,
                  borderColor: _authController.signUpEmailTextFieldBorderColor,
                  settingsProvider: settingsProvider,
                ),
                CustomAuthenticationTextField(
                  hintText: TranslationService().translate('enter_password'),
                  obscureText: true,
                  textEditingController: _authController.signUpPasswordController,
                  borderColor: _authController.signUpPasswordTextFieldBorderColor,
                  settingsProvider: settingsProvider,
                ),
                CustomAuthenticationTextField(
                  hintText: TranslationService().translate('confirm_password'),
                  obscureText: true,
                  textEditingController:
                      _authController.confirmedPasswordController,
                  borderColor:
                      _authController.confirmPasswordTextFieldBorderColor,
                  settingsProvider: settingsProvider,
                ),
                SizeConfig.customSizedBox(null, 50, null),
                CustomAuthBtn(
                  text: TranslationService().translate('signup'),
                  onTap: () async {
                    _authController.checkEmptyFields(false);
                    if (!_authController.noneIsEmpty) {
                      setState(() {
                        _authController.changeTextFieldsColors(false);
                      });
                      return;
                    }
                    _authController.checkMatchedPassword();
                    if (!_authController.isMatched) {
                      setState(() {
                        _authController.changeTextFieldsColors(false);
                      });
                      return;
                    }
                    _authController.checkValidPassword();
                    if (!_authController.passwordIsValid) {
                      setState(() {
                        _authController.changeTextFieldsColors(false);
                      });
                      return;
                    }
                    if (_authController.isMatched &&
                        _authController.passwordIsValid) {
                      var user = await AuthenticationProvider()
                          .signUpWithEmailAndPassword(
                        _authController.signUpEmailController.text.trim(),
                        _authController.signUpPasswordController.text,
                        authenticationProvider
                      );
                      UserDetails userDetails = UserDetails(
                        userId: user!.uid,
                        userTypeId: null,
                        email: user.email!,
                        username: null,
                        subscriber: false,
                      );
                      UsersProvider().addUserDetails(userDetails);
                      setState(() {
                        _authController.changeTextFieldsColors(false);
                      });
                      await SettingsProvider().addSettings(user.uid);
                      Get.to(() => const LoginScreen(
                            firstScreen: false,
                          ));
                    }
                  },
                ),
                SizeConfig.customSizedBox(null, 50, null),
                CustomAuthFooter(
                  headingText: "have_account",
                  tailText: "login",
                  settingsProvider: settingsProvider,
                  onTap: () {
                    AuthenticationProvider().resetSignUpErrorText();
                    Get.to(() => const LoginScreen(
                          firstScreen: false,
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
