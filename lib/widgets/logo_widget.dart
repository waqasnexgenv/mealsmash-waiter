import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';
import 'package:hungerz_ordering/helper/colors.dart';
import 'package:hungerz_ordering/helper/strings.dart';

class LogoWidget extends StatelessWidget {
  final CommonController controller = Get.find<CommonController>();

  LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadedScaleAnimation(
      GestureDetector(
        onDoubleTap: () {
          // Get.toNamed(PageRoutes.paymentSuccessPage);
        },
        child: RichText(maxLines: 1,
            text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: '${Strings.mealSmash.toUpperCase()}',

              style: TextStyle(
                  color: BasicColors.getBlackWhiteColor(),
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp)),
          TextSpan(
              text: '${Strings.ordering}',

              style: TextStyle(
                  color: BasicColors.primaryColor,
                  letterSpacing: 1,

                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp)),
        ])),
      ),
      durationInMilliseconds: 400,
    );
  }
}

class LogoWidgetmo extends StatelessWidget {
  final CommonController controller = Get.find<CommonController>();

  LogoWidgetmo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadedScaleAnimation(
      GestureDetector(
        onDoubleTap: () {
          // Get.toNamed(PageRoutes.paymentSuccessPage);
        },
        child: RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: '${Strings.mealSmash.toUpperCase()}',
                  style: TextStyle(
                      color: BasicColors.getBlackWhiteColor(),
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp)),
              TextSpan(
                  text: '${Strings.ordering}',
                  style: TextStyle(
                      color: BasicColors.primaryColor,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp)),
            ])),
      ),
      durationInMilliseconds: 400,
    );
  }
}