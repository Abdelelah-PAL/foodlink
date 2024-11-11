import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/dashboard/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../controllers/dashboard_controller.dart';
import '../../core/constants/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
        child: const Header(),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: DashboardController()
            .dashBoardList[dashboardProviderWatcher.selectedIndex],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(fromDashboard: true,),
    );
  }
}
