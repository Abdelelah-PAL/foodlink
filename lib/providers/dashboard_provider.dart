import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/user_types.dart';
import '../screens/home_screen/home_screen.dart';

class DashboardProvider with ChangeNotifier {
  static final DashboardProvider _instance = DashboardProvider._internal();

  factory DashboardProvider() => _instance;

  DashboardProvider._internal();

  String language = 'ar';

  bool isExpanded = false;
  int selectedIndex = 0;
  int roleId = UserTypes.user;
  bool userPressed = false;
  bool cookerPressed = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController cookerNameController = TextEditingController();

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void toggleExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  void changeRole(userTypeId) {
    roleId = userTypeId;
    notifyListeners();
  }

  void togglePressed(roleId) {
    roleId = roleId;
    if(roleId == UserTypes.user) {
      userPressed = !userPressed;
      if(userPressed == true) {
        cookerPressed = false;
      }
    }
    else {
      cookerPressed = !cookerPressed;
      if(cookerPressed == true) {
        userPressed = false;
      }
    }
    notifyListeners();
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

  void resetValues() {
    cookerPressed = false;
    userPressed = false;
    selectedIndex = 0;
    notifyListeners();
  }
}
