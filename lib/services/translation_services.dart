import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/general_provider.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;

  TranslationService._internal();

  Map<String, String>? _localizedStrings;

  Future<void> loadTranslations(BuildContext context) async {
    final languageCode = Provider.of<GeneralProvider>(context, listen: false).language;

    String jsonString = await rootBundle.loadString('lib/core/utils/intl_$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    if (_localizedStrings == null) {
      if (kDebugMode) {
        print('Error: Translations not loaded');
      }
      return key;
    }
    return _localizedStrings![key] ?? key;
  }
}
