import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import '../../../core/constants/colors.dart';
import '../../../models/notification.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key, required this.notifications});

  final List<Notifications> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length, // Example data count
      itemBuilder: (context, index) {
        return ListTile(
          leading: notifications[index].imageUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                      notifications[index].imageUrl!))
              : Container(
                  width: SizeConfig.getProportionalWidth(42),
                  height: SizeConfig.getProportionalHeight(42),
                  decoration: const BoxDecoration( shape: BoxShape.circle, color: AppColors.widgetsColor),
                ),
          title: CustomText(
              isCenter: false,
              text: notifications[index].text,
              fontSize: 12,
              fontWeight: FontWeight.normal),
          subtitle: const Text('2 hours ago'),
        );
      },
    );
  }
}
