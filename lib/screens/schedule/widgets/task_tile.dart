import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';

import '../../../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(
      {super.key, required this.settingsProvider, required this.task});

  final SettingsProvider settingsProvider;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: settingsProvider.language == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        SizeConfig.customSizedBox(
          60,
          67,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(task.startTime), Text(task.endTime)],
          ),
        ),
        SizeConfig.customSizedBox(20, null, null),
        Container(
          height: SizeConfig.getProportionalHeight(73),
          width: SizeConfig.getProportionalWidth(242),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.widgetsColor, width: 3)),
          child: Column(
            children: [
              CustomText(
                  isCenter: false,
                  text: task.taskName,
                  fontSize: 18,
                  color: AppColors.hintTextColor,
                  fontWeight: FontWeight.normal),
              task.description != null
                  ? CustomText(
                      isCenter: false,
                      text: task.description!,
                      fontSize: 18,
                      fontWeight: FontWeight.normal)
                  : const SizedBox(),
            ],
          ),
        )
      ],
    );
  }
}
