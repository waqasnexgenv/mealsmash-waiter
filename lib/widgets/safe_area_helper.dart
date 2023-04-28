import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';
import 'package:hungerz_ordering/helper/colors.dart';


class SafeAreaHelper extends StatelessWidget {
  final Widget child;
  final dynamic backgroundColor;
  final CommonController controller = Get.find<CommonController>();
  SafeAreaHelper({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: controller.isDarkTheme.value
              ? DarkColors.statusBarColor
              : LightColors.statusBarColor,
          statusBarIconBrightness: controller.isDarkTheme.value
              ? Brightness.light
              : Brightness.dark),
      child: Container(
        color: controller.isDarkTheme.value
            ? DarkColors.statusBarColor
            : LightColors.statusBarColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: (backgroundColor is Color)
                ? backgroundColor
                : controller.isDarkTheme.value
                ? DarkColors.bodyBackgroundColor
                : LightColors.bodyBackgroundColor,
            body: child,
          ),
        ),
      ),
    ));
  }
}