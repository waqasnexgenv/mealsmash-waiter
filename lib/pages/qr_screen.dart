import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../helper/strings.dart';

class QrPage extends StatefulWidget {
  QrPage({Key? key}) : super(key: key);

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String? orderId;
  String? token;
  int? completeOrder;
  final CommonController controller = Get.find<CommonController>();

  Timer? timer;
  int secToWait = 3;
  int _start = 3;
  int looper = 0;
bool isadding= false;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          if (_start == 0) {
            looper++;
            log("Loop is $looper");
            setState(() {
              _start = secToWait;
            });
            var res = await controller.checkPaymentStatusBullsEye("",
                orderId: orderId as String);

            // if (res != null) {
            //   if (res is bool) {
            if (res != null && res == true) {
              stopTimer();
              // if (completeOrder == 1) {
              //   controller.completeOrder(orderId: orderId as String);
              // }
              Get.offAllNamed(PageRoutes.paymentSuccessPage,
                  arguments: [orderId]);
            }
            //   }
            // }
          } else {
            _start--;
            log("$_start");
          }
        },
      );
    });
  }

  stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var params = Get.arguments;
    if (params != null) {
      if (params.length > 1) {
        orderId = params[0];
        token = params[1];
        completeOrder = params[2];
        log("is it work for printer call?????");
      } else {
        controller.showToast("Invalid Parameters Received");
      }
    } else {
      controller.showToast("Invalid Parameters Received");
    }
    return
      SafeAreaHelper(
      child: WillPopScope(
        onWillPop: () async => onPop(),
        child:
        Column(
          children: [
            Expanded(

              child:
              isadding
                  ? kLoadingWidget(
                  loaderColor: BasicColors.loaderColor,
                  size: 32.sp)
                  :
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      QrImage(
                        data: "${token.toString()}",
                        version: QrVersions.auto,
                        size: MediaQuery.of(context).size.height * 0.4.h,
                        backgroundColor: BasicColors.white,
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Text(
                        "scanWithBullsEye".tr.toUpperCase(),
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: BasicColors.getBlackWhiteColor()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3.sp,
            ),
            Text(
              "orderNumberIs".tr.toUpperCase(),
              style: TextStyle(
                  fontSize: 18, color: BasicColors.getBlackWhiteColor()),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "$orderId".tr.toUpperCase(),
              style: TextStyle(
                  fontSize: 40.sp, color: BasicColors.getBlackWhiteColor()),
            ),
            SizedBox(
              height: 16.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    onPop();
                  },
                  child: Text(
                    "goBack".tr,
                    style: TextStyle(
                        fontSize: 18.sp, color: BasicColors.primaryColor),
                  ),
                ),
                SizedBox(
                  width: 20.sp,
                ),
                InkWell(
                  onTap: () async {


                    setState(() {

                      isadding=true;
                    });
                    await controller.checkPaymentStatusBullsEye(token,
                        orderId: orderId as String, fromReceipt: true);


                    setState(() {

                      isadding=false;
                    });
                  },
                  child: Text(
                    "Receipt".tr,
                    style: TextStyle(
                        fontSize: 18.sp, color: BasicColors.primaryColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  onPop() {
    stopTimer();
    Get.back();
  }
}
