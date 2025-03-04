import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_back_button.dart';

class MealImageContainer extends StatefulWidget {
  const MealImageContainer({
    super.key,
    required this.isAddSource,
    required this.isUpdateSource,
    this.imageUrl,
    this.mealsProvider,
    this.backButtonOnPressed,
  });

  final bool isAddSource;
  final bool isUpdateSource;
  final String? imageUrl;
  final MealsProvider? mealsProvider;
  final VoidCallback? backButtonOnPressed;

  @override
  State<MealImageContainer> createState() => _MealImageContainerState();
}

class _MealImageContainerState extends State<MealImageContainer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.isUpdateSource
          ? Stack(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.getProportionalHeight(203),
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                      color: AppColors.widgetsColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      border: Border(
                        bottom: BorderSide(
                            width: 1, color: AppColors.defaultBorderColor),
                      )),
                  child: widget.mealsProvider!.imageIsPicked
                      ? Image.file(
                          File(widget.mealsProvider!.pickedFile!.path),
                          fit: BoxFit.fill,
                        )
                      : widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.imageUrl!,
                              fit: BoxFit.fill,
                            )
                          : null,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getProperVerticalSpace(12)),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        await widget.mealsProvider!
                            .pickImageFromSource(context);
                        Future.microtask(() {
                          if (mounted) setState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                CustomBackButton(
                  onPressed: widget.isUpdateSource
                      ? () {
                          Get.back();
                        }
                      : widget.backButtonOnPressed,
                ),
              ],
            )
          : Stack(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.getProportionalHeight(203),
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                      color: AppColors.widgetsColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      border: Border(
                        bottom: BorderSide(
                            width: 1, color: AppColors.defaultBorderColor),
                      )),
                  child: !widget.isAddSource &&
                          widget.imageUrl != null &&
                          widget.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.fill,
                        )
                      : null,
                ),
                if (widget.isAddSource)
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          await widget.mealsProvider!
                              .pickImageFromSource(context);
                          Future.microtask(() {
                            if (mounted) setState(() {});
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                TranslationService()
                                    .translate("upload_food_image"),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context))),
                            SizeConfig.customSizedBox(
                              10,
                              null,
                              null,
                            ),
                            const Icon(Icons.file_upload_outlined)
                          ],
                        ),
                      ),
                    ),
                  ),
                if (widget.mealsProvider!.imageIsPicked && widget.isAddSource)
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.getProportionalHeight(203),
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                        color: AppColors.widgetsColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        border: Border(
                          bottom: BorderSide(
                              width: 1, color: AppColors.defaultBorderColor),
                        )),
                    child: Image.file(
                      File(widget.mealsProvider!.pickedFile!.path),
                      fit: BoxFit.fill,
                    ),
                  ),
                CustomBackButton(
                  onPressed: widget.isUpdateSource
                      ? () {
                          Get.back();
                        }
                      : widget.backButtonOnPressed,
                ),
              ],
            ),
    );
  }
}
