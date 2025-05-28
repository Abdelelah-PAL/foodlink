import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/users_provider.dart';

class ProfilePictureContainer extends StatelessWidget {
  const ProfilePictureContainer({
    super.key,
    required this.settingsProvider,
    required this.usersProvider,
    required this.circleSize,
    required this.iconSize,
  });

  final SettingsProvider settingsProvider;
  final UsersProvider usersProvider;
  final double circleSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final double responsiveSize = SizeConfig.getProportionalWidth(circleSize);

    Widget imageWidget;

    if (usersProvider.imageIsPicked) {
      imageWidget = ClipOval(
        child: Image.file(
          File(usersProvider.pickedFile!.path),
          width: responsiveSize,
          height: responsiveSize,
          fit: BoxFit.cover,
        ),
      );
    } else if (usersProvider.selectedUser?.imageUrl != null &&
        usersProvider.selectedUser!.imageUrl!.isNotEmpty) {
      imageWidget = ClipOval(
        child: Image.network(
          usersProvider.selectedUser!.imageUrl!,
          width: responsiveSize,
          height: responsiveSize,
          fit: BoxFit.cover,
        ),
      );
    } else {
      imageWidget = Icon(
        Icons.person_outline_outlined,
        size: iconSize,
        color: Colors.black,
      );
    }

    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.widgetsColor,
      ),
      alignment: Alignment.center,
      child: imageWidget,
    );
  }
}
