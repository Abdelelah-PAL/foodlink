import 'package:flutter/material.dart';
import 'package:foodlink/screens/home_screen/home_screen.dart';

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
    Container(),
    Container(),
    Container(),
  ];
}
