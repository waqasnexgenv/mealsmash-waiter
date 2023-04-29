import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';

class PaymentSuccessPage extends StatelessWidget {
  final CommonController controller = Get.find<CommonController>();
  String? orderId;

  PaymentSuccessPage({Key? key}) : super(key: key) {
    var params = Get.arguments;
    if (params != null) {
      if (params.length > 0) {
        orderId = params[0];
      } else {
        controller.showToast("invalidparm".tr);
      }
    } else {
      controller.showToast("invalidparm".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaHelper(
      child: WillPopScope(
        onWillPop: () async => onPop(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "thankYou".tr.toUpperCase(),
                  style: TextStyle(fontSize: 22.sp, color: BasicColors.blueGrey),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "forPayingThroughBullseye".tr.toUpperCase(),
                  style: TextStyle(fontSize: 18.sp, color: BasicColors.blueGrey),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                  child: SizedBox(
                      width: 170.w,
                      height: 170.h,
                      child: Image.asset("assets/payment_success.gif")),
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () {
                    onPop();
                  },
                  child: Text(
                    "done".tr,
                    style: TextStyle(
                        fontSize: 22.sp, color: BasicColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onPop() {
    // showDialog(
    //     context: Get.context as BuildContext,
    //     builder: (BuildContext context) {
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 260),
    //         child: Dialog(
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(4.0)),
    //             child: Stack(
    //               clipBehavior: Clip.none,
    //               // overflow: Overflow.visible,
    //               alignment: Alignment.topCenter,
    //               children: [
    //                 Container(
    //                   height: MediaQuery.of(context).size.height* 0.5.h,
    //                   width: MediaQuery.of(context).size.width* 0.6.w,
    //                   // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.58: MediaQuery.of(context).size.height*0.25,
    //                   // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.96:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.65: MediaQuery.of(context).size.height*0.39,
    //                   child: Padding(
    //                     padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
    //                     child: Column(
    //                       children: [
    //                         SizedBox(
    //                           height: 10.h,
    //                         ),
    //                         Text(
    //                           "paymentSuccess".tr,
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 20.sp,
    //                               color: BasicColors.black),
    //                         ),
    //                         SizedBox(height: 10.h),
    //                         Text(
    //                           "doYouWantToCompleteOrder".tr,
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                               fontSize: 20.sp, color: BasicColors.black),
    //                         ),
    //                         Spacer(),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           crossAxisAlignment: CrossAxisAlignment.end,
    //                           children: [
    //                             Container(
    //                               width: MediaQuery
    //                                   .of(context)
    //                                   .size
    //                                   .width * 0.1.w,
    //                               height: MediaQuery
    //                                   .of(context)
    //                                   .size
    //                                   .height * 0.13.h,
    //                               decoration: BoxDecoration(
    //                                 color: BasicColors.primaryColor,
    //                                 borderRadius: BorderRadius.circular(
    //                                     MediaQuery
    //                                         .of(context)
    //                                         .size
    //                                         .width *
    //                                         0.03.w),
    //                               ),
    //                               child: TextButton(
    //                                 child: Text("no".tr,
    //                                     style: TextStyle(
    //                                         color: BasicColors.white,
    //                                         fontSize: 22.sp)),
    //                                 onPressed: () {
    //                                   Get.back();
    //                                   Get.offAllNamed(
    //                                       PageRoutes.tableSelectionPage);
    //                                 },
    //                               ),
    //                             ),
    //                             SizedBox(
    //                               width: MediaQuery
    //                                   .of(context)
    //                                   .size
    //                                   .width * 0.02.w,
    //                             ),
    //
    //                             Container(
    //                               width: MediaQuery
    //                                   .of(context)
    //                                   .size
    //                                   .width * 0.1.w,
    //                               height: MediaQuery
    //                                   .of(context)
    //                                   .size
    //                                   .height * 0.13.h,
    //                               decoration: BoxDecoration(
    //                                 color: BasicColors.primaryColor,
    //                                 borderRadius: BorderRadius.circular(
    //                                     MediaQuery
    //                                         .of(context)
    //                                         .size
    //                                         .width *
    //                                         0.03.w),
    //                               ),
    //                               child: TextButton(
    //                                 child: Text("yes".tr,
    //                                     style: TextStyle(
    //                                         color: BasicColors.white,
    //                                         fontSize: 22.sp)),
    //                                 onPressed: () async {
    //                                   Get.back();
    //                                   await controller.completeOrder(
    //                                       orderId: orderId as String,
    //                                       gotoTables: true);
    //                                 },
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                     top: MediaQuery.of(context).size.width * -0.03.w,
    //                     child: CircleAvatar(
    //                       backgroundColor: Colors.redAccent,
    //                       radius: MediaQuery.of(context).size.width * 0.03.w,
    //                       child: Icon(
    //                         Icons.info_outline,
    //                         color: Colors.white,
    //                         size: MediaQuery.of(context).size.width * 0.03.w,
    //                       ),
    //                     )),
    //               ],
    //             )),
    //       );
    //     });
    showDialog(

        context: Get.context as BuildContext,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              child: Stack(
                clipBehavior: Clip.none,
                //overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height* 0.3.h,
                    width: MediaQuery.of(context).size.width* 0.6.w,
                    // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.48: MediaQuery.of(context).size.height*0.26,
                    // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.96:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.45: MediaQuery.of(context).size.height*0.45,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Column(
                        children: [
                          Spacer(),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height*0.01,
                          // ),
                          Text(
                            // waqas
                            "paymentSuccess".tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: BasicColors.black),
                          ),
                          SizedBox(   height: MediaQuery.of(context).size.height*0.01.h,),
                          Text(
                            "doYouWantToCompleteOrder".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.sp, color: BasicColors.black),
                          ),
                          Spacer(),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height*0.02,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.1.w,
                                // height: MediaQuery.of(context).size.height * 0.13.h,
                                width: MediaQuery.of(context).size.width * 0.14.w,
                                height: MediaQuery.of(context).size.height * 0.06.h,
                                decoration: BoxDecoration(
                                  color: BasicColors.primaryColor,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                ),
                                child: TextButton(
                                  child: Text("no".tr,
                                      style: TextStyle(
                                          color: BasicColors.white,fontSize: 18.sp)),
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    Get.offAllNamed(
                                                                              PageRoutes.tableSelectionPage);
                                    // Get.offAllNamed(PageRoutes.splashPage);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.02.w,
                              ),
                              Container(
                                // width: MediaQuery
                                //     .of(context)
                                //     .size
                                //     .width * 0.1.w,
                                // height: MediaQuery
                                //     .of(context)
                                //     .size
                                //     .height * 0.13.h,
                                width: MediaQuery.of(context).size.width * 0.16.w,
                                height: MediaQuery.of(context).size.height * 0.06.h,
                                decoration: BoxDecoration(
                                  color: BasicColors.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.03.w),
                                ),
                                child: TextButton(
                                  child: Text("yes".tr,
                                      style: TextStyle(
                                          color: BasicColors.white,fontSize: 18.sp)),
                                  onPressed: () async {
                                    await controller.completeOrder(
                                                                              orderId: orderId as String,
                                                                              gotoTables: true);

                                  },
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Positioned(
                  //     top: MediaQuery.of(context).size.width * -0.03.w,
                  //     child: CircleAvatar(
                  //       backgroundColor: Colors.redAccent,
                  //       radius: MediaQuery.of(context).size.width * 0.03.w,
                  //       child: Icon(
                  //         Icons.info_outline,
                  //         color: Colors.white,
                  //         size: MediaQuery.of(context).size.width * 0.03.w,
                  //       ),
                  //     )),
                  Positioned(
                      top: MediaQuery.of(context).size.width * -0.07.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: MediaQuery.of(context).size.width * 0.07.w,
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.07.w,
                        ),
                      )),
                ],
              ));
        });
  }
}
