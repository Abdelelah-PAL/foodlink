import 'package:flutter/material.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:provider/provider.dart';



class AppFonts {
  static String titleFont = 'salsa';
  static String getPrimaryFont(BuildContext context) {
    String language = Provider.of<SettingsProvider>(context).language;

    return language == "en" ? 'salsa' : 'MyriadArabic';
  }
}
