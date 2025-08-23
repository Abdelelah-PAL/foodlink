import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/authentication_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../roles_screen/roles_screen.dart';
import '../widgets/custom_text.dart';
import 'forget_password_screen.dart';
import 'sign_up_screen.dart';
import 'widgets/custom_auth_btn.dart';
import 'widgets/custom_auth_footer.dart';
import 'widgets/custom_auth_textfield.dart';
import 'widgets/custom_auth_textfield_header.dart';
import 'widgets/custom_error_txt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.firstScreen});

  final bool firstScreen;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthenticationController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthenticationController();
    _authController.getLoginInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.firstScreen) {
      SizeConfig().init(context);
    }
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context);

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            GestureDetector(
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
                              child: const CustomText(
                                isCenter: true,
                                text: "welcome_back",
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: AppColors.fontColor,
                              )),
                          CustomErrorTxt(
                            text: TranslationService()
                                .translate(_authController.loginErrorText),
                            settingsProvider: settingsProvider,
                          ),
                          SizeConfig.customSizedBox(null, 6, null),
                          CustomAuthTextFieldHeader(
                              text: TranslationService().translate('email'),
                              settingsProvider: settingsProvider),
                          CustomAuthenticationTextField(
                              hintText: 'example@example.com',
                              obscureText: false,
                              textEditingController:
                                  _authController.loginEmailController,
                              borderColor:
                                  _authController.loginPasswordTextFieldBorderColor,
                              settingsProvider: settingsProvider),
                          SizeConfig.customSizedBox(
                            null,
                            15,
                            null,
                          ),
                          CustomAuthTextFieldHeader(
                              text: TranslationService().translate('password'),
                              settingsProvider: settingsProvider),
                          CustomAuthenticationTextField(
                            hintText:
                                TranslationService().translate('enter_password'),
                            settingsProvider: settingsProvider,
                            obscureText: true,
                            textEditingController:
                                _authController.loginPasswordController,
                            borderColor:
                                _authController.loginPasswordTextFieldBorderColor,
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
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          checkboxTheme: const CheckboxThemeData(), // reset it
                                        ),
                                        child: Checkbox(
                                          value: _authController.rememberMe,
                                          activeColor: AppColors.primaryColor,
                                          checkColor: AppColors.backgroundColor,
                                          onChanged: (v) => setState(() => _authController.toggleRememberMe()),
                                          side: const BorderSide(color: AppColors.textFieldBorderColor, width: 2),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        ),
                                      )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              SizeConfig.getProportionalWidth(10)),
                                      child: Text(
                                        TranslationService()
                                            .translate("remember_me"),
                                        style: TextStyle(
                                          fontFamily:
                                              AppFonts.getPrimaryFont(context),
                                          fontSize: 15,
                                          color: AppColors.fontColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () =>
                                      {Get.to(() => const ForgotPasswordScreen())},
                                  child: Text(
                                    TranslationService()
                                        .translate("forgot_password"),
                                    style: TextStyle(
                                      fontFamily: AppFonts.getPrimaryFont(context),
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
                                  authenticationProvider.isLoading = true;
                                });

                                var user = await AuthenticationProvider().login(
                                  _authController.loginEmailController.text.trim(),
                                  _authController.loginPasswordController.text,
                                );

                                if (user == null) {
                                  setState(() {
                                    _authController.loginErrorText =
                                        TranslationService()
                                            .translate("wrong_email_password");
                                    authenticationProvider.isLoading = false;
                                  });
                                  return;
                                }
                                else {
                                  await UsersProvider()
                                      .getUsersById(user.user!.uid);
                                  await SettingsProvider()
                                      .getSettingsByUserId(user.user!.uid);

                                  if (_authController.rememberMe == true) {
                                    _authController.saveLoginInfo(
                                      user.user!.email!,
                                      _authController.loginPasswordController.text,
                                    );
                                  }

                                  usersProvider.setSettingsPassword(
                                    _authController.loginPasswordController.text,
                                  );


                                  Get.to(RolesScreen(user: user.user!));
                                }
                                AuthenticationProvider().resetLoading();

                              }
                            },
                          ),
                          SizeConfig.customSizedBox(null, 50, null),
                          CustomAuthFooter(
                              headingText: "do_not_have_account",
                              tailText: "signup",
                              onTap: () => {
                                    AuthenticationProvider().resetSignUpErrorText(),
                                    Get.to(() => const SignUpScreen())
                                  },
                              settingsProvider: settingsProvider),
                        ])),
                  ),
            if (authenticationProvider.isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ));
  }
}
