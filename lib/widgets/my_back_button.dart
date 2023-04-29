import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/pages/printer_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBackButton extends StatelessWidget {
  MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.chevron_left,
        size: 25.sp,
        color: BasicColors.getBlackWhiteColor(),
      ),
      onPressed: () {
        Get.back();
      },
    );
  }
}

class MyPrintButton extends StatelessWidget {
  MyPrintButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: IconButton(
        icon: Icon(
          Icons.chevron_right,
          size: 25.sp,
          color: BasicColors.getBlackWhiteColor(),
        ),
        onPressed: () {
          Get.to(() => PrinterSetup());
        },
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  LogoutButton({Key? key}) : super(key: key);
  late final CommonController controller = Get.find<CommonController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: IconButton(
        icon: Icon(
          Icons.chevron_right,
          size: 25.sp,
          color: BasicColors.getBlackWhiteColor(),
        ),
        onPressed: () async {
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
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Column(
                              children: [
                                Spacer(),
                                // SizedBox(
                                //   height: MediaQuery.of(context).size.height*0.01,
                                // ),
                                Text(
                                  // waqas
                                  "Logout".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      color: BasicColors.black),
                                ),
                                SizedBox(   height: MediaQuery.of(context).size.height*0.01.h,),
                                Text(
                                  "Do you really want to logout?".tr,
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
                                          Navigator.pop(context);
                                          // Get.back();
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
                                          controller.logOutUser();
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
                                Icons.info_outline,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.1.w,
                              ),
                            )),
                      ],
                    ));
              });

//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//
//                 return  Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 260),
//                   child: Dialog(
//                     // waqasgggggggggggggggggggggggggg
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(4.0)),
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         // overflow: Overflow.visible,
//                         alignment: Alignment.topCenter,
//                         children: [
//                           Container(
//                             height: MediaQuery.of(context).size.height* 0.1.h,
//                             width: MediaQuery.of(context).size.width* 0.3.w,
//                             // color: Colors.red,
//                             // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.38: MediaQuery.of(context).size.height*0.25,
//                             // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.56:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.4: MediaQuery.of(context).size.width*0.39,
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
//                               child: Column(
//                                 children: [
//                                   Spacer(),
//                                   // SizedBox(
//                                   //   height: MediaQuery.of(context).size.height*0.01,
//                                   // ),
//                                   Text(
//                                     "Logout".tr,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 22.sp,
//                                         color: BasicColors.black),
//                                   ),
//                                   SizedBox(height: MediaQuery.of(context).size.height * 0.01.h,),
//                                   Row(
// mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//
//                                         width: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .width * 0.35.w,
//
//                                         child: Text(
//                                           "Do you really want to logout?",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 18.sp, color: BasicColors.black),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Spacer(),
//                                   // SizedBox(
//                                   //   height: MediaQuery.of(context).size.height*0.02,
//                                   // ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Container(
//                                         width: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .width * 0.1.w,
//                                         height: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .height * 0.13.h,
//                                         decoration: BoxDecoration(
//                                           color: BasicColors.primaryColor,
//                                           borderRadius: BorderRadius.circular(
//                                               MediaQuery
//                                                   .of(context)
//                                                   .size
//                                                   .width *
//                                                   0.03.w),
//                                         ),
//                                         child: TextButton(
//                                           child: Text("no".tr,
//                                               style: TextStyle(
//                                                   color: BasicColors.white,
//                                                   fontSize: 22.sp)),
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .width * 0.02.w,
//                                       ),
//                                       Container(
//                                         width: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .width * 0.1.w,
//                                         height: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .height * 0.13.h,
//                                         decoration: BoxDecoration(
//                                           color: BasicColors.primaryColor,
//                                           borderRadius: BorderRadius.circular(
//                                               MediaQuery
//                                                   .of(context)
//                                                   .size
//                                                   .width *
//                                                   0.03.w),
//                                         ),
//                                         child: TextButton(
//                                           child: Text("yes".tr,
//                                               style: TextStyle(
//                                                   color: BasicColors.white,
//                                                   fontSize: 22.sp)),
//                                           onPressed: () async {
//                                             Get.back();
//                                             controller.logOutUser();
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                               top: MediaQuery.of(context)
//                                   .size
//                                   .width *
//                                   -0.03.w,
//                               child: CircleAvatar(
//                                 backgroundColor:
//                                 Colors.redAccent,
//                                 radius:
//                                 MediaQuery.of(context)
//                                     .size
//                                     .width *
//                                     0.03.w,
//                                 child: Icon(
//                                   Icons.info_outline,
//                                   color: Colors.white,
//                                   size:
//                                   MediaQuery.of(context)
//                                       .size
//                                       .width *
//                                       0.03.w,
//                                 ),
//                               )),
//
//                         ],
//                       )),
//                 );
//
//
//
//
//
//
//
//
//                   // Dialog(
//                   //     shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(4.0)),
//                   //     child: Stack(
//                   //       clipBehavior: Clip.none,
//                   //       // overflow: Overflow.visible,
//                   //       alignment: Alignment.topCenter,
//                   //       children: [
//                   //         Container(
//                   //           height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.38: MediaQuery.of(context).size.height*0.25,
//                   //           width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.56:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.4: MediaQuery.of(context).size.width*0.39,
//                   //           child: Padding(
//                   //             padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
//                   //             child: Column(
//                   //               children: [
//                   //                 Spacer(),
//                   //                 // SizedBox(
//                   //                 //   height: MediaQuery.of(context).size.height*0.01,
//                   //                 // ),
//                   //                 Text(
//                   //                   "Logout".tr,
//                   //                   style: TextStyle(
//                   //                       fontWeight: FontWeight.bold,
//                   //                       fontSize: 22,
//                   //                       color: BasicColors.black),
//                   //                 ),
//                   //                 SizedBox(height: MediaQuery
//                   //                     .of(context)
//                   //                     .size
//                   //                     .height * 0.01,),
//                   //                 Text(
//                   //                   "Do you really want to logout?",
//                   //                   textAlign: TextAlign.center,
//                   //                   style: TextStyle(
//                   //                       fontSize: 22, color: BasicColors.black),
//                   //                 ),
//                   //                 Spacer(),
//                   //                 // SizedBox(
//                   //                 //   height: MediaQuery.of(context).size.height*0.02,
//                   //                 // ),
//                   //                 Row(
//                   //                   mainAxisAlignment: MainAxisAlignment.center,
//                   //                   crossAxisAlignment: CrossAxisAlignment.end,
//                   //                   children: [
//                   //                     Container(
//                   //                       width: MediaQuery
//                   //                           .of(context)
//                   //                           .size
//                   //                           .width * 0.1,
//                   //
//                   //                       decoration: BoxDecoration(
//                   //                         color: BasicColors.primaryColor,
//                   //                         borderRadius: BorderRadius.circular(
//                   //                             MediaQuery
//                   //                                 .of(context)
//                   //                                 .size
//                   //                                 .width *
//                   //                                 0.03),
//                   //                       ),
//                   //                       child: TextButton(
//                   //                         child: Text("no".tr,
//                   //                             style: TextStyle(
//                   //                                 color: BasicColors.white,
//                   //                                 fontSize: 22)),
//                   //                         onPressed: () {
//                   //                           Navigator.pop(context);
//                   //                         },
//                   //                       ),
//                   //                     ),
//                   //                     SizedBox(
//                   //                       width: MediaQuery
//                   //                           .of(context)
//                   //                           .size
//                   //                           .width * 0.01,
//                   //                     ),
//                   //                     Container(
//                   //                       width: MediaQuery
//                   //                           .of(context)
//                   //                           .size
//                   //                           .width * 0.1,
//                   //                       decoration: BoxDecoration(
//                   //                         color: BasicColors.primaryColor,
//                   //                         borderRadius: BorderRadius.circular(
//                   //                             MediaQuery
//                   //                                 .of(context)
//                   //                                 .size
//                   //                                 .width *
//                   //                                 0.03),
//                   //                       ),
//                   //                       child: TextButton(
//                   //                         child: Text("yes".tr,
//                   //                             style: TextStyle(
//                   //                                 color: BasicColors.white,
//                   //                                 fontSize: 22)),
//                   //                         onPressed: () async {
//                   //                           Get.back();
//                   //                           controller.logOutUser();
//                   //                         },
//                   //                       ),
//                   //                     ),
//                   //                   ],
//                   //                 ),
//                   //               ],
//                   //             ),
//                   //           ),
//                   //         ),
//                   //         Positioned(
//                   //             top: MediaQuery.of(context)
//                   //                 .size
//                   //                 .width *
//                   //                 -0.03,
//                   //             child: CircleAvatar(
//                   //               backgroundColor:
//                   //               Colors.redAccent,
//                   //               radius:
//                   //               MediaQuery.of(context)
//                   //                   .size
//                   //                   .width *
//                   //                   0.03,
//                   //               child: Icon(
//                   //                 Icons.info_outline,
//                   //                 color: Colors.white,
//                   //                 size:
//                   //                 MediaQuery.of(context)
//                   //                     .size
//                   //                     .width *
//                   //                     0.03,
//                   //               ),
//                   //             )),
//                   //
//                   //       ],
//                   //     ));
//               });








          // controller.logOutUser();
        },
      ),
    );
  }
}
