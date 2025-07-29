import 'package:flutter/cupertino.dart';

import '../providers/authentication_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/users_provider.dart';
import 'authentication_controller.dart';

class SettingsController {
  static final SettingsController _instance = SettingsController._internal();

  factory SettingsController() => _instance;

  SettingsController._internal();

  Future<void> updateUserDetails(
      UsersProvider usersProvider,
      DashboardProvider dashboardProvider,
      AuthenticationProvider authenticationProvider,
      String userId,
      String username,
      String email,
      String password,
      int userTypeId,
      BuildContext context) async {
    await usersProvider.updateUserDetails(userId, username, email, userTypeId);
    if (password != "") {
      await usersProvider.changePassword(password);
      AuthenticationController().logout(authenticationProvider, dashboardProvider);
    }
    usersProvider.imageIsPicked = false;
    usersProvider.pickedFile = null;
  }
}
