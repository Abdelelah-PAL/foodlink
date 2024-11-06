import 'package:flutter/material.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/dashboard/widgets/home_screen_header.dart';

import '../../controllers/dashboard_controller.dart';
import '../../core/constants/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardController dashboardController;

  @override
  void initState() {
    dashboardController = DashboardController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Set your desired height
        child: HomeScreenHeader(
          onUpdate: () {
            setState(() {});
          },
          dashboardController: dashboardController,
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child:
              IndexedStack(
            index: dashboardController.selectedIndex,
            children: dashboardController.dashBoardList,
          ),
        ),
      bottomNavigationBar:CustomBottomNavigationBar(dashboardController: dashboardController),
    );
  }
}
