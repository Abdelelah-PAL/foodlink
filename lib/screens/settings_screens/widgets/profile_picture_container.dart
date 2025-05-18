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
  });

  final SettingsProvider settingsProvider;
  final UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    final double size = SizeConfig.getProportionalWidth(68);

    Widget imageWidget;

    if (usersProvider.imageIsPicked) {
      imageWidget = ClipOval(
        child: Image.file(
          File(usersProvider.pickedFile!.path),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else if (usersProvider.selectedUser?.imageUrl != null &&
        usersProvider.selectedUser!.imageUrl!.isNotEmpty) {
      imageWidget = ClipOval(
        child: Image.network(
          usersProvider.selectedUser!.imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else {
      imageWidget = const Icon(
        Icons.person_outline_outlined,
        size: 50,
        color: Colors.white,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.widgetsColor,
      ),
      alignment: Alignment.center,
      child: imageWidget,
    );
  }
}
