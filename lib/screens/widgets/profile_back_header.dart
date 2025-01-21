import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:foodlink/screens/widgets/profile_circle.dart';

class ProfileBackHeader extends StatelessWidget {
  const ProfileBackHeader({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.getProportionalHeight(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(),
          ProfileCircle(
            height: 38,
            width: 38,
            iconSize: 25,
          ),
        ],
      ),
    );
  }
}
