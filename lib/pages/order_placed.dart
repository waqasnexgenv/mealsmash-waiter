import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/widgets/logo_widget.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPlaced extends StatefulWidget {
  OrderPlaced({Key? key}) : super(key: key);

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  final CommonController controller = Get.find<CommonController>();
  dynamic argumentData = Get.arguments;

  Map? orderDetail;

  var platform;

  var pref;
var takeaway;
  Configure() async {
    pref = await SharedPreferences.getInstance();
    platform = pref.getString('platform_configured');


  }

  @override
  void initState() {
    super.initState();
    print(argumentData[1]);
    takeaway=argumentData[1];

    print("Typeeee${takeaway}");

    Configure();
    // print("dsfsdffsd${platform}");
    // controller.getCart(widget.tableId.toString());
  }

  @override
  Widget build(BuildContext context) {

    var params = Get.arguments;
    if (params != null) {
      if (params.length > 0) {
        orderDetail = params[0];
      }
    }
    return SafeAreaHelper(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Obx(() => AbsorbPointer(
                  absorbing: controller.isCancelingOrder.value ||
                      controller.isSavingOrder.value,
                  child: Padding(
                    padding:  EdgeInsets.all(18.0.sp),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: 20.h,
                          // ),
                          Text(
                            "weMustSay".tr.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),fontSize: 18.sp
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "youveGreatChoiceOfTaste".tr.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16.sp,
                                letterSpacing: 1,
                                color: BasicColors.getBlackWhiteColor(),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          FadedScaleAnimation(
                            Container(
                              width: MediaQuery.of(context).size.height * 0.22.h,
                              child: Image(
                                image: AssetImage("assets/order confirmed.png"),
                              ),
                            ),
                            durationInMilliseconds: 400,
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "orderNumberIs".tr.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16.sp,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor()),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${orderDetail?['orderId']}".toUpperCase(),
                            style: TextStyle(
                                fontSize: 40.sp,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor()),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "orderConfirmedWith".tr.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16.sp,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor()),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          LogoWidgetmo(),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "yourOrderWillBeAtYourTable".tr.toUpperCase(),
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor()),
                          ),
                          Text(
                            "anytimeSoon".tr.toUpperCase(),
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor()),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [

                              takeaway!= 'take_away'?
      SizedBox(
        width: MediaQuery.of(context).size.width*0.4,
                         // width: 250.w,
                         child: InkWell(
                           onTap: () {
                             controller.saveOrder(
                                 orderId: "${orderDetail?['orderId']}");
                           },
                           child: Container(
                             padding: getSaveAndPayNowBtnPadding(),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 border: Border.all(
                                     color: BasicColors.primaryColor)),
                             child:


                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment:
                               CrossAxisAlignment.center,
                               children: [
                                 FadedScaleAnimation(
                                   Container(
                                     child: Icon(
                                       Icons.save,
                                       size: 30.sp,
                                       color: BasicColors.primaryColor,
                                     ),
                                   ),
                                   durationInMilliseconds: 600,
                                 ),
                                 SizedBox(
                                   width: 10.w,
                                 ),
                                 Flexible(
                                   fit: FlexFit.loose,
                                   child: Text(
                                     "saveOrder".tr.toUpperCase(),
                                     style: TextStyle(
                                       color: BasicColors.primaryColor,
                                       fontSize: 14.sp,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ):
                              SizedBox(
      width: 250.w,
      child: InkWell(
        // onTap: () {
        //   controller.saveOrder(
        //       orderId: "${orderDetail?['orderId']}");
        // },
        child: Container(
          padding: getSaveAndPayNowBtnPadding(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.grey)),
          child:


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              FadedScaleAnimation(
                Container(
                  child: Icon(
                    Icons.save,
                    size: 40.sp,
                    color: Colors.grey,
                  ),
                ),
                durationInMilliseconds: 600,
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  "saveOrder".tr.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 22.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),

                              SizedBox(
                                // width: 200.w,
                                width: MediaQuery.of(context).size.width*0.4,
                                child: InkWell(
                                  onTap: () async {
                                    print("Priceee${orderDetail!['price']}");
                                    platform == "SQUARE"
                                        ? await Get.toNamed(
                                            PageRoutes.SquarepayNowPage,
                                            arguments: [
                                                false,
                                                orderDetail!['orderId'],
                                                orderDetail!['price'],
                                                orderDetail!['order'],
                                              ])
                                        : await Get.toNamed(PageRoutes.payNowPage,
                                            arguments: [
                                                false,
                                                orderDetail!['orderId'],
                                                orderDetail!['price'],
                                                orderDetail!['order'],
                                              ]);
                                  },
                                  child: Container(
                                    padding: getSaveAndPayNowBtnPadding(),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: BasicColors.primaryColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FadedScaleAnimation(
                                          Container(
                                            child: Icon(
                                              Icons.attach_money,
                                              size: 30.sp,
                                              color: BasicColors.primaryColor,
                                            ),
                                          ),
                                          durationInMilliseconds: 600,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Text(
                                            "payNow".tr.toUpperCase(),
                                            style: TextStyle(
                                              color: BasicColors.primaryColor,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return Padding(
                              //         padding: const EdgeInsets.symmetric(horizontal: 260),
                              //         child: Dialog(
                              //             shape: RoundedRectangleBorder(
                              //                 borderRadius:
                              //                     BorderRadius.circular(4.0.sp)),
                              //             child: Stack(
                              //               clipBehavior: Clip.none,
                              //               // overflow: Overflow.visible,
                              //               alignment: Alignment.topCenter,
                              //               children: [
                              //                 Container(
                              //                   height: MediaQuery.of(context).size.height* 0.5.h,
                              //                   width: MediaQuery.of(context).size.width* 0.6.w,
                              //                   // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.38: MediaQuery.of(context).size.height*0.25,
                              //                   // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.96:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.4: MediaQuery.of(context).size.width*0.3,
                              //                   child: Padding(
                              //                     padding:
                              //                         const EdgeInsets.fromLTRB(
                              //                             10, 20, 10, 10),
                              //                     child: Column(
                              //                       children: [
                              //                         // SizedBox(
                              //                         //   height: 10,
                              //                         // ),
                              //                         Spacer(),
                              //                         Text(
                              //                           "alert".tr,
                              //                           style: TextStyle(
                              //                               fontWeight:
                              //                                   FontWeight.bold,
                              //                               fontSize: 24.sp),
                              //                         ),
                              //                         // Spacer(),
                              //                         // SizedBox(height: 10),
                              //                         Text(
                              //                           "doYouWantToCancelOrder".tr,
                              //                           style:
                              //                               TextStyle(fontSize: 24.sp),
                              //                         ),
                              //                         Spacer(),
                              //                         // SizedBox(height: 30),
                              //                         Row(
                              //                           mainAxisAlignment:
                              //                               MainAxisAlignment.center,
                              //                           crossAxisAlignment:
                              //                               CrossAxisAlignment.center,
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
                              //                                 },
                              //                               ),
                              //                             ),
                              //                             SizedBox(
                              //                               width: MediaQuery.of(
                              //                                           context)
                              //                                       .size
                              //                                       .width *
                              //                                   0.02.w,
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
                              //                                   controller.cancelOrder(
                              //                                       "${orderDetail!['orderId']}");
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
                              //                     top: MediaQuery.of(context)
                              //                             .size
                              //                             .width *
                              //                         -0.03.w,
                              //                     child: CircleAvatar(
                              //                       backgroundColor:
                              //                           Colors.redAccent,
                              //                       radius: MediaQuery.of(context)
                              //                               .size
                              //                               .width *
                              //                           0.03.w,
                              //                       child: Icon(
                              //                         Icons.warning_amber_rounded,
                              //                         color: Colors.white,
                              //                         size: MediaQuery.of(context)
                              //                                 .size
                              //                                 .width *
                              //                             0.03.w,
                              //                       ),
                              //                     )),
                              //               ],
                              //             )),
                              //       );
                              //     });
                              showDialog(

                                  context: context,
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
                                                padding:  EdgeInsets.fromLTRB(0, 10.sp, 10.sp, 10.sp),
                                                child: Column(
                                                  children: [
                                                    Spacer(),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Text(
                                                      // waqas
                                                      "alert".tr,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18.sp,
                                                          color: BasicColors.black),
                                                    ),
                                                    SizedBox(   height: MediaQuery.of(context).size.height*0.01.h,),
                                                    Text(
                                                      "doYouWantToCancelOrder".tr,
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
                                                               Get.back();
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
                                                              Get.back();
                                                                                                controller.cancelOrder(
                                                                                                    "${orderDetail!['orderId']}");

                                                              // controller.logOutUser();
                                                              // await controller.completeOrder(
                                                              //     orderId: orderId as String,
                                                              //     gotoTables: true
                                                              // );
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
                                                  radius: MediaQuery.of(context).size.width * 0.1.w,
                                                  child: Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Colors.white,
                                                    size: MediaQuery.of(context).size.width * 0.1.w,
                                                  ),
                                                )),
                                          ],
                                        ));
                                  });
                            },
                            child: Text(
                              "cancelOrder".tr.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  color: BasicColors.primaryColor),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
          Obx(() => controller.isCancelingOrder.value ||
                  controller.isSavingOrder.value
              ? kLoadingWidget()
              : SizedBox.shrink())
        ],
      ),
    );
  }

  getSaveAndPayNowBtnPadding() {
    return EdgeInsets.symmetric(horizontal: 10, vertical: 15);
  }
}
