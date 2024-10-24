import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/screens/auth_screens/login_screen.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_btn.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_divider.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_footer.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_textfield.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_error_txt.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_google_auth_btn.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/users_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AuthController _authController;

  @override
  void dispose() {
    _authController.usernameController.dispose();
    _authController.emailController.dispose();
    _authController.passwordController.dispose();
    _authController.confirmedPasswordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authController = AuthController(updateUI: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionalWidth(10),
            vertical: SizeConfig.getProportionalWidth(70)),
        child: Column(
          children: [
            SizedBox(
                height: SizeConfig.getProportionalHeight(179),
                width: SizeConfig.getProportionalHeight(179),
                child: Image.asset(Assets.pureLogo)),
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.getProportionalHeight(10),
                  bottom: SizeConfig.getProportionalHeight(13)),
              child: Text(
                TranslationService().translate("create_an_account"),
                style: TextStyle(
                  fontFamily: AppFonts.primaryFont,
                  fontSize: 24,
                  color: AppColors.fontColor,
                ),
                softWrap: false,
              ),
            ),
            CustomErrorTxt(
                text:
                    TranslationService().translate(_authController.errorText)),
            CustomAuthenticationTextField(
              hintText: TranslationService().translate('enter_username'),
              obscureText: false,
              textEditingController: _authController.usernameController,
              borderColor: _authController.usernameTextFieldBorderColor,
            ),
            CustomAuthenticationTextField(
              hintText: TranslationService().translate('enter_email'),
              obscureText: false,
              textEditingController: _authController.emailController,
              borderColor: _authController.emailTextFieldBorderColor,
            ),
            CustomAuthenticationTextField(
              hintText: TranslationService().translate('enter_password'),
              obscureText: true,
              textEditingController: _authController.passwordController,
              borderColor: _authController.passwordTextFieldBorderColor,
            ),
            CustomAuthenticationTextField(
              hintText: TranslationService().translate('confirm_password'),
              obscureText: true,
              textEditingController:
                  _authController.confirmedPasswordController,
              borderColor: _authController.confirmPasswordTextFieldBorderColor,
            ),
            CustomAuthBtn(
              text: TranslationService().translate('signup'),
              onTap: () async {
                _authController.checkEmptyFields(false);
                _authController.checkMatchedPassword();
                if (!_authController.noneIsEmpty ||
                    !_authController.isMatched) {
                  setState(() {
                    _authController.changeTextFieldsColors(false);
                  });
                  return;
                } else {
                  if (_authController.isMatched) {
                    var user = await AuthProvider().signUpWithEmailAndPassword(
                      _authController.emailController.text,
                      _authController.passwordController.text,
                    );
                    UsersProvider().addUserDetails(user!.uid);
                    setState(() {
                      _authController.changeTextFieldsColors(false);
                    });
                    Get.to(() => const LoginScreen());
                  }
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalHeight(13),
              ),
              child: const CustomAuthDivider(),
            ),
            CustomGoogleAuthBtn(
              text: TranslationService().translate("google_signup"),
              onTap: () {},
            ),
            SizedBox(height: SizeConfig.getProportionalHeight(11)),
            CustomAuthFooter(
              headingText: "have_account",
              tailText: "login",
              onTap: () {
                Get.to(() =>  const LoginScreen());
              },
            )
          ],
        ),
      ),
    );
  }
}
