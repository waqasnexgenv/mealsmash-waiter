import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungerz_ordering/helper/routes.dart';
import 'package:hungerz_ordering/helper/strings.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';
import 'package:hungerz_ordering/widgets/safe_area_helper.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final CommonController controller = Get.find<CommonController>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (await controller.isFirstTime()) {
        Get.offAllNamed(PageRoutes.settingPage, arguments: [true]);
        controller.setNotFirstTime();
      } else {
        if (await controller.isLogin()) {
          controller.getCategoriesDetail();
          controller.getSquareCategoriesDetail();

          Get.offAllNamed(PageRoutes.tableSelectionPage);
          controller.getTablesDetail();
          // controller.getCategoriesDetail();
          // controller.getSquareCategoriesDetail();
          // controller.getCart();
        } else {
          Get.offAllNamed(PageRoutes.loginPage);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaHelper(child: kLoadingWidget());
  }
}
