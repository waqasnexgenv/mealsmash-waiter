import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void configLoading() {
  EasyLoadingStyle.custom;
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.red
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..textStyle =  TextStyle(fontSize:16.sp,color: Colors.white )
    ..maskColor = Colors.red.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;

  // ..customAnimation = CustomAnimation();
}