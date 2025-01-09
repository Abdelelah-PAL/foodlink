import 'package:flutter/material.dart';
import 'package:foodlink/providers/notification_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/notifications_screen/widgets/custom_tab_bar.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_types.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../dashboard/widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    UsersProvider usersProvider =
        Provider.of<UsersProvider>(context, listen: true);
    NotificationsProvider notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: true);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        bottomNavigationBar:
            const CustomBottomNavigationBar(fromDashboard: false),
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(SizeConfig.getProportionalHeight(100)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(50),
                  horizontal: SizeConfig.getProportionalWidth(20)),
              child: Row(
                children: [
                  const CustomBackButton(),
                  SizeConfig.customSizedBox(90, null, null),
                  const CustomText(
                      isCenter: true,
                      text: "notifications",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ],
              ),
            )),
        body: CustomTabBar(
          settingsProvider: settingsProvider,
          notifications:
              usersProvider.selectedUser!.userTypeId == UserTypes.user
                  ? notificationsProvider.userNotifications
                  : notificationsProvider.cookerNotifications,
          usersProvider: usersProvider,
        ));
  }
}
