import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SizeConfig {
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;
    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * .024
        : screenWidth! * .024;

    if (kDebugMode) {
      print('this is the default size $defaultSize');
    }
  }

  // static double getProportionalWidth(double width) {
  //   //2.4 is the factor
  //   width = (width * 2.4) / 100;
  //   return (width / defaultSize!) * screenWidth!;
  // }
  //
  // static double getProportionalHeight(double height) {
  //   //1.09 is the factor
  //   height = (height * 1.09) / 100;
  //   return (height / defaultSize!) * screenHeight!;
  // }

  static double getProportionalWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth!;
  }

  static double getProportionalHeight(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight!;
  }

  static double getProperVerticalSpace(double value) {
    var space = screenHeight! / value;
    return space;
  }

  static double getProperHorizontalSpace(double value) {
    var space = screenWidth! / value;
    return space;
  }

  static Widget customSizedBox(double? width, double? height, Widget? child) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
