import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/auth_screens/sign_up_screen.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_btn.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_divider.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_footer.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_textfield.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_auth_textfield_header.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_error_txt.dart';
import 'package:foodlink/screens/auth_screens/widgets/custom_google_auth_btn.dart';
import 'package:foodlink/screens/roles_screen/roles_screen.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/authentication_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _authController.getLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(10),
                  vertical: SizeConfig.getProportionalWidth(45)),
              child: Column(children: [
                SizeConfig.customSizedBox(
                    179, 179, Image.asset(Assets.pureLogo)),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getProportionalHeight(10),
                      bottom: SizeConfig.getProportionalHeight(13)),
                  child: Text(
                    TranslationService().translate("welcome_back"),
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      fontSize: 24,
                      color: AppColors.fontColor,
                    ),
                    softWrap: false,
                  ),
                ),
                CustomErrorTxt(
                    text: TranslationService()
                        .translate(_authController.errorText)),
                SizeConfig.customSizedBox(null, 6, null),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('email')),
                CustomAuthenticationTextField(
                  hintText: 'example@example.com',
                  obscureText: false,
                  textEditingController: _authController.emailController,
                  borderColor: _authController.emailTextFieldBorderColor,
                ),
                SizeConfig.customSizedBox(
                  null,
                  15,
                  null,
                ),
                CustomAuthTextFieldHeader(
                    text: TranslationService().translate('password')),
                CustomAuthenticationTextField(
                  hintText: TranslationService().translate('enter_password'),
                  obscureText: true,
                  textEditingController: _authController.passwordController,
                  borderColor: _authController.passwordTextFieldBorderColor,
                ),
                SizeConfig.customSizedBox(
                  null,
                  15,
                  null,
                ),
                SizeConfig.customSizedBox(
                  312,
                  48,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.textFieldBorderColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            width: SizeConfig.getProportionalWidth(20),
                            height: SizeConfig.getProportionalHeight(20),
                            child: Checkbox(
                              activeColor: AppColors.backgroundColor,
                              checkColor: AppColors.fontColor,
                              value: _authController.rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _authController.toggleRememberMe();
                                });
                              },
                              side: const BorderSide(
                                  color: AppColors
                                      .textFieldBorderColor), // Transparent to not show the default borde
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.getProportionalWidth(10)),
                            child: Text(
                              TranslationService().translate("remember_me"),
                              style: TextStyle(
                                fontFamily: AppFonts.primaryFont,
                                fontSize: 15,
                                color: AppColors.fontColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          TranslationService().translate("forgot_password"),
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16,
                            color: AppColors.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizeConfig.customSizedBox(null, 15, null),
                CustomAuthBtn(
                  text: TranslationService().translate('login'),
                  onTap: () async {
                    _authController.checkEmptyFields(true);
                    if (!_authController.noneIsEmpty) {
                      setState(() {
                        _authController.changeTextFieldsColors(true);
                      });
                      return;
                    } else {
                      setState(() {
                        _authController.changeTextFieldsColors(true);
                      });

                      var user = await AuthProvider().login(
                        _authController.emailController.text,
                        _authController.passwordController.text,
                      );

                      if (user == null) {
                        setState(() {
                          _authController.errorText = TranslationService()
                              .translate("wrong_email_password");
                        });
                        return;
                      } else {
                        await UsersProvider().getUsersById(user.user!.uid);
                        Get.to(RolesScreen(
                          user: user.user!,
                        ));
                        if (_authController.rememberMe == true) {
                          _authController.saveLoginInfo(
                            user.user!.email!,
                            _authController.passwordController.text,
                          );
                        }
                      }
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.getProportionalHeight(15),
                  ),
                  child: const CustomAuthDivider(),
                ),
                CustomGoogleAuthBtn(
                  text: TranslationService().translate("google_login"),
                  onTap: () {},
                ),
                SizeConfig.customSizedBox(null, 15, null),
                CustomAuthFooter(
                  headingText: "do_not_have_account",
                  tailText: "signup",
                  onTap: () => {Get.to(() => const SignUpScreen())},
                )
              ])),
        ));
  }
}
