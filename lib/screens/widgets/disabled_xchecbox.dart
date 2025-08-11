import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class DisabledXCheckbox extends StatelessWidget {
  const DisabledXCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
          color: AppColors.primaryColor,
        ),
        child: const Center(
          child: Text(
            'X',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.backgroundColor,
            ),
          ),
        ));
  }
}
