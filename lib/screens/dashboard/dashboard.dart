import 'package:flutter/material.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/constants/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.initialIndex});
  final int initialIndex;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProviderWatcher =
        context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: DashboardController()
            .dashBoardList[dashboardProviderWatcher.selectedIndex],
      ),
      bottomNavigationBar:  CustomBottomNavigationBar(fromDashboard: true, initialIndex: widget.initialIndex,),
    );
  }
}
