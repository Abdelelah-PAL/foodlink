import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/general_provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';

class CustomAuthenticationTextField extends StatefulWidget {
  const CustomAuthenticationTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.textEditingController,
    required this.borderColor,
  });

  final String hintText;
  final bool obscureText;
  final TextEditingController textEditingController;
  final Color borderColor;

  @override
  State<CustomAuthenticationTextField> createState() =>
      _CustomAuthenticationTextFieldState();
}

class _CustomAuthenticationTextFieldState
    extends State<CustomAuthenticationTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.getProportionalHeight(12)),
      child: Container(
        width: SizeConfig.getProportionalWidth(312),
        height: SizeConfig.getProportionalHeight(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.0, color: widget.borderColor),
          color: Colors.white,
        ),
        child: Padding(
          padding: GeneralProvider().language == 'en'
              ? EdgeInsets.only(left: SizeConfig.getProportionalWidth(10))
              : EdgeInsets.only(right: SizeConfig.getProportionalWidth(10)),
          child: TextField(
              textAlign: GeneralProvider().language == 'en'
                  ? TextAlign.left
                  : TextAlign.right,
              controller: widget.textEditingController,
              obscureText: widget.obscureText && !showPassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(10),
                  vertical: SizeConfig.getProportionalWidth(5),
                ),
                suffixIcon: GeneralProvider().language == "en"
                    ? widget.obscureText
                        ? IconButton(
                            icon: !showPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          )
                        : null
                    : null,
                prefixIcon: GeneralProvider().language == "ar"
                    ? widget.obscureText
                        ? IconButton(
                            icon: !showPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          )
                        : null
                    : null,

                hintText: widget.hintText,
                hintStyle: TextStyle(
                    color: AppColors.hintTextColor,
                    fontFamily: AppFonts.primaryFont),
                border: InputBorder.none,
              )
          )
          ,
        ),
      ),
    );
  }
}
