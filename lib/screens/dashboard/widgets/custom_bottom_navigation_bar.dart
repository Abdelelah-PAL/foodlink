import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/dashboard_provider.dart';
import '../dashboard.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key, required this.fromDashboard, required this.initialIndex});
  final bool fromDashboard;
  final int initialIndex;


  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      DashboardProvider().onItemTapped(index);
      Get.to( Dashboard(initialIndex: index,));
    });
    // if(!widget.fromDashboard) {
    //   Get.to(const Dashboard(initialIndex: 0,));
    // }
  }
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalWidth(355),
      height: SizeConfig.getProportionalHeight(61),
      margin: EdgeInsets.fromLTRB(
          SizeConfig.getProportionalWidth(20),
          SizeConfig.getProportionalHeight(10),
          SizeConfig.getProportionalWidth(20),
          SizeConfig.getProportionalHeight(25)),
      decoration: BoxDecoration(
        color: AppColors.widgetsColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 0),
          _buildNavItem(Icons.favorite_outline, 1),
          _buildNavItem(Icons.calendar_month_outlined, 2),
          _buildNavItem(Icons.person_outline_outlined, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Icon(
        size: 32,
        icon,
        color: _selectedIndex == index
            ? AppColors.backgroundColor
            : AppColors.fontColor,
      ),
    );
  }
}
