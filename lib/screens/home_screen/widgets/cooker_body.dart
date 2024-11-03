import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';

class CookerBody extends StatelessWidget {
  const CookerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: SizeConfig.getProportionalWidth(332) ,
          height: SizeConfig.getProportionalHeight(142),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Image.asset(
              Assets.dishOfTheWeek,
            fit: BoxFit.fill
          ),
        )
      ],
    );
  }
}
