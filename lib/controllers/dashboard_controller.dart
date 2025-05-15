import 'package:flutter/material.dart';
import '../screens/food_screens/favorites_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/schedule/schedule.dart';
import '../screens/settings_screens/settings_screen.dart';

class DashboardController {
  static final DashboardController _instance = DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();
  TextEditingController userNameController = TextEditingController();
  TextEditingController cookerNameController = TextEditingController();

  bool isExpanded = false;
  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
  }
  List<Widget> dashBoardList = [
    const HomeScreen(),
    const Favorites(),
    const Schedule(),
    const SettingsScreen(),
  ];
}
