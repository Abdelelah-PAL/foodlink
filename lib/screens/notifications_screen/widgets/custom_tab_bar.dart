import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/providers/settings_provider.dart';
import '../../../models/meal.dart';
import '../../../models/notification.dart';
import '../../../services/translation_services.dart';
import 'notification_tab.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {super.key, required this.settingsProvider, required this.notifications, required this.meals});

  final SettingsProvider settingsProvider;
  final List<Notifications> notifications;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          leading: Container(),
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Directionality(
              textDirection: settingsProvider.language == "en"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: TabBar(
                dividerColor: Colors.transparent,
                isScrollable: true,
                indicatorColor: AppColors.tabBarIndicatorColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: settingsProvider.language == 'en'
                    ? [
                        Tab(
                            text: TranslationService()
                                .translate('notifications')),
                        Tab(text: TranslationService().translate('updates')),
                      ]
                    : [
                        Tab(text: TranslationService().translate('updates')),
                        Tab(
                            text: TranslationService()
                                .translate('notifications')),
                      ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: settingsProvider.language == 'en'
              ? [
                  NotificationsTab(notifications: notifications, meals: meals, settingsProvider: settingsProvider,),
                  const UpdatesTab(),
                ]
              : [
                  const UpdatesTab(),
                  NotificationsTab(notifications: notifications, meals: meals, settingsProvider: settingsProvider,),
                ],
        ),
      ),
    );
  }
}

class UpdatesTab extends StatelessWidget {
  const UpdatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Updates',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
