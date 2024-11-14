import 'package:flutter/material.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile(
      {super.key, required this.icon, required this.text, this.trailing});

  final IconData icon;
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GeneralProvider().language == 'en' ? Icon(icon) : trailing,
      title: CustomText(
        text: text,
        isCenter: false,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      trailing: GeneralProvider().language == 'en' ? trailing : Icon(icon),
    );
  }
}
