import 'package:flutter/material.dart';
import 'package:foodlink/models/user_details.dart';
import '../../../core/utils/size_config.dart';

class FeatureContainer extends StatelessWidget {
  const FeatureContainer({
    super.key,
    required this.imageUrl,
    required this.onTap,
    required this.active,
    required this.premium,
    required this.user,
  });

  final String imageUrl;
  final VoidCallback onTap;
  final bool active;
  final bool premium;
  final UserDetails user;

  @override
  Widget build(BuildContext context) {
    return active == false || (premium == true && user.subscriber == false)
        ? const SizedBox.shrink()
        : Padding(
            padding:
                EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
            child: GestureDetector(
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: SizeConfig.getProportionalWidth(332),
                    height: SizeConfig.getProportionalHeight(127),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Image.network(imageUrl, fit: BoxFit.fill),
                  ),
                ],
              ),
            ),
          );
  }
}
