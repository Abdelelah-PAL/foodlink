import 'package:flutter/material.dart';
import 'package:foodlink/main.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/dashboard/widgets/home_screen_header.dart';
import 'package:provider/provider.dart';

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
    DashboardProvider dashboardProviderWatcher = context.watch<DashboardProvider>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100), // Set your desired height
        child: HomeScreenHeader(),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child:dashboardController.dashBoardList[dashboardProviderWatcher.selectedIndex],
        ),
      bottomNavigationBar:CustomBottomNavigationBar(dashboardController: dashboardController),
    );
  }
}
