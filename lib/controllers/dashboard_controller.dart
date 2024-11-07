import 'package:flutter/material.dart';
import 'package:foodlink/screens/home_screen/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DashboardController {
  bool isExpanded = false;
  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
  }

  Future<void> handleIndexChanged(int index) async {
    switch (index) {
      case 0:
        await Get.to(const HomeScreen());
        selectedIndex = 0;
        break;
      case 1:
        // await Get.to(AppRoutes.notificationScreen);
        selectedIndex = 0;
        break;

      case 2:
        // await Get.to(AppRoutes.profileScreen);
        selectedIndex = 0;
        break;
      case 3:
        // await Get.to(AppRoutes.profileScreen);
        selectedIndex = 0;
        break;
      default:
        selectedIndex = index;
    }
  }
  List<Widget> dashBoardList = [
    const HomeScreen(),
    Container(),
    Container(),
    Container(),
  ];
}
