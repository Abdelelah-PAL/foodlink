import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? Get.back,
      icon: Text(
        String.fromCharCode(Icons.arrow_back_ios.codePoint),
        style: TextStyle(
          fontFamily: Icons.arrow_back_ios.fontFamily,
          package: Icons.arrow_back_ios.fontPackage,
          fontSize: 20,
          color: Colors.black,
          shadows: const [
            Shadow(
              color: Color(0xF2FFFFFF),
              blurRadius: 6,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
