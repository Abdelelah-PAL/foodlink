import 'package:foodlink/services/settings_services.dart';
import '../models/user_settings.dart';
import 'package:flutter/cupertino.dart';

class SettingsProvider with ChangeNotifier {
  static final SettingsProvider _instance = SettingsProvider._internal();

  factory SettingsProvider() => _instance;

  SettingsProvider._internal();

  final SettingsServices _ss = SettingsServices();
  late UserSettings settings;
  String language = 'ar';
  bool activeNotification = true;
  bool activeUpdates = true;

  Future<void> addSettings(userId) async {
    await _ss.addSettings(userId);
  }

  Future<void> getSettingsByUserId(String userId) async {
    try {
      settings = await _ss.getSettingsByUserId(userId);
      notifyListeners();
    } catch (ex) {
      rethrow;
    }
  }

  void toggleNotifications(userId) {
    activeNotification = !activeNotification;
    notifyListeners();
    _ss.toggleNotifications(userId, activeNotification);
  }

  void toggleUpdates(userId) {
    activeUpdates = !activeUpdates;
    notifyListeners();
    _ss.toggleUpdates(userId, activeUpdates);
  }

  void changeLanguage(chosenLanguage, userId) {
    language = chosenLanguage;
    notifyListeners();
    _ss.changeLanguage(userId, language);
  }
}
