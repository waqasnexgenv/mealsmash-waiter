// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hungerz_ordering/controllers/common_controller.dart';
// import 'package:hungerz_ordering/helper/colors.dart';
// import 'package:hungerz_ordering/helper/config.dart';
// import 'package:hungerz_ordering/helper/routes.dart';
// import 'package:hungerz_ordering/helper/strings.dart';
// import 'package:hungerz_ordering/model/Sorder.dart';
// import 'package:hungerz_ordering/model/order.dart';
// import 'package:hungerz_ordering/widgets/custom_circular_button.dart';
// import 'package:hungerz_ordering/widgets/entry_field.dart';
// import 'package:hungerz_ordering/widgets/safe_area_helper.dart';
//
// class PayNowPage extends StatefulWidget {
//   bool isPayAsCashClicked = false;
//   String change = "0.0";
//   String? error;
//
//   PayNowPage({Key? key}) : super(key: key);
//
//   @override
//   State<PayNowPage> createState() => _PayNowPageState();
// }
//
// class _PayNowPageState extends State<PayNowPage> {
//   bool isCompleteOrder = false;
//   String? orderId;
//   String? price;
//   Order? order;
//
//   // Order? orderInvoice;
//   double boxWidth = 130;
//   double boxHeight = 130;
//   int discountType = 0; // 0 Fixed - 1 Percent
//   final CommonController controller = Get.find<CommonController>();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController discountController = TextEditingController();
//   dynamic params;
//
//   @override
//   void initState() {
//     super.initState();
//     params = Get.arguments;
//     print("initialize param data::${params}");
//     print(params);
//     if (params != null) {
//       if (params.length > 2) {
//         isCompleteOrder = params[0];
//         orderId = params[1];
//         price = params[2];
//         if (params.length > 3) {
//           order = params[3];
//           print("daniyal");
//
//           // print(sorder!.orderMeta!.last.products!.title);
//         } else {
//           print("ahmed");
//
//           order = null;
//           // fetch order detail
//         }
//       } else {
//         params = null;
//         print("hassan");
//       }
//     }
//     amountController.text = double.parse("${order!.total.toString()}")
//         .toStringAsFixed(Config.fractionDigits);
//     calculateChange("${order!.total.toString()}", "${amountController.text}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (params == null) {
//       return SafeAreaHelper(
//         child: Center(
//           child: Text(
//             "Invalid Arguments",
//             style: TextStyle(color: BasicColors.getBlackWhiteColor()),
//           ),
//         ),
//       );
//     }
//     return SafeAreaHelper(
//       child: Obx(
//         () => WillPopScope(
//           onWillPop: () async => onPop(),
//           child: AbsorbPointer(
//             absorbing: (controller.isMakingPayment.value ||
//                 controller.isCompletingOrder.value ||
//                 controller.isApplyingDiscount.value),
//             child: Stack(
//               children: [
//                 Center(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 30),
//                       child: Column(
//                         children: [
//                           getCashPayScreen(),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "payVia".tr,
//                             style: TextStyle(
//                               fontSize: 16,
//                               letterSpacing: 2,
//                               fontWeight: FontWeight.bold,
//                               color: BasicColors.getBlackWhiteColor(),
//                               // color: BasicColors.blueGrey
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: () async {
//                                   controller.payWithBullsEye(
//                                       orderId: orderId,
//                                       completeOrder: isCompleteOrder ? 1 : 0);
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 5),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: BasicColors.primaryColor),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       SizedBox(
//                                         width: boxWidth,
//                                         height: boxHeight,
//                                         child: controller.isDarkTheme.value
//                                             ? Image.asset(
//                                                 "assets/pay_via_bullseye_white.png",
//                                                 fit: BoxFit.fill,
//                                               )
//                                             : Image.asset(
//                                                 "assets/pay_via_bullseye.png",
//                                                 fit: BoxFit.fill,
//                                               ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         "bullsEye".tr,
//                                         style: TextStyle(
//                                             color: BasicColors
//                                                 .getBlackWhiteColor()),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 40,
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   await payAtCountercard();
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 5),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: BasicColors.primaryColor),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       SizedBox(
//                                         width: boxWidth,
//                                         height: boxHeight,
//                                         child: Image.asset(
//                                           "assets/pay_via_card.png",
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         "card".tr,
//                                         style: TextStyle(
//                                             color: BasicColors
//                                                 .getBlackWhiteColor()),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 40,
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//
//                                   try {
//                                     var c = double.parse(widget.change);
//                                     if (c >= 0.0) {
//                                       print("huiso");
//                                       await payAtCounterrrr();
//                                     } else {
//                                       controller.showToast(
//                                           "collectCompletePayment".tr);
//                                     }
//                                   } catch (e) {
//                                     if (e is FormatException) {
//                                       widget.error = "${e.message}";
//                                     }
//                                   }
//                                   setState(() {});
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 5),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: BasicColors.primaryColor),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       SizedBox(
//                                         width: boxWidth,
//                                         height: boxHeight,
//                                         child: Image.asset(
//                                           "assets/pay_via_cash.png",
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         "cash".tr,
//                                         style: TextStyle(
//                                             color: BasicColors
//                                                 .getBlackWhiteColor()),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Obx(() => controller.isDiscountBtnClicked.value
//                     ? GestureDetector(
//                         onTap: () {
//                           controller.isDiscountBtnClicked.value = false;
//                         },
//                         child: Scaffold(
//                           backgroundColor: BasicColors.black.withOpacity(0.3),
//                           body: Container(
//                             height: MediaQuery.of(context).size.height / 1.1,
//                             child: Center(
//                               child: getDiscountScreen(),
//                             ),
//                           ),
//                         ),
//                       )
//                     : SizedBox()),
//                 (controller.isMakingPayment.value ||
//                         controller.isCompletingOrder.value ||
//                         controller.isApplyingDiscount.value)
//                     ? kLoadingWidget()
//                     : SizedBox.shrink()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   amountToPay() {
//     double value = double.parse("${order!.total.toString()}");
//     try {
//       double dis = double.parse("${order!.discount.toString()}");
//       // if (dis > 0.0) {
//       //   value = value - dis;
//       // }
//     } catch (e) {
//       log("HAHAHA ${e.toString()}");
//     }
//
//     return [
//       Text(
//         Config.currencySymbol + value.toStringAsFixed(Config.fractionDigits),
//         style: TextStyle(
//           fontSize: 50,
//           letterSpacing: 2,
//           fontWeight: FontWeight.bold,
//           color: BasicColors.getBlackWhiteColor(),
//           // color: BasicColors.blueGrey
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//       Text(
//         "totalAmountDue".tr.toUpperCase(),
//         style: TextStyle(
//           fontSize: 13,
//           letterSpacing: 2,
//           fontWeight: FontWeight.bold,
//           color: BasicColors.getBlackWhiteColor(),
//           // color: BasicColors.blueGrey
//         ),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//     ];
//   }
//
//   onPop() {
//     if (widget.isPayAsCashClicked) {
//       setState(() {
//         widget.isPayAsCashClicked = false;
//       });
//     } else {
//       Get.back();
//     }
//   }
//
//   void calculateChange(String price, String paidPrice) {
//     setState(() {
//       try {
//         widget.change = (double.parse(paidPrice) - double.parse(price))
//             .toStringAsFixed(Config.fractionDigits);
//         widget.error = null;
//       } catch (e) {
//         if (e is FormatException) {
//           if ("${e.message}" == "Invalid double") {
//             widget.error = "pleaseEnterAmount".tr;
//           }
//           widget.change =
//               double.parse(price).toStringAsFixed(Config.fractionDigits);
//         }
//       }
//     });
//   }
//
//   Future<void> payAtCounter() async {
//     var res = await controller.payAtCounter(
//         orderId: orderId,
//         completeOrder: isCompleteOrder ? 1 : 0,
//         change: widget.change,
//         cashPaid: amountController.text);
//     if (res != null) {
//       // print(orderInvoice!.orderMeta);
//       // if (res is bool) {
//       //   if (res) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4.0)),
//                 child: Stack(
//                   overflow: Overflow.visible,
//                   alignment: Alignment.topCenter,
//                   children: [
//                     Container(
//                       height: 250,
//                       width: 400,
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "paymentSuccess".tr,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: BasicColors.black),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "doYouWantToCompleteOrder".tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 20, color: BasicColors.black),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   width: 150,
//                                   decoration: BoxDecoration(
//                                     color: BasicColors.primaryColor,
//                                     borderRadius: BorderRadius.circular(
//                                         MediaQuery.of(context).size.width *
//                                             0.03),
//                                   ),
//                                   child: TextButton(
//                                     child: Text("no".tr,
//                                         style: TextStyle(
//                                             color: BasicColors.white)),
//                                     onPressed: () {
//                                       Get.back();
//                                       Get.offAllNamed(PageRoutes.splashPage);
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Container(
//                                   width: 150,
//                                   decoration: BoxDecoration(
//                                     color: BasicColors.primaryColor,
//                                     borderRadius: BorderRadius.circular(
//                                         MediaQuery.of(context).size.width *
//                                             0.03),
//                                   ),
//                                   child: TextButton(
//                                     child: Text("yes".tr,
//                                         style: TextStyle(
//                                             color: BasicColors.white)),
//                                     onPressed: () async {
//                                       Get.back();
//                                       await controller.completeOrder(
//                                           orderId: orderId as String,
//                                           gotoTables: true);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                         top: MediaQuery.of(context).size.width * -0.055,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.redAccent,
//                           radius: MediaQuery.of(context).size.width * 0.06,
//                           child: Icon(
//                             Icons.info_outline,
//                             color: Colors.white,
//                             size: MediaQuery.of(context).size.width * 0.06,
//                           ),
//                         )),
//                   ],
//                 ));
//           });
//       log("Payment Success");
//       return;
//       // }
//       // }
//     }
//
//     log("Payment Failed");
//   }
//   Future<void> payAtCounterrrr() async {
//     var res = await controller.payAtCounter(
//         orderId: orderId,
//         completeOrder: isCompleteOrder ? 1 : 0,
//         change: widget.change,
//         cashPaid: amountController.text);
//
//     print(res+"responsee");
//     print("paymettt"+res);
//     print( widget.change+"namees");
//     if(res==res){
//       Get.back();
//     }
//     if (res == null) {
//       print("paymettt");
//        Get.back();
//       // await controller.completeOrder(
//       //     orderId: orderId as String,
//       //     gotoTables: true);
//      // print(orderInvoice!.orderMeta);
//       //if (res is bool) {
//         //if (res) {
//       // showDialog(
//       //     context: context,
//       //     builder: (BuildContext context) {
//       //       return Dialog(
//       //           shape: RoundedRectangleBorder(
//       //               borderRadius: BorderRadius.circular(4.0)),
//       //           child: Stack(
//       //             overflow: Overflow.visible,
//       //             alignment: Alignment.topCenter,
//       //             children: [
//       //               Container(
//       //                 height: 250,
//       //                 width: 400,
//       //                 child: Padding(
//       //                   padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
//       //                   child: Column(
//       //                     children: [
//       //                       SizedBox(
//       //                         height: 10,
//       //                       ),
//       //                       Text(
//       //                         "paymentSuccess".tr,
//       //                         style: TextStyle(
//       //                             fontWeight: FontWeight.bold,
//       //                             fontSize: 20,
//       //                             color: BasicColors.black),
//       //                       ),
//       //                       SizedBox(height: 10),
//       //                       Text(
//       //                         "doYouWantToCompleteOrder".tr,
//       //                         textAlign: TextAlign.center,
//       //                         style: TextStyle(
//       //                             fontSize: 20, color: BasicColors.black),
//       //                       ),
//       //                       SizedBox(
//       //                         height: 30,
//       //                       ),
//       //                       Row(
//       //                         mainAxisAlignment: MainAxisAlignment.center,
//       //                         crossAxisAlignment: CrossAxisAlignment.end,
//       //                         children: [
//       //                           Container(
//       //                             width: 150,
//       //                             decoration: BoxDecoration(
//       //                               color: BasicColors.primaryColor,
//       //                               borderRadius: BorderRadius.circular(
//       //                                   MediaQuery.of(context).size.width *
//       //                                       0.03),
//       //                             ),
//       //                             child: TextButton(
//       //                               child: Text("no".tr,
//       //                                   style: TextStyle(
//       //                                       color: BasicColors.white)),
//       //                               onPressed: () {
//       //                                 Get.back();
//       //                                 Get.offAllNamed(PageRoutes.splashPage);
//       //                               },
//       //                             ),
//       //                           ),
//       //                           SizedBox(
//       //                             width: 20,
//       //                           ),
//       //                           Container(
//       //                             width: 150,
//       //                             decoration: BoxDecoration(
//       //                               color: BasicColors.primaryColor,
//       //                               borderRadius: BorderRadius.circular(
//       //                                   MediaQuery.of(context).size.width *
//       //                                       0.03),
//       //                             ),
//       //                             child: TextButton(
//       //                               child: Text("yes".tr,
//       //                                   style: TextStyle(
//       //                                       color: BasicColors.white)),
//       //                               onPressed: () async {
//       //                                 Get.back();
//       //                                 await controller.completeOrder(
//       //                                     orderId: orderId as String,
//       //                                     gotoTables: true);
//       //                               },
//       //                             ),
//       //                           ),
//       //                         ],
//       //                       ),
//       //                     ],
//       //                   ),
//       //                 ),
//       //               ),
//       //               Positioned(
//       //                   top: MediaQuery.of(context).size.width * -0.055,
//       //                   child: CircleAvatar(
//       //                     backgroundColor: Colors.redAccent,
//       //                     radius: MediaQuery.of(context).size.width * 0.06,
//       //                     child: Icon(
//       //                       Icons.info_outline,
//       //                       color: Colors.white,
//       //                       size: MediaQuery.of(context).size.width * 0.06,
//       //                     ),
//       //                   )),
//       //             ],
//       //           ));
//       //     });
//       log("Payment Success");
//       return;
//       // }
//       // }
//     }
//
//     log("Payment Failed");
//   }
//   Future<void> payAtCountercopy() async {
//     var res = await controller.payAtCounter(
//         orderId: orderId,
//         completeOrder: isCompleteOrder ? 1 : 0
//     );
//
//     if (res != null) {
//       if (res is bool) {
//         if (res) {
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return Dialog(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4.0)),
//                     child: Stack(
//                       overflow: Overflow.visible,
//                       alignment: Alignment.topCenter,
//                       children: [
//                         Container(
//                           height: 250,
//                           width: 400,
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text(
//                                   "paymentSuccess".tr,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                       color: BasicColors.black),
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   "doYouWantToCompleteOrder".tr,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 20, color: BasicColors.black),
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Container(
//                                       width: 150,
//                                       decoration: BoxDecoration(
//                                         color: BasicColors.primaryColor,
//                                         borderRadius: BorderRadius.circular(
//                                             MediaQuery.of(context).size.width *
//                                                 0.03),
//                                       ),
//                                       child: TextButton(
//                                         child: Text("no".tr,
//                                             style: TextStyle(
//                                                 color: BasicColors.white)),
//                                         onPressed: () {
//                                           Get.back();
//                                           Get.offAllNamed(
//                                               PageRoutes.tableSelectionPage);
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Container(
//                                       width: 150,
//                                       decoration: BoxDecoration(
//                                         color: BasicColors.primaryColor,
//                                         borderRadius: BorderRadius.circular(
//                                             MediaQuery.of(context).size.width *
//                                                 0.03),
//                                       ),
//                                       child: TextButton(
//                                         child: Text("yes".tr,
//                                             style: TextStyle(
//                                                 color: BasicColors.white)),
//                                         onPressed: () async {
//                                           Get.back();
//                                           await controller.completeOrder(
//                                               orderId: orderId as String,
//                                               gotoTables: true);
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                             top: MediaQuery.of(context).size.width * -0.055,
//                             child: CircleAvatar(
//                               backgroundColor: Colors.redAccent,
//                               radius: MediaQuery.of(context).size.width * 0.06,
//                               child: Icon(
//                                 Icons.info_outline,
//                                 color: Colors.white,
//                                 size: MediaQuery.of(context).size.width * 0.06,
//                               ),
//                             )),
//                       ],
//                     ));
//               });
//           log("Payment Success");
//           return;
//         }
//       }
//     }
//
//     log("Payment Failed");
//   }
//   Future<void> payAtCountercard() async {
//     var res = await controller.payAtCounter(
//         orderId: orderId,
//         completeOrder: isCompleteOrder ? 1 : 0,
//         change: widget.change,
//         cashPaid: amountController.text);
//
//     if (res != null) {
//       print(res+"ttuut");
//       // Get.back();
//       // await controller.completeOrder(
//       //     orderId: orderId as String,
//       //     gotoTables: true);
//       // print(orderInvoice!.orderMeta);
//       // if (res is bool) {
//       //   if (res) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4.0)),
//                 child: Stack(
//                   overflow: Overflow.visible,
//                   alignment: Alignment.topCenter,
//                   children: [
//                     Container(
//                       height: 250,
//                       width: 400,
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "paymentSuccess".tr,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: BasicColors.black),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "doYouWantToCompleteOrder".tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 20, color: BasicColors.black),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   width: 150,
//                                   decoration: BoxDecoration(
//                                     color: BasicColors.primaryColor,
//                                     borderRadius: BorderRadius.circular(
//                                         MediaQuery.of(context).size.width *
//                                             0.03),
//                                   ),
//                                   child: TextButton(
//                                     child: Text("no".tr,
//                                         style: TextStyle(
//                                             color: BasicColors.white)),
//                                     onPressed: () {
//                                       Get.back();
//                                       Get.offAllNamed(PageRoutes.splashPage);
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Container(
//                                   width: 150,
//                                   decoration: BoxDecoration(
//                                     color: BasicColors.primaryColor,
//                                     borderRadius: BorderRadius.circular(
//                                         MediaQuery.of(context).size.width *
//                                             0.03),
//                                   ),
//                                   child: TextButton(
//                                     child: Text("yes".tr,
//                                         style: TextStyle(
//                                             color: BasicColors.white)),
//                                     onPressed: () async {
//                                       Get.back();
//                                       await controller.completeOrder(
//                                           orderId: orderId as String,
//                                           gotoTables: true);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                         top: MediaQuery.of(context).size.width * -0.055,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.redAccent,
//                           radius: MediaQuery.of(context).size.width * 0.06,
//                           child: Icon(
//                             Icons.info_outline,
//                             color: Colors.white,
//                             size: MediaQuery.of(context).size.width * 0.06,
//                           ),
//                         )),
//                   ],
//                 ));
//           });
//       log("Payment Success");
//       return;
//       // }
//       // }
//     }
//
//     log("Payment Failed");
//   }
//
//   int getNearestTenthValue(int value) {
//     int remainder = value % 10;
//     return value + (10 - remainder);
//   }
//
//   getCashPayScreen() {
//     double priceDouble = double.parse("${order!.total.toString()}");
//     int nearestRoundOf = int.parse(priceDouble.toStringAsFixed(0));
//     if (priceDouble > nearestRoundOf.toDouble()) {
//       ++nearestRoundOf;
//     }
//
//     int nearestTenthValue = getNearestTenthValue(nearestRoundOf);
//
//     List<KeyboardKey> keyboardKeys = [
//       KeyboardKey("1", KeyboardKeyType.insert, "1"),
//       KeyboardKey("2", KeyboardKeyType.insert, "2"),
//       KeyboardKey("3", KeyboardKeyType.insert, "3"),
//       KeyboardKey("${Config.currencySymbol}$nearestRoundOf",
//           KeyboardKeyType.update, "$nearestRoundOf"),
//       KeyboardKey("4", KeyboardKeyType.insert, "4"),
//       KeyboardKey("5", KeyboardKeyType.insert, "5"),
//       KeyboardKey("6", KeyboardKeyType.insert, "6"),
//       KeyboardKey("${Config.currencySymbol}$nearestTenthValue",
//           KeyboardKeyType.update, "$nearestTenthValue"),
//       KeyboardKey("7", KeyboardKeyType.insert, "7"),
//       KeyboardKey("8", KeyboardKeyType.insert, "8"),
//       KeyboardKey("9", KeyboardKeyType.insert, "9"),
//       KeyboardKey("${Config.currencySymbol}${nearestTenthValue + 10}",
//           KeyboardKeyType.update, "${nearestTenthValue + 10}"),
//       KeyboardKey("C", KeyboardKeyType.clear, ""),
//       KeyboardKey("0", KeyboardKeyType.insert, "0"),
//       KeyboardKey(".", KeyboardKeyType.insert, "."),
//       KeyboardKey("x", KeyboardKeyType.remove, ""),
//     ];
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Column(
//                   children: amountToPay(),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   "cashReceived".tr,
//                   style: TextStyle(
//                     fontSize: 13,
//                     letterSpacing: 2,
//                     fontWeight: FontWeight.bold,
//                     color: BasicColors.getBlackWhiteColor(),
//                     // color: BasicColors.blueGrey
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: EntryField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   hint: "0.0",
//                   readOnly: true,
//                   errorText: widget.error,
//                   onChanged: (value) {
//                     if (value.length > 0) {
//                       calculateChange(
//                           "${order!.total.toString()}", amountController.text);
//                     } else {
//                       setState(() {
//                         widget.error = "pleaseEnterSomethingFirst".tr;
//                       });
//                     }
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "subTotal".tr,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 letterSpacing: 2,
//                                 fontWeight: FontWeight.bold,
//                                 color: BasicColors.getBlackWhiteColor(),
//                                 // color: BasicColors.blueGrey
//                               ),
//                             ),
//                           ),
//                           Text(
//                             double.parse("${order?.subtotal}")
//                                 .toStringAsFixed(Config.fractionDigits),
//                             style: TextStyle(
//                               fontSize: 13,
//                               letterSpacing: 2,
//                               fontWeight: FontWeight.bold,
//                               color: BasicColors.getBlackWhiteColor(),
//                               // color: BasicColors.blueGrey
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 20),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "discount".tr,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 letterSpacing: 2,
//                                 fontWeight: FontWeight.bold,
//                                 color: BasicColors.getBlackWhiteColor(),
//                                 // color: BasicColors.blueGrey
//                               ),
//                             ),
//                           ),
//                           Text(
//                             double.parse("${order?.discount}")
//                                 .toStringAsFixed(Config.fractionDigits),
//                             style: TextStyle(
//                               fontSize: 13,
//                               letterSpacing: 2,
//                               fontWeight: FontWeight.bold,
//                               color: BasicColors.getBlackWhiteColor(),
//                               // color: BasicColors.blueGrey
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "tax".tr,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 letterSpacing: 2,
//                                 fontWeight: FontWeight.bold,
//                                 color: BasicColors.getBlackWhiteColor(),
//                                 // color: BasicColors.blueGrey
//                               ),
//                             ),
//                           ),
//                           Text(
//                             double.parse("${order?.tax}")
//                                 .toStringAsFixed(Config.fractionDigits),
//                             style: TextStyle(
//                               fontSize: 13,
//                               letterSpacing: 2,
//                               fontWeight: FontWeight.bold,
//                               color: BasicColors.getBlackWhiteColor(),
//                               // color: BasicColors.blueGrey
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 20),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "change".tr,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 letterSpacing: 2,
//                                 fontWeight: FontWeight.bold,
//                                 color: BasicColors.getBlackWhiteColor(),
//                                 // color: BasicColors.blueGrey
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "${widget.change}",
//                             style: TextStyle(
//                               fontSize: 13,
//                               letterSpacing: 2,
//                               fontWeight: FontWeight.bold,
//                               color: BasicColors.getBlackWhiteColor(),
//                               // color: BasicColors.blueGrey
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 200,
//                     child: GestureDetector(
//                       onTap: () {
//                         controller.isDiscountBtnClicked.value = true;
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             color: BasicColors.transparentColor,
//                             border: Border.all(
//                               color: BasicColors.getBlackWhiteColor(),
//                               // color: BasicColors.secondaryColor as Color
//                             )),
//                         padding:
//                             EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//                         margin:
//                             EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "discount".tr.toUpperCase(),
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 letterSpacing: 1,
//                                 fontWeight: FontWeight.bold,
//                                 color: BasicColors.getBlackWhiteColor(),
//                                 // color: BasicColors.secondaryColor as Color
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Container(
//                   //   width: 200,
//                   //   child: CustomButton(
//                   //     onTap: () async {
//                   //       try {
//                   //         var c = double.parse(widget.change);
//                   //         if (c >= 0.0) {
//                   //           await payAtCounter();
//                   //         } else {
//                   //           controller.showToast("collectCompletePayment".tr);
//                   //         }
//                   //       } catch (e) {
//                   //         if (e is FormatException) {
//                   //           widget.error = "${e.message}";
//                   //         }
//                   //       }
//                   //       setState(() {});
//                   //     },
//                   //     padding:
//                   //         EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//                   //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                   //     title: Text(
//                   //       "submit".tr.toUpperCase(),
//                   //       style: TextStyle(
//                   //           fontSize: 18,
//                   //           letterSpacing: 1,
//                   //           fontWeight: FontWeight.bold,
//                   //           color: BasicColors.white),
//                   //     ),
//                   //     bgColor: BasicColors.primaryColor,
//                   //   ),
//                   // )
//                 ],
//               )
//             ],
//           ),
//         ),
//         Expanded(
//           child: Container(
//             height: MediaQuery.of(context).size.height / 1.35,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: getKeyBoardGridView(keyboardKeys, amountController),
//           ),
//         ),
//       ],
//     );
//   }
//
//   getKeyBoardGridView(
//       List<KeyboardKey> keyboardKeys, TextEditingController textController,
//       {bool isDiscount = false}) {
//     double itemWidthHeight = (Get.width / 2.7) / 4;
//
//     log("Item Widht and Height: ${itemWidthHeight.toString()}");
//
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.49,
//       child: GridView.builder(
//         physics: AlwaysScrollableScrollPhysics(),
//         // physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           childAspectRatio: 1 / 1,
//           crossAxisCount: 4,
//           crossAxisSpacing: 1.5,
//           mainAxisSpacing: 1.5,
//         ),
//         shrinkWrap: true,
//         itemCount: keyboardKeys.length,
//         itemBuilder: (BuildContext ctx, index) {
//           KeyboardKey keyboardKey = keyboardKeys[index];
//           return InkWell(
//             onTap: () async {
//               if (keyboardKey.type == KeyboardKeyType.clear) {
//                 textController.clear();
//               } else if (keyboardKey.type == KeyboardKeyType.update) {
//                 textController.text = keyboardKey.valueToAdd;
//               } else if (keyboardKey.type == KeyboardKeyType.remove) {
//                 if (textController.text.length > 0) {
//                   textController.text = textController.text
//                       .substring(0, textController.text.length - 1);
//                 }
//               } else if (keyboardKey.type == KeyboardKeyType.insert) {
//                 textController.text =
//                     textController.text + keyboardKey.valueToAdd;
//               } else if (keyboardKey.type == KeyboardKeyType.fixed) {
//                 discountType = 0;
//               } else if (keyboardKey.type == KeyboardKeyType.percent) {
//                 discountType = 1;
//               } else if (keyboardKey.type == KeyboardKeyType.done) {
//                 var res = await controller.applyDiscount(
//                     value: discountController.text.isEmpty?"0":discountController.text,
//                     type: discountType == 0 ? "fixed" : "percent",
//                     orderId: '$orderId');
//
//                 if (res != null) {
//                   if (res is Order) {
//                     setState(() {
//                       order = res;
//                     });
//                     // discountController.clear();
//                     controller.showToast("Discount Applied");
//                   }
//                   controller.isApplyingDiscount.value = false;
//                   controller.isDiscountBtnClicked.value = false;
//                   amountController.text =
//                       double.parse("${order!.total.toString()}")
//                           .toStringAsFixed(Config.fractionDigits);
//                 }
//               }
//
//               if (isDiscount) {
//                 setState(() {});
//               } else {
//                 setState(() {
//                   calculateChange(
//                       "${order!.total.toString()}", textController.text);
//                 });
//               }
//             },
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: itemWidthHeight,
//                     height: itemWidthHeight,
//                     alignment: Alignment.center,
//                     child: (keyboardKey.type == KeyboardKeyType.done)
//                         ? Icon(
//                             Icons.done,
//                             color: BasicColors.primaryColor,
//                             size: 35,
//                           )
//                         : (keyboardKey.type == KeyboardKeyType.remove)
//                             ? Icon(
//                                 Icons.backspace_outlined,
//                                 color: BasicColors.black,
//                               )
//                             : Text(
//                                 keyboardKey.value,
//                                 style: TextStyle(
//                                     fontSize: 22,
//                                     color: (keyboardKey.type ==
//                                                 KeyboardKeyType.fixed &&
//                                             discountType == 0)
//                                         ? BasicColors.white
//                                         : (keyboardKey.type ==
//                                                     KeyboardKeyType.percent &&
//                                                 discountType == 1)
//                                             ? BasicColors.white
//                                             : (keyboardKey.type ==
//                                                     KeyboardKeyType.update)
//                                                 ? BasicColors.white
//                                                 : BasicColors.black),
//                               ),
//                     decoration: BoxDecoration(
//                       color: (keyboardKey.type == KeyboardKeyType.fixed &&
//                               discountType == 0)
//                           ? BasicColors.primaryColor
//                           : (keyboardKey.type == KeyboardKeyType.percent &&
//                                   discountType == 1)
//                               ? BasicColors.primaryColor
//                               : (keyboardKey.type == KeyboardKeyType.update)
//                                   ? BasicColors.primaryColor
//                                   : Colors.grey[200],
//                       // borderRadius: BorderRadius.circular(itemWidthHeight / 4),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   getDiscountScreen() {
//     List<KeyboardKey> discountKeyboardKeys = [
//       KeyboardKey("1", KeyboardKeyType.insert, "1"),
//       KeyboardKey("2", KeyboardKeyType.insert, "2"),
//       KeyboardKey("3", KeyboardKeyType.insert, "3"),
//       KeyboardKey("Fixed", KeyboardKeyType.fixed, ""),
//       KeyboardKey("4", KeyboardKeyType.insert, "4"),
//       KeyboardKey("5", KeyboardKeyType.insert, "5"),
//       KeyboardKey("6", KeyboardKeyType.insert, "6"),
//       KeyboardKey("Percent", KeyboardKeyType.percent, ""),
//       KeyboardKey("7", KeyboardKeyType.insert, "7"),
//       KeyboardKey("8", KeyboardKeyType.insert, "8"),
//       KeyboardKey("9", KeyboardKeyType.insert, "9"),
//       KeyboardKey("x", KeyboardKeyType.remove, ""),
//       KeyboardKey("C", KeyboardKeyType.clear, ""),
//       KeyboardKey("0", KeyboardKeyType.insert, "0"),
//       KeyboardKey(".", KeyboardKeyType.insert, "."),
//       KeyboardKey("", KeyboardKeyType.done, ""),
//     ];
//
//     return Container(
//       width: Get.width / 2.4,
//       padding: EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         color: BasicColors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             color: BasicColors.white,
//             margin: EdgeInsets.symmetric(horizontal: 4),
//             child: EntryField(
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(color: BasicColors.primaryColor),
//               ),
//               controller: discountController,
//               keyboardType: TextInputType.number,
//               hint: "0.0",
//               readOnly: true,
//               onChanged: (value) {
//                 // if (value.length > 0) {
//                 //   calculateChange("$price", discountController.text);
//                 // } else {
//                 //   setState(() {
//                 //     widget.error = "pleaseEnterSomethingFirst".tr;
//                 //   });
//                 // }
//               },
//               backgroundColorGet: controller.isDarkTheme.value ? true : false,
//             ),
//           ),
//           getKeyBoardGridView(discountKeyboardKeys, discountController,
//               isDiscount: true),
//         ],
//       ),
//     );
//   }
// }
//
// enum KeyboardKeyType { insert, remove, clear, update, done, fixed, percent }
//
// class KeyboardKey {
//   String value;
//   KeyboardKeyType type;
//   String valueToAdd;
//
//   KeyboardKey(this.value, this.type, this.valueToAdd);
// }
//
// class AlwaysDisabledFocusNode extends FocusNode {
//   @override
//   bool get hasFocus => false;
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';
import 'package:hungerz_ordering/helper/colors.dart';
import 'package:hungerz_ordering/helper/config.dart';
import 'package:hungerz_ordering/helper/routes.dart';
import 'package:hungerz_ordering/helper/strings.dart';
import 'package:hungerz_ordering/model/Sorder.dart';
import 'package:hungerz_ordering/model/order.dart';
import 'package:hungerz_ordering/widgets/custom_circular_button.dart';
import 'package:hungerz_ordering/widgets/entry_field.dart';
import 'package:hungerz_ordering/widgets/safe_area_helper.dart';

class PayNowPage extends StatefulWidget {
  bool isPayAsCashClicked = false;
  String change = "0.0";
  String? error;

  PayNowPage({Key? key}) : super(key: key);

  @override
  State<PayNowPage> createState() => _PayNowPageState();
}

class _PayNowPageState extends State<PayNowPage> {
  bool isCompleteOrder = false;
  String? orderId;
  String? price;
  Order? order;

  // Order? orderInvoice;
  double boxWidth = 130.w;
  double boxHeight = 130.h;
  int discountType = 0; // 0 Fixed - 1 Percent
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  dynamic params;

  @override
  void initState() {
    super.initState();
    params = Get.arguments;
    print("initialize param data::${params}");
    print(params);
    if (params != null) {
      if (params.length > 2) {
        isCompleteOrder = params[0];
        orderId = params[1];
        price = params[2];
        if (params.length > 3) {
          order = params[3];
          print("daniyal");

          // print(sorder!.orderMeta!.last.products!.title);
        } else {
          print("ahmed");

          order = null;
          // fetch order detail
        }
      } else {
        params = null;
        print("hassan");
      }
    }
    amountController.text = double.parse("${order!.total.toString()}")
        .toStringAsFixed(Config.fractionDigits);
    calculateChange("${order!.total.toString()}", "${amountController.text}");
  }

  @override
  Widget build(BuildContext context) {
    if (params == null) {
      return SafeAreaHelper(
        child: Center(
          child: Text(
            "Invalid Arguments",
            style: TextStyle(color: BasicColors.getBlackWhiteColor()),
          ),
        ),
      );
    }
    return SafeAreaHelper(
      child: Obx(
            () => WillPopScope(
          onWillPop: () async => onPop(),
          child: AbsorbPointer(
            absorbing: (controller.isMakingPayment.value ||
                controller.isCompletingOrder.value ||
                controller.isApplyingDiscount.value),
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          getCashPayScreen(),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "payVia".tr,
                            style: TextStyle(
                              fontSize: 18.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: BasicColors.getBlackWhiteColor(),
                              // color: BasicColors.blueGrey
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  controller.payWithBullsEye(
                                      orderId: orderId,
                                      completeOrder: isCompleteOrder ? 1 : 0);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: BasicColors.primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.14,
                                        height:  MediaQuery.of(context).size.height*0.06,
                                        child: controller.isDarkTheme.value
                                            ? Image.asset(
                                          "assets/pay_via_bullseye_white.png",
                                          fit: BoxFit.fill,
                                        )
                                            : Image.asset(
                                          "assets/pay_via_bullseye.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "bullsEye".tr,
                                        style: TextStyle(
                                            color: BasicColors
                                                .getBlackWhiteColor(),fontSize: 18.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var type="Card";

                                  await payAtCounter(type);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: BasicColors.primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.17,
                                        height: MediaQuery.of(context).size.height*0.09,
                                        child: Image.asset(
                                          "assets/pay_via_card.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "card".tr,
                                        style: TextStyle(
                                            color: BasicColors
                                                .getBlackWhiteColor(),fontSize: 18.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    var c = double.parse(widget.change);
                                    if (c >= 0.0) {
                                      print("cashcounterrrrr");
                                      var type="Cash";
                                      await payAtCounter(type);

                                    } else {
                                      controller.showToast(
                                          "collectCompletePayment".tr);
                                    }
                                  } catch (e) {
                                    if (e is FormatException) {
                                      widget.error = "${e.message}";
                                    }
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: BasicColors.primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.17,
                                        height: MediaQuery.of(context).size.height*0.09,
                                        child: Image.asset(
                                          "assets/pay_via_cash.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "cash".tr,
                                        style: TextStyle(
                                            color: BasicColors
                                                .getBlackWhiteColor(),fontSize: 18.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() => controller.isDiscountBtnClicked.value
                    ? GestureDetector(
                  onTap: () {
                    controller.isDiscountBtnClicked.value = false;
                  },
                  child: Scaffold(
                    backgroundColor: BasicColors.black.withOpacity(0.3),
                    body: Container(
                      height: MediaQuery.of(context).size.height / 1.5.h,
                      // width: MediaQuery.of(context).size.width / 1.h,
                      child: Center(
                        child: getDiscountScreen(),
                      ),
                    ),
                  ),
                )
                    : SizedBox()),
                (controller.isMakingPayment.value ||
                    controller.isCompletingOrder.value ||
                    controller.isApplyingDiscount.value)
                    ? kLoadingWidget()
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  amountToPay() {
    double value = double.parse("${order!.total.toString()}");
    try {
      double dis = double.parse("${order!.discount.toString()}");
      // if (dis > 0.0) {
      //   value = value - dis;
      // }
    } catch (e) {
      log("HAHAHA        ${e.toString()}");
    }

    return [
      Text(
        Config.currencySymbol + value.toStringAsFixed(Config.fractionDigits),
        style: TextStyle(
          fontSize: 30.sp,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: BasicColors.getBlackWhiteColor(),
          // color: BasicColors.blueGrey
        ),
      ),
      SizedBox(
        height: 10.h,
      ),
      Text(
        "totalAmountDue".tr.toUpperCase(),
        style: TextStyle(
          fontSize: 13.sp,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: BasicColors.getBlackWhiteColor(),
          // color: BasicColors.blueGrey
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
    ];
  }

  onPop() {
    if (widget.isPayAsCashClicked) {
      setState(() {
        widget.isPayAsCashClicked = false;
      });
    } else {
      Get.back();
    }
  }

  void calculateChange(String price, String paidPrice) {
    setState(() {
      try {
        widget.change = (double.parse(paidPrice) - double.parse(price))
            .toStringAsFixed(Config.fractionDigits);
        widget.error = null;
      } catch (e) {
        if (e is FormatException) {
          if ("${e.message}" == "Invalid double") {
            widget.error = "pleaseEnterAmount".tr;
          }
          widget.change =
              double.parse(price).toStringAsFixed(Config.fractionDigits);
        }
      }
    });
  }

  Future<void> payAtCounter(String type) async {
    var res;
    print("cashcounterrrrr at payAtCounter");
    try {
       res = await controller.payAtCounter(
          orderId: orderId,
          completeOrder: isCompleteOrder ? 1 : 0,
          change: widget.change,
          cashPaid: amountController.text,
           type:type

       );


    }
    catch(va){
      print("cashcounterrrrr error");
      print(va);
    }
    if (res != null) {
      // print(orderInvoice!.orderMeta);
      // if (res is bool) {
      //   if (res) {
      // Fluttertoast.showToast(
      //   msg: widget.change+"change"
      // );
      print(widget.change+"change");
      if(controller.type=="take_away"){
        await controller.completeOrder(
            orderId: orderId as String,
            gotoTables: true
        );
      }else{
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
                        height: MediaQuery.of(context).size.height* 0.5.h,
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
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.03.w),
                                    ),
                                    child: TextButton(
                                      child: Text("no".tr,
                                          style: TextStyle(
                                              color: BasicColors.white,fontSize: 18.sp)),
                                      onPressed: () {
                                        Get.back();
                                        Get.offAllNamed(PageRoutes.splashPage);
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
                                        await controller.completeOrder(
                                            orderId: orderId as String,
                                            gotoTables: true
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.02.w,
                                  ),
                                  ///Yesprint
                                  // Container(
                                  //   // width: MediaQuery
                                  //   //     .of(context)
                                  //   //     .size
                                  //   //     .width * 0.2.w,
                                  //   // height: MediaQuery
                                  //   //     .of(context)
                                  //   //     .size
                                  //   //     .height * 0.13.h,
                                  //   width: MediaQuery.of(context).size.width * 0.19.w,
                                  //   height: MediaQuery.of(context).size.height * 0.099.h,
                                  //   decoration: BoxDecoration(
                                  //     color: BasicColors.primaryColor,
                                  //     borderRadius: BorderRadius.circular(
                                  //         MediaQuery.of(context).size.width * 0.03.w),
                                  //   ),
                                  //   child: TextButton(
                                  //     child: Text("Yes and\nprint".tr,
                                  //         style: TextStyle(
                                  //             color: BasicColors.white,fontSize: 22.sp)),
                                  //     onPressed: () async {
                                  //       Get.back();
                                  //      await controller.payAtCounter(
                                  //           orderId: orderId,
                                  //           completeOrder: isCompleteOrder ? 1 : 0,
                                  //           change: widget.change,
                                  //           cashPaid: amountController.text,
                                  //           type:type,
                                  //       );
                                  //       await controller.completeOrder(
                                  //           orderId: orderId as String,
                                  //           gotoTables: true
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 10.h,),
                              Container(
                                // width: MediaQuery
                                //     .of(context)
                                //     .size
                                //     .width * 0.2.w,
                                // height: MediaQuery
                                //     .of(context)
                                //     .size
                                //     .height * 0.13.h,
                                width: MediaQuery.of(context).size.width * 0.5.w,
                                height: MediaQuery.of(context).size.height * 0.06.h,
                                decoration: BoxDecoration(
                                  color: BasicColors.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.03.w),
                                ),
                                child: TextButton(
                                  child: Text("Yes and print".tr,
                                      style: TextStyle(
                                          color: BasicColors.white,fontSize: 18.sp)),
                                  onPressed: () async {
                                    Get.back();
                                    await controller.payAtCounter(
                                      orderId: orderId,
                                      completeOrder: isCompleteOrder ? 1 : 0,
                                      change: widget.change,
                                      cashPaid: amountController.text,
                                      type:type,
                                    );
                                    await controller.completeOrder(
                                        orderId: orderId as String,
                                        gotoTables: true
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.03,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * -0.1.w,
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
      }

      log("Payment Success");
      return;
      // }
      // }
    }

    Fluttertoast.showToast(
        msg: "Payment Failed"
    );
    log("Payment Failed");
  }

  double getNearestTenthValue(double value) {
    double remainder = value % 10;
    return value + (10 - remainder);
  }

  getCashPayScreen() {
    double priceDouble = double.parse("${order!.total.toString()}");
    double nearestRoundOf = double.parse(priceDouble.toStringAsFixed(0));
    if (priceDouble > nearestRoundOf.toDouble()) {
      ++nearestRoundOf;
    }

    double nearestTenthValue = getNearestTenthValue(nearestRoundOf);

    List<KeyboardKey> keyboardKeys = [
      KeyboardKey("1", KeyboardKeyType.insert, "1"),
      KeyboardKey("2", KeyboardKeyType.insert, "2"),
      KeyboardKey("3", KeyboardKeyType.insert, "3"),
      KeyboardKey("${Config.currencySymbol}$nearestRoundOf",
          KeyboardKeyType.update, "$nearestRoundOf"),
      KeyboardKey("4", KeyboardKeyType.insert, "4"),
      KeyboardKey("5", KeyboardKeyType.insert, "5"),
      KeyboardKey("6", KeyboardKeyType.insert, "6"),
      KeyboardKey("${Config.currencySymbol}$nearestTenthValue",
          KeyboardKeyType.update, "$nearestTenthValue"),
      KeyboardKey("7", KeyboardKeyType.insert, "7"),
      KeyboardKey("8", KeyboardKeyType.insert, "8"),
      KeyboardKey("9", KeyboardKeyType.insert, "9"),
      KeyboardKey("${Config.currencySymbol}${nearestTenthValue + 10}",
          KeyboardKeyType.update, "${nearestTenthValue + 10}"),
      KeyboardKey("C", KeyboardKeyType.clear, ""),
      KeyboardKey("0", KeyboardKeyType.insert, "0"),
      KeyboardKey(".", KeyboardKeyType.insert, "."),
      KeyboardKey("x", KeyboardKeyType.remove, ""),
    ];
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: amountToPay(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "cashReceived".tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: BasicColors.getBlackWhiteColor(),
                    // color: BasicColors.blueGrey
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: EntryField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  hint: "0.0",

                  readOnly: true,
                  errorText: widget.error,
                  onChanged: (value) {
                    if (value.length > 0) {
                      calculateChange(
                          "${order!.total.toString()}", amountController.text);
                    } else {
                      setState(() {
                        widget.error = "pleaseEnterSomethingFirst".tr;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "subTotal".tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                letterSpacing: 1.sp,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            double.parse("${order?.subtotal}")
                                .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(
                              fontSize: 18.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: BasicColors.getBlackWhiteColor(),
                              // color: BasicColors.blueGrey
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "discount".tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                letterSpacing: 1.sp,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            double.parse("${order?.discount}")
                                .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(
                              fontSize: 18.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: BasicColors.getBlackWhiteColor(),
                              // color: BasicColors.blueGrey
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "tax".tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                letterSpacing: 1.sp,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            double.parse("${order?.tax}")
                                .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(
                              fontSize: 18.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: BasicColors.getBlackWhiteColor(),
                              // color: BasicColors.blueGrey
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "change".tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                letterSpacing: 1.sp,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            "${widget.change}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: BasicColors.getBlackWhiteColor(),
                              // color: BasicColors.blueGrey
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250.w,
                    child: GestureDetector(
                      onTap: () {
                        controller.isDiscountBtnClicked.value = true;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.sp),
                            color: BasicColors.transparentColor,
                            border: Border.all(
                              color: BasicColors.getBlackWhiteColor(),
                              // color: BasicColors.secondaryColor as Color
                            )),
                        padding:
                        EdgeInsets.symmetric(vertical: 8.sp, horizontal: 14.sp),
                        margin:
                        EdgeInsets.symmetric(vertical: 9.sp, horizontal: 5.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "discount".tr.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.secondaryColor as Color
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   width: 200,
                  //   child: CustomButton(
                  //     onTap: () async {
                  //       try {
                  //         var c = double.parse(widget.change);
                  //         if (c >= 0.0) {
                  //           await payAtCounter();
                  //         } else {
                  //           controller.showToast("collectCompletePayment".tr);
                  //         }
                  //       } catch (e) {
                  //         if (e is FormatException) {
                  //           widget.error = "${e.message}";
                  //         }
                  //       }
                  //       setState(() {});
                  //     },
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  //     title: Text(
                  //       "submit".tr.toUpperCase(),
                  //       style: TextStyle(
                  //           fontSize: 18,
                  //           letterSpacing: 1,
                  //           fontWeight: FontWeight.bold,
                  //           color: BasicColors.white),
                  //     ),
                  //     bgColor: BasicColors.primaryColor,
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ),

        ///TOdo this is calculater

        // Expanded(
        //   child: Container(
        //     height: MediaQuery.of(context).size.height / 2.8.h,
        //     // width: MediaQuery.of(context).size.width /3.5.w,
        //     // color:Colors.yellow,
        //
        //     padding: const EdgeInsets.symmetric(horizontal:60),
        //     child: getKeyBoardGridView2(keyboardKeys, amountController),
        //   ),
        // ),

        ///TOdo this is calculater end
      ],
    );
  }

  getKeyBoardGridView(
      List<KeyboardKey> keyboardKeys, TextEditingController textController,
      {bool isDiscount = false}) {
    double itemWidthHeight =  (Get.width / 2.4) / 4.5;

    // (Get.width / 3.5) / 4;

    log("Item Widht and Height: ${itemWidthHeight.toString()}");

    return Container(
        // color:Colors.red,
      // height: MediaQuery.of(context).size.height /2.8.h,
      // width: MediaQuery.of(context).size.width /4.5.h,
      child:

      // MediaQuery.of(context).size.width < 1200?
      GridView.builder(
        // physics: AlwaysScrollableScrollPhysics(),
        physics: NeverScrollableScrollPhysics(),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1/0.8,
          crossAxisCount: 4,
          crossAxisSpacing: 22,
          mainAxisSpacing: 2,

        ),

        shrinkWrap: true,
        itemCount: keyboardKeys.length,
        itemBuilder: (BuildContext ctx, index) {
          KeyboardKey keyboardKey = keyboardKeys[index];
          return InkWell(
            onTap: () async {
              if (keyboardKey.type == KeyboardKeyType.clear) {
                textController.clear();
              } else if (keyboardKey.type == KeyboardKeyType.update) {
                textController.text = keyboardKey.valueToAdd;
              } else if (keyboardKey.type == KeyboardKeyType.remove) {
                if (textController.text.length > 0) {
                  textController.text = textController.text
                      .substring(0, textController.text.length - 1);
                }
              } else if (keyboardKey.type == KeyboardKeyType.insert) {
                textController.text =
                    textController.text + keyboardKey.valueToAdd;
              } else if (keyboardKey.type == KeyboardKeyType.fixed) {
                discountType = 0;
              } else if (keyboardKey.type == KeyboardKeyType.percent) {
                discountType = 1;
              } else if (keyboardKey.type == KeyboardKeyType.done) {
                var res = await controller.applyDiscount(
                    value: discountController.text,
                    type: discountType == 0 ? "fixed" : "percent",
                    orderId: '$orderId');

                if (res != null) {
                  if (res is Order) {
                    setState(() {
                      order = res;
                    });
                    // discountController.clear();
                    controller.showToast("Discount Applied");
                  }
                  controller.isApplyingDiscount.value = false;
                  controller.isDiscountBtnClicked.value = false;
                  amountController.text =
                      double.parse("${order!.total.toString()}")
                          .toStringAsFixed(Config.fractionDigits);
                }
              }

              if (isDiscount) {
                setState(() {});
              } else {
                setState(() {
                  calculateChange(
                      "${order!.total.toString()}", textController.text);
                });
              }
            },
            child: Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: itemWidthHeight,
                    height: itemWidthHeight,
                    alignment: Alignment.center,
                    child: (keyboardKey.type == KeyboardKeyType.done)
                        ? Icon(
                      Icons.done,
                      color: BasicColors.primaryColor,
                      size: 32.sp,
                    )
                        : (keyboardKey.type == KeyboardKeyType.remove)
                        ? Icon(
                      Icons.backspace_outlined,
                      color: BasicColors.black,
                    )
                        : Text(
                      keyboardKey.value,
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: (keyboardKey.type ==
                              KeyboardKeyType.fixed &&
                              discountType == 0)
                              ? BasicColors.white
                              : (keyboardKey.type ==
                              KeyboardKeyType.percent &&
                              discountType == 1)
                              ? BasicColors.white
                              : (keyboardKey.type ==
                              KeyboardKeyType.update)
                              ? BasicColors.white
                              : BasicColors.black),
                    ),
                    decoration: BoxDecoration(
                      color: (keyboardKey.type == KeyboardKeyType.fixed &&
                          discountType == 0)
                          ? BasicColors.primaryColor
                          : (keyboardKey.type == KeyboardKeyType.percent &&
                          discountType == 1)
                          ? BasicColors.primaryColor
                          : (keyboardKey.type == KeyboardKeyType.update)
                          ? BasicColors.primaryColor
                          : Colors.grey[200],
                      // borderRadius: BorderRadius.circular(itemWidthHeight / 4),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )
      //     : GridView.builder(
      //   // physics: AlwaysScrollableScrollPhysics(),
      //   physics: NeverScrollableScrollPhysics(),
      //
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     childAspectRatio: 1/1,
      //     crossAxisCount: 4,
      //     crossAxisSpacing: 48.5,
      //     mainAxisSpacing: 2,
      //
      //   ),
      //   shrinkWrap: true,
      //   itemCount: keyboardKeys.length,
      //   itemBuilder: (BuildContext ctx, index) {
      //     KeyboardKey keyboardKey = keyboardKeys[index];
      //     return InkWell(
      //       onTap: () async {
      //         if (keyboardKey.type == KeyboardKeyType.clear) {
      //           textController.clear();
      //         } else if (keyboardKey.type == KeyboardKeyType.update) {
      //           textController.text = keyboardKey.valueToAdd;
      //         } else if (keyboardKey.type == KeyboardKeyType.remove) {
      //           if (textController.text.length > 0) {
      //             textController.text = textController.text
      //                 .substring(0, textController.text.length - 1);
      //           }
      //         } else if (keyboardKey.type == KeyboardKeyType.insert) {
      //           textController.text =
      //               textController.text + keyboardKey.valueToAdd;
      //         } else if (keyboardKey.type == KeyboardKeyType.fixed) {
      //           discountType = 0;
      //         } else if (keyboardKey.type == KeyboardKeyType.percent) {
      //           discountType = 1;
      //         } else if (keyboardKey.type == KeyboardKeyType.done) {
      //           var res = await controller.applyDiscount(
      //               value: discountController.text,
      //               type: discountType == 0 ? "fixed" : "percent",
      //               orderId: '$orderId');
      //
      //           if (res != null) {
      //             if (res is Order) {
      //               setState(() {
      //                 order = res;
      //               });
      //               // discountController.clear();
      //               controller.showToast("Discount Applied");
      //             }
      //             controller.isApplyingDiscount.value = false;
      //             controller.isDiscountBtnClicked.value = false;
      //             amountController.text =
      //                 double.parse("${order!.total.toString()}")
      //                     .toStringAsFixed(Config.fractionDigits);
      //           }
      //         }
      //
      //         if (isDiscount) {
      //           setState(() {});
      //         } else {
      //           setState(() {
      //             calculateChange(
      //                 "${order!.total.toString()}", textController.text);
      //           });
      //         }
      //       },
      //       child: Container(
      //
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Container(
      //               width: itemWidthHeight,
      //               height: itemWidthHeight,
      //               alignment: Alignment.center,
      //               child: (keyboardKey.type == KeyboardKeyType.done)
      //                   ? Icon(
      //                 Icons.done,
      //                 color: BasicColors.primaryColor,
      //                 size: 35,
      //               )
      //                   : (keyboardKey.type == KeyboardKeyType.remove)
      //                   ? Icon(
      //                 Icons.backspace_outlined,
      //                 color: BasicColors.black,
      //               )
      //                   : Text(
      //                 keyboardKey.value,
      //                 style: TextStyle(
      //                     fontSize: 22,
      //                     color: (keyboardKey.type ==
      //                         KeyboardKeyType.fixed &&
      //                         discountType == 0)
      //                         ? BasicColors.white
      //                         : (keyboardKey.type ==
      //                         KeyboardKeyType.percent &&
      //                         discountType == 1)
      //                         ? BasicColors.white
      //                         : (keyboardKey.type ==
      //                         KeyboardKeyType.update)
      //                         ? BasicColors.white
      //                         : BasicColors.black),
      //               ),
      //               decoration: BoxDecoration(
      //                 color: (keyboardKey.type == KeyboardKeyType.fixed &&
      //                     discountType == 0)
      //                     ? BasicColors.primaryColor
      //                     : (keyboardKey.type == KeyboardKeyType.percent &&
      //                     discountType == 1)
      //                     ? BasicColors.primaryColor
      //                     : (keyboardKey.type == KeyboardKeyType.update)
      //                     ? BasicColors.primaryColor
      //                     : Colors.grey[200],
      //                 // borderRadius: BorderRadius.circular(itemWidthHeight / 4),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),

    );
  }


  getKeyBoardGridView2(
      List<KeyboardKey> keyboardKeys, TextEditingController textController,
      {bool isDiscount = false}) {
    double itemWidthHeight =  (Get.width / 4.1) / 4.9;

    // (Get.width / 3.5) / 4;

    log("Item Widht and Height: ${itemWidthHeight.toString()}");

    return Container(
        // color:Colors.red,
        height: MediaQuery.of(context).size.height /2.8.h,
        width: MediaQuery.of(context).size.width /4.5.h,
        child:

        // MediaQuery.of(context).size.width < 1200?
        GridView.builder(
          // physics: AlwaysScrollableScrollPhysics(),
          physics: NeverScrollableScrollPhysics(),

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1/0.87,
            crossAxisCount: 4,
            crossAxisSpacing: 14,
            mainAxisSpacing: 0,

          ),

          shrinkWrap: true,
          itemCount: keyboardKeys.length,
          itemBuilder: (BuildContext ctx, index) {
            KeyboardKey keyboardKey = keyboardKeys[index];
            return InkWell(
              onTap: () async {
                if (keyboardKey.type == KeyboardKeyType.clear) {
                  textController.clear();
                } else if (keyboardKey.type == KeyboardKeyType.update) {
                  textController.text = keyboardKey.valueToAdd;
                } else if (keyboardKey.type == KeyboardKeyType.remove) {
                  if (textController.text.length > 0) {
                    textController.text = textController.text
                        .substring(0, textController.text.length - 1);
                  }
                } else if (keyboardKey.type == KeyboardKeyType.insert) {
                  textController.text =
                      textController.text + keyboardKey.valueToAdd;
                } else if (keyboardKey.type == KeyboardKeyType.fixed) {
                  discountType = 0;
                } else if (keyboardKey.type == KeyboardKeyType.percent) {
                  discountType = 1;
                } else if (keyboardKey.type == KeyboardKeyType.done) {
                  var res = await controller.applyDiscount(
                      value: discountController.text,
                      type: discountType == 0 ? "fixed" : "percent",
                      orderId: '$orderId');

                  if (res != null) {
                    if (res is Order) {
                      setState(() {
                        order = res;
                      });
                      // discountController.clear();
                      controller.showToast("Discount Applied");
                    }
                    controller.isApplyingDiscount.value = false;
                    controller.isDiscountBtnClicked.value = false;
                    amountController.text =
                        double.parse("${order!.total.toString()}")
                            .toStringAsFixed(Config.fractionDigits);
                  }
                }

                if (isDiscount) {
                  setState(() {});
                } else {
                  setState(() {
                    calculateChange(
                        "${order!.total.toString()}", textController.text);
                  });
                }
              },
              child: Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: itemWidthHeight,
                      height: itemWidthHeight,
                      alignment: Alignment.center,
                      child: (keyboardKey.type == KeyboardKeyType.done)
                          ? Icon(
                        Icons.done,
                        color: BasicColors.primaryColor,
                        size: 32.sp,
                      )
                          : (keyboardKey.type == KeyboardKeyType.remove)
                          ? Icon(
                        Icons.backspace_outlined,
                        color: BasicColors.black,
                      )
                          : Text(
                        keyboardKey.value,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: (keyboardKey.type ==
                                KeyboardKeyType.fixed &&
                                discountType == 0)
                                ? BasicColors.white
                                : (keyboardKey.type ==
                                KeyboardKeyType.percent &&
                                discountType == 1)
                                ? BasicColors.white
                                : (keyboardKey.type ==
                                KeyboardKeyType.update)
                                ? BasicColors.white
                                : BasicColors.black),
                      ),
                      decoration: BoxDecoration(
                        color: (keyboardKey.type == KeyboardKeyType.fixed &&
                            discountType == 0)
                            ? BasicColors.primaryColor
                            : (keyboardKey.type == KeyboardKeyType.percent &&
                            discountType == 1)
                            ? BasicColors.primaryColor
                            : (keyboardKey.type == KeyboardKeyType.update)
                            ? BasicColors.primaryColor
                            : Colors.grey[200],
                        // borderRadius: BorderRadius.circular(itemWidthHeight / 4),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      //     : GridView.builder(
      //   // physics: AlwaysScrollableScrollPhysics(),
      //   physics: NeverScrollableScrollPhysics(),
      //
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     childAspectRatio: 1/1,
      //     crossAxisCount: 4,
      //     crossAxisSpacing: 48.5,
      //     mainAxisSpacing: 2,
      //
      //   ),
      //   shrinkWrap: true,
      //   itemCount: keyboardKeys.length,
      //   itemBuilder: (BuildContext ctx, index) {
      //     KeyboardKey keyboardKey = keyboardKeys[index];
      //     return InkWell(
      //       onTap: () async {
      //         if (keyboardKey.type == KeyboardKeyType.clear) {
      //           textController.clear();
      //         } else if (keyboardKey.type == KeyboardKeyType.update) {
      //           textController.text = keyboardKey.valueToAdd;
      //         } else if (keyboardKey.type == KeyboardKeyType.remove) {
      //           if (textController.text.length > 0) {
      //             textController.text = textController.text
      //                 .substring(0, textController.text.length - 1);
      //           }
      //         } else if (keyboardKey.type == KeyboardKeyType.insert) {
      //           textController.text =
      //               textController.text + keyboardKey.valueToAdd;
      //         } else if (keyboardKey.type == KeyboardKeyType.fixed) {
      //           discountType = 0;
      //         } else if (keyboardKey.type == KeyboardKeyType.percent) {
      //           discountType = 1;
      //         } else if (keyboardKey.type == KeyboardKeyType.done) {
      //           var res = await controller.applyDiscount(
      //               value: discountController.text,
      //               type: discountType == 0 ? "fixed" : "percent",
      //               orderId: '$orderId');
      //
      //           if (res != null) {
      //             if (res is Order) {
      //               setState(() {
      //                 order = res;
      //               });
      //               // discountController.clear();
      //               controller.showToast("Discount Applied");
      //             }
      //             controller.isApplyingDiscount.value = false;
      //             controller.isDiscountBtnClicked.value = false;
      //             amountController.text =
      //                 double.parse("${order!.total.toString()}")
      //                     .toStringAsFixed(Config.fractionDigits);
      //           }
      //         }
      //
      //         if (isDiscount) {
      //           setState(() {});
      //         } else {
      //           setState(() {
      //             calculateChange(
      //                 "${order!.total.toString()}", textController.text);
      //           });
      //         }
      //       },
      //       child: Container(
      //
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Container(
      //               width: itemWidthHeight,
      //               height: itemWidthHeight,
      //               alignment: Alignment.center,
      //               child: (keyboardKey.type == KeyboardKeyType.done)
      //                   ? Icon(
      //                 Icons.done,
      //                 color: BasicColors.primaryColor,
      //                 size: 35,
      //               )
      //                   : (keyboardKey.type == KeyboardKeyType.remove)
      //                   ? Icon(
      //                 Icons.backspace_outlined,
      //                 color: BasicColors.black,
      //               )
      //                   : Text(
      //                 keyboardKey.value,
      //                 style: TextStyle(
      //                     fontSize: 22,
      //                     color: (keyboardKey.type ==
      //                         KeyboardKeyType.fixed &&
      //                         discountType == 0)
      //                         ? BasicColors.white
      //                         : (keyboardKey.type ==
      //                         KeyboardKeyType.percent &&
      //                         discountType == 1)
      //                         ? BasicColors.white
      //                         : (keyboardKey.type ==
      //                         KeyboardKeyType.update)
      //                         ? BasicColors.white
      //                         : BasicColors.black),
      //               ),
      //               decoration: BoxDecoration(
      //                 color: (keyboardKey.type == KeyboardKeyType.fixed &&
      //                     discountType == 0)
      //                     ? BasicColors.primaryColor
      //                     : (keyboardKey.type == KeyboardKeyType.percent &&
      //                     discountType == 1)
      //                     ? BasicColors.primaryColor
      //                     : (keyboardKey.type == KeyboardKeyType.update)
      //                     ? BasicColors.primaryColor
      //                     : Colors.grey[200],
      //                 // borderRadius: BorderRadius.circular(itemWidthHeight / 4),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),

    );
  }


  getDiscountScreen() {
    List<KeyboardKey> discountKeyboardKeys = [
      KeyboardKey("1", KeyboardKeyType.insert, "1"),
      KeyboardKey("2", KeyboardKeyType.insert, "2"),
      KeyboardKey("3", KeyboardKeyType.insert, "3"),
      KeyboardKey("Fixed", KeyboardKeyType.fixed, ""),
      KeyboardKey("4", KeyboardKeyType.insert, "4"),
      KeyboardKey("5", KeyboardKeyType.insert, "5"),
      KeyboardKey("6", KeyboardKeyType.insert, "6"),
      KeyboardKey("Percent", KeyboardKeyType.percent, ""),
      KeyboardKey("7", KeyboardKeyType.insert, "7"),
      KeyboardKey("8", KeyboardKeyType.insert, "8"),
      KeyboardKey("9", KeyboardKeyType.insert, "9"),
      KeyboardKey("x", KeyboardKeyType.remove, ""),
      KeyboardKey("C", KeyboardKeyType.clear, ""),
      KeyboardKey("0", KeyboardKeyType.insert, "0"),
      KeyboardKey(".", KeyboardKeyType.insert, "."),
      KeyboardKey("", KeyboardKeyType.done, ""),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 240.0),
      child: Container(
        // width: Get.width / 1.6.w,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: BasicColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: BasicColors.white,
                margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: EntryField(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: BasicColors.primaryColor),
                  ),
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  hint: "0.0",
                  readOnly: true,
                  onChanged: (value) {
                    // if (value.length > 0) {
                    //   calculateChange("$price", discountController.text);
                    // } else {
                    //   setState(() {
                    //     widget.error = "pleaseEnterSomethingFirst".tr;
                    //   });
                    // }
                  },
                  backgroundColorGet: controller.isDarkTheme.value ? true : false,
                ),
              ),
              getKeyBoardGridView(discountKeyboardKeys, discountController,
                  isDiscount: true),
            ],
          ),
        ),
      ),
    );
  }
}

enum KeyboardKeyType { insert, remove, clear, update, done, fixed, percent }

class KeyboardKey {
  String value;
  KeyboardKeyType type;
  String valueToAdd;

  KeyboardKey(this.value, this.type, this.valueToAdd);
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}