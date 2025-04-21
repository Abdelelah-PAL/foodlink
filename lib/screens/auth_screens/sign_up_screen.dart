import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/models/user_details.dart';
import 'package:foodlink/screens/auth_screens/login_screen.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_btn.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_divider.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_footer.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_textfield.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_error_txt.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_google_auth_btn.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../widgets/custom_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AuthController _authController;

  @override
  void dispose() {
    _authController.confirmedPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  Widget build(BuildContext context) {

    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

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
                  child:
                  const CustomText(
                    isCenter: true,
                    text: "create_an_account",
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: AppColors.fontColor,
                  )
                ),
                CustomErrorTxt(
                    text: TranslationService()
                        .translate(_authController.errorText),
                  settingsProvider: settingsProvider,
                ),
                CustomAuthenticationTextField(
                  hintText: TranslationService().translate('enter_email'),
                  obscureText: false,
                  textEditingController: _authController.emailController,
                  borderColor: _authController.emailTextFieldBorderColor,
                  settingsProvider: settingsProvider,
                ),
                CustomAuthenticationTextField(
                  hintText: TranslationService().translate('enter_password'),
                  obscureText: true,
                  textEditingController: _authController.passwordController,
                  borderColor: _authController.passwordTextFieldBorderColor,
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
                    _authController.checkValidPassword();
                    _authController.checkMatchedPassword();

                    if (!_authController.noneIsEmpty ||
                        !_authController.isMatched ||
                        !_authController.passwordIsValid
                   ) {
                      setState(() {
                        _authController.changeTextFieldsColors(false);
                      });
                      return;
                    } else {
                      if (_authController.isMatched && _authController.passwordIsValid) {
                        var user =
                        await AuthProvider().signUpWithEmailAndPassword(
                          _authController.emailController.text,
                          _authController.passwordController.text,
                        );
                        UserDetails userDetails = UserDetails(
                          userId: user!.uid,
                          userTypeId: null,
                          email: user.email!,
                          username: null,
                        );
                        UsersProvider().addUserDetails(userDetails);
                        setState(() {
                          _authController.changeTextFieldsColors(false);
                        });
                        await SettingsProvider()
                            .addSettings(user.uid);
                        Get.to(() => const LoginScreen());
                      }
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.getProportionalHeight(10),
                  ),
                  child: const CustomAuthDivider(),
                ),
                CustomGoogleAuthBtn(
                  text: TranslationService().translate("google_signup"),
                  settingsProvider: settingsProvider,
                  onTap: () {},
                ),
                SizeConfig.customSizedBox(null, 50, null),
                CustomAuthFooter(
                  headingText: "have_account",
                  tailText: "login",
                  settingsProvider: settingsProvider,
                  onTap: () {
                    Get.to(() => const LoginScreen());
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
