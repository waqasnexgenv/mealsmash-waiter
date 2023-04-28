import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';

class LightColors {
  static Color statusBarColor = BasicColors.white;
  static Color bodyBackgroundColor = BasicColors.white;
  static Color primaryTextColor = BasicColors.black;
}

class DarkColors {
  static Color statusBarColor = BasicColors.black;
  static Color bodyBackgroundColor = BasicColors.black;
  static Color primaryTextColor = BasicColors.white;
}

class BasicColors {
  static Color primaryColor = const Color(0xffFF4C35);
  static Color? secondaryColor = Colors.grey[600];
  static Color? homeBackgroundColor = Color(0xffeaeaea);

  static Color? secondSecondaryColor = Color(0xffF8F9FD);
  static Color? secondaryBlackColor = Color(0xff151515);
  static Color loaderColor = const Color(0xffFF4C35);
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color dividerColor = const Color(0xffefefef);
  static Color transparentColor = Colors.transparent;
  static Color blueGrey = Colors.blueGrey.shade800;
  static Color? strikeThroughColor = Colors.grey[400];
  static Color completedOrderColor = Color(0xff009946);
  static Color orderInProgressColor = Color(0xffFBAF03);
  static Color orderCompletedColor = Color(0xff009946);
  static Color orderPreparedColor = Color(0xffFBAF03);
  static Color orderPreparingColor = Colors.lightBlue;

  static Color getBlackWhiteColor([backgroundColorGet = false]) {
    final CommonController controller = Get.find<CommonController>();
    return controller.isDarkTheme.value
        ? backgroundColorGet
            ? black
            : white
        : backgroundColorGet
            ? white
            : black;
  }

  static Color dropBlackWhiteColor([backgroundColorGet = true]) {
    final CommonController controller = Get.find<CommonController>();
    return controller.isDarkTheme.value
        ? backgroundColorGet
            ? white
            : black
        : backgroundColorGet
            ? black
            : white;
  }

  static Color getWhiteBlackColor() {
    final CommonController controller = Get.find<CommonController>();
    return controller.isDarkTheme.value ? black : white;
  }
}
