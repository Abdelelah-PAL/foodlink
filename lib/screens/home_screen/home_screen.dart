import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/home_screen/widgets/home_screen_header.dart';
import 'package:foodlink/services/translation_services.dart';

import '../../core/utils/size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(56)),
        child: Column(
          children: [HomeScreenHeader()],
        ),
      ),
    );
  }
}
