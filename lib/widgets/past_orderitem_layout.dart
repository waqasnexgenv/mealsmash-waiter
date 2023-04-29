import 'dart:developer';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:get/get.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../controllers/common_controller.dart';
import '../helper/app_config.dart';
import '../helper/colors.dart';
import '../helper/strings.dart';
import '../model/order.dart';
import '../model/pastorders.dart';

class PastOrderWidget extends StatefulWidget {
  PastOrder order;
  bool isPastOrders;
  CommonController controller;

  PastOrderWidget(
      {Key? key,
      required this.order,
      required this.controller,
      this.isPastOrders = true})
      : super(key: key);

  @override
  State<PastOrderWidget> createState() => _PastOrderWidgetState();
}

class _PastOrderWidgetState extends State<PastOrderWidget> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  String orderId = '0';
  var printerVendorId;
  var printerProductId;
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;
  bool returned = true;
  var pref;
  var isPrinterSet;
  List<int> printTxt = [];

  Generator? generator;
  CapabilityProfile? profile;
  @override
  void initState() {
    super.initState();
    // getPrinterStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomClipPath(),
      child: FadedScaleAnimation(
        Container(
          color: BasicColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // (widget.order.orderMeta == null)?Container()
              //     :widget.order.orderMeta!.length<1?Container()
              //     :
              Container(
                color: (widget.order.kStatus == 0)
                    ? BasicColors.secondaryColor
                    : (widget.order.kStatus == 1)
                        ? BasicColors.orderPreparingColor
                        : (widget.order.kStatus == 2)
                            ? BasicColors.orderPreparedColor
                            : BasicColors.orderCompletedColor,
                child: ListTile(
                  onTap: () {
                    if (widget.order.kStatus != 3) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0.sp)),
                            child: Container(
                              width: 370.w,
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "warning".tr + ": ",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20.sp),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 18.sp),
                                    child: Text(
                                      "thisWillChange".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // (order.kStatus != 0)?getDisabledItem("preparing".tr, BasicColors
                                      //     .orderPreparingColor):
                                      Container(
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          color:
                                              BasicColors.orderPreparingColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextButton(
                                          child: Text("preparing".tr,
                                              style: TextStyle(
                                                  color: BasicColors.white,fontSize: 20.sp)),
                                          onPressed: () {
                                            // widget.controller.updateOrderStatus(
                                            //     orderId:
                                            //         "${widget.order.id.toString()}",
                                            //     status: "1");
                                            // Get.back();
                                            // if(order.kStatus == 0){
                                            //   controller.updateOrderStatus(orderId: "${item.id.toString()}", status:  "1");
                                            //   Get.back();
                                            // }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      // (order.kStatus != 1)?getDisabledItem("prepared".tr, BasicColors
                                      //     .orderPreparedColor):
                                      Container(
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          color: BasicColors.orderPreparedColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextButton(
                                          child: Text("prepared".tr,
                                              style: TextStyle(
                                                  color: BasicColors.white,fontSize: 20.sp)),
                                          onPressed: () {
                                            // widget.controller.updateOrderStatus(
                                            //     orderId:
                                            //         "${widget.order.id.toString()}",
                                            //     status: "2");
                                            // Get.back();
                                            // if(order.kStatus == 1){
                                            //   controller.updateOrderItemStatus(itemId: "${item.id.toString()}", status:  "2");
                                            //   Get.back();
                                            // }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      // (order.kStatus != 2)?getDisabledItem("served".tr, BasicColors
                                      //     .orderCompletedColor):
                                      Container(
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          color:
                                              BasicColors.orderCompletedColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextButton(
                                          child: Text("served".tr,
                                              style: TextStyle(
                                                  color: BasicColors.white,fontSize: 20.sp)),
                                          onPressed: () {
                                            // widget.controller.updateOrderStatus(
                                            //     orderId:
                                            //         "${widget.order.id.toString()}",
                                            //     status: "3");
                                            // Get.back();
                                            // if(order.kStatus == 2){
                                            //   controller.updateOrderItemStatus(itemId: "${item.id.toString()}", status:  "3");
                                            //   Get.back();
                                            // }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.order.orderTypeStatus}",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.white),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          ///waqas change

                          // widget.order.areaName.toString().isNotEmpty? Expanded(
                          //   child: Text(
                          //     "(${widget.order.areaName.toString() + widget.order.tableName.toString()})",
                          //     style: TextStyle(
                          //         fontSize: 20.sp,
                          //         color: BasicColors.secondSecondaryColor),
                          //   ),
                          // ):Container(),
                          ///waqas change
                          // Text(
                          //   "(${widget.order.vendorName.toString()})",
                          //   style: TextStyle(
                          //       fontSize: 12,
                          //       color: BasicColors.secondSecondaryColor),
                          // ),
                        ],
                      ),

                      // Text(
                      //   "${widget.order.areaName.toString() + widget.order.tableName.toString()}",
                      //   style: TextStyle(
                      //       fontSize: 12,
                      //       color: BasicColors.secondSecondaryColor),
                      // ),
                      SizedBox(
                        height: 6.h,
                      ),
                      // order Id and date,Time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "orderId".tr + ": ${widget.order.id.toString()}",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: BasicColors.secondSecondaryColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${(widget.order.createdAt == null) ? "" : widget.order.createdAt!.format('d M y, h:i A')}",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: BasicColors.secondSecondaryColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // (widget.order.orderMeta == null)?Container()
              // :widget.order.orderMeta!.length<1?Container()
              // :
              // print Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" Total:   \$${widget.order.total}", style: TextStyle(
                        fontSize: 18.sp,
                        ),
                      overflow: TextOverflow.ellipsis,),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          testPrint();
                        },
                        child: Padding(
                          padding:  EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.w),
                          child: Icon(
                            Icons.print,
                            color: Theme.of(context).primaryColor,
                              size: 18.sp
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black12,
              ),
              (widget.order.orderMeta == null)
                  ? Container(
                      margin:EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),

                child: Text("noItemsInOrder".tr,style: TextStyle(fontSize: 20.sp),),
                    )
                  : widget.order.orderMeta!.length < 1
                      ? Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                          child: Text("noItemsInOrder".tr,style: TextStyle(fontSize: 20.sp)),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.order.orderMeta!.length,
                          itemBuilder: (context, index) {
                            OrderMetaa item = widget.order.orderMeta![index];
                            // testPrint();
                            return Padding(
                              padding:  EdgeInsets.symmetric(
                                  vertical: 12.0.h, horizontal: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // log("Order Items Clicked -- ${item.products?.title}");
                                      // if(item.kStatus != 3){
                                      //   showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return Dialog(
                                      //         shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //             BorderRadius.circular(4.0)),
                                      //         child: Container(
                                      //           width: 370,
                                      //           padding: EdgeInsets.symmetric(vertical: 10),
                                      //           child: Column(
                                      //             mainAxisSize: MainAxisSize.min,
                                      //             children: [
                                      //               Text("currentStatus".tr+": ${(item.kStatus==0)?"received".tr:(item.kStatus==1)?"preparing".tr:(item.kStatus==2)?"prepared".tr:(item.kStatus==3)?"served".tr:"Unknown"}"),
                                      //               SizedBox(
                                      //                 height: 10,
                                      //               ),
                                      //               Row(
                                      //                 mainAxisAlignment:
                                      //                 MainAxisAlignment.center,
                                      //                 crossAxisAlignment:
                                      //                 CrossAxisAlignment.center,
                                      //                 children: [
                                      //                   (item.kStatus != 0)?getDisabledItem("preparing".tr, BasicColors
                                      //                       .orderPreparingColor):
                                      //                   Container(
                                      //                     width: 100,
                                      //                     decoration:
                                      //                     BoxDecoration(
                                      //                       color: BasicColors
                                      //                           .orderPreparingColor,
                                      //                       borderRadius:
                                      //                       BorderRadius.circular(10),),
                                      //                     child: TextButton(
                                      //                       child: Text("preparing".tr,
                                      //                           style: TextStyle(
                                      //                               color: BasicColors
                                      //                                   .white)),
                                      //                       onPressed: () {
                                      //                         if(item.kStatus == 0){
                                      //                           widget.controller.updateOrderItemStatus(itemId: "${item.id.toString()}", status:  "1");
                                      //                           Get.back();
                                      //                         }
                                      //                       },
                                      //                     ),
                                      //                   ),
                                      //                   SizedBox(width: 10,),
                                      //                   (item.kStatus != 1)?getDisabledItem("prepared".tr, BasicColors
                                      //                       .orderPreparedColor):Container(
                                      //                     width: 100,
                                      //                     decoration:
                                      //                     BoxDecoration(
                                      //                       color: BasicColors
                                      //                           .orderPreparedColor,
                                      //                       borderRadius:
                                      //                       BorderRadius.circular(10),),
                                      //                     child: TextButton(
                                      //                       child: Text("prepared".tr,
                                      //                           style: TextStyle(
                                      //                               color: BasicColors
                                      //                                   .white)),
                                      //                       onPressed: () {
                                      //                         if(item.kStatus == 1){
                                      //                           widget.controller.updateOrderItemStatus(itemId: "${item.id.toString()}", status:  "2");
                                      //                           Get.back();
                                      //                         }
                                      //                       },
                                      //                     ),
                                      //                   ),
                                      //                   SizedBox(width: 10,),
                                      //                   (item.kStatus != 2)?getDisabledItem("served".tr, BasicColors
                                      //                       .orderCompletedColor):Container(
                                      //                     width: 100,
                                      //                     decoration:
                                      //                     BoxDecoration(
                                      //                       color: BasicColors
                                      //                           .orderCompletedColor,
                                      //                       borderRadius:
                                      //                       BorderRadius.circular(10),),
                                      //                     child: TextButton(
                                      //                       child: Text("served".tr,
                                      //                           style: TextStyle(
                                      //                               color: BasicColors
                                      //                                   .white)),
                                      //                       onPressed: () {
                                      //                         if(item.kStatus == 2){
                                      //                           widget.controller.updateOrderItemStatus(itemId: "${item.id.toString()}", status:  "3");
                                      //                           Get.back();
                                      //                         }
                                      //                       },
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               )
                                      //             ],
                                      //           ),
                                      //         ),);
                                      //     },);
                                      // }
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.products?.title != null
                                                ? "${item.qty.toString()}" +
                                                    '\t\t\t' +
                                                    "${item.products?.title}"
                                                : "${item.qty.toString()}" +
                                                    '\t\t\t' +
                                                    "${item.variantName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                decoration: item.kStatus == 3
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration
                                                        .lineThrough,
                                                color: item.kStatus == 3
                                                    ? BasicColors
                                                        .strikeThroughColor
                                                    : BasicColors
                                                        .strikeThroughColor,fontSize: 16.sp),
                                          ),
                                        ),
                                        widget.isPastOrders
                                            ? SizedBox.shrink()
                                            : ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: 8.w, maxHeight: 8.h),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  child: Container(
                                                    color: (item.kStatus == 1)
                                                        ? BasicColors
                                                            .orderPreparingColor
                                                        : (item.kStatus == 2)
                                                            ? BasicColors
                                                                .orderPreparedColor
                                                            : (item.kStatus ==
                                                                    3)
                                                                ? BasicColors
                                                                    .orderCompletedColor
                                                                : BasicColors
                                                                    .secondaryColor,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  (item.variantName == null)
                                      ? SizedBox.shrink()
                                      : RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: '\t\t\t\t\t\t'),
                                              TextSpan(
                                                text:
                                                    "(${Strings.convertArrayToCommaSeparatedString(item.variantName!.split(","))})",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 17.sp,
                                                    color: item.kStatus == 3
                                                        ? BasicColors
                                                            .strikeThroughColor
                                                        : BasicColors
                                                            .strikeThroughColor,
                                                    decoration:
                                                        item.kStatus == 3
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .lineThrough),
                                              ),
                                            ],
                                          ),
                                        ),
                                  (item.orderItemExtras == null)
                                      ? SizedBox.shrink()
                                      : ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              item.orderItemExtras!.length,
                                          itemBuilder: (context, index) {
                                            OrderItemExtraa extra =
                                                item.orderItemExtras![index];
                                            return RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: '\t\t\t\t\t\t'),
                                                  TextSpan(
                                                    text: "${extra.extraName}",
                                                    // style: TextStyle(
                                                    //     fontWeight:
                                                    //         FontWeight.w300,
                                                    //     fontSize: 14,
                                                    //     color: item.kStatus == 3
                                                    //         ? BasicColors
                                                    //             .strikeThroughColor
                                                    //         : BasicColors.black,
                                                    //     decoration:
                                                    //         item.kStatus == 3
                                                    //             ? TextDecoration
                                                    //                 .lineThrough
                                                    //             : TextDecoration
                                                    //                 .none),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 17.sp,
                                                        color: item.kStatus == 3
                                                            ? BasicColors
                                                            .strikeThroughColor
                                                            : BasicColors
                                                            .strikeThroughColor,
                                                        decoration:
                                                        item.kStatus == 3
                                                            ? TextDecoration
                                                            .lineThrough
                                                            : TextDecoration
                                                            .lineThrough),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                ],
                              ),
                            );
                          }),
              // (widget.order.orderMeta == null)?Container()
              //     :widget.order.orderMeta!.length<1?Container()
              //     :
            ],
          ),
        ),
        durationInMilliseconds: 400,
      ),
    );
  }

  getDisabledItem(String title, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: color,
          ),
          child: TextButton(
            child: Text(title, style: TextStyle(color: BasicColors.white,fontSize: 20.sp)),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  getPrinterStatus() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    print("etttt");
    // print(p.getBool("isPrinterSet"));
    print(p.containsKey('isPrinterSet'));
    if (p.containsKey("isPrinterSet") == false) {
      p.setBool("isPrinterSet", true);
      isPrinterSet = true;
    }
    isPrinterSet = p.getBool('isPrinterSet');

    if (isPrinterSet == true) {
      // testPrint();
    }
  }

  testPrint() async {

    pref = await SharedPreferences.getInstance();
    var paper = pref.getString('paper');
    print("selectedpaper${paper}");

    if (paper == '80mm')
    {


    bluetooth.isConnected.then((isConnected) async {
      if (isConnected!) {
        try {
          DateTime now = DateTime.now();

          String split1 = now.toString();
          String date = split1.split(",").first;
          String time = split1.split(',').last;

          await bluetooth.printCustom(
              DateFormat('kk:mm:ss , EEE d MMM').format(now), 0, 0);
          await bluetooth.printCustom("MEALSMASH", 2, 1);
          await bluetooth.printNewLine();
          bluetooth.printLeftRight("Invoice: ${widget.order.invId}", "", 1);
          // bluetooth.printLeftRight("Invoice: ${widget.order.tableName}", "", 1);
          // await bluetooth.printNewLine();
          // bluetooth.printLeftRight("Date: $date","Time: $time",0);
          // bluetooth.printLeftRight("Date: ${widget.order.createdAt!.format('d M y , h:i A')}       ", "", 1);
          await bluetooth.printLeftRight(
              "Order-Type: ${widget.order.orderTypeStatus}", "", 1);

          // await bluetooth.printCustom("\n",0, 0);

          // , "  Type: ${invoiceData.orderTypeStatus}", 0)

          // await bluetooth.printCustom(
          //     "Payment Method: ${widget.order.paymentMethod == 'cod' ? "cash" : 'Bullseye'}",
          //     0,
          //     0);
          // await bluetooth.printCustom(
          //     "Payment Status: ${widget.order.paymentStatus.toString() == "1" ? "Paid" : "Not Paid"}",
          //     0,
          //     0);
          // await bluetooth.printCustom("Payment Method: ${invoiceData.paymentMethod == 'cod' ? "cash": 'Bullseye' } \nPayment Status: ${invoiceData.paymentStatus == '1'? "Paid" : "Not Paid"}\n",0, 0);
          // await bluetooth.printNewLine();
          await bluetooth.printCustom("Kitchen Receipt", 1, 1);
          await bluetooth.printNewLine();
          await bluetooth.printCustom(
              "-------------------------------------", 0, 1);
          await bluetooth.printLeftRight(
              "Items".toUpperCase(), "Qty".toUpperCase(), 0);
          await bluetooth.printCustom(
              "-------------------------------------", 0, 1);
          var sum = 0;

          for (var i = 0; i < widget.order.orderMeta!.length; i++) {
            sum = sum + (widget.order.orderMeta![i].qty)!;
            // bluetooth.printLeftRight("${invoiceData.orderMeta[i].products.title}       ", "        ${invoiceData.orderMeta[i].products.total.toString()}",0);
            if (widget.order.orderMeta![i].products!.title!.length < 8) {
              bluetooth.printLeftRight(
                  "${widget.order.orderMeta![i].products!.title}\t\t\t\t               ",
                  " \t\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                  0);
            }
            else if (widget.order.orderMeta![i].products!.title!.length < 14) {
              bluetooth.printLeftRight(
                  "${widget.order.orderMeta![i].products!.title}\t\t\t              ",
                  "          \t\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                  0);
            } else if ((widget.order.orderMeta![i].products!.title)!.length <
                19) {
              bluetooth.printLeftRight(
                  "${widget.order.orderMeta![i].products!.title}\t\t\t\t       ",
                  "         \t\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                  0);
            } else {
              bluetooth.printLeftRight(
                  "${widget.order.orderMeta![i].products!.title}\t\t\t",
                  "\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                  0);
            }

            // (widget.order.orderMeta![i].products!.title)!.length < 19 ? bluetooth.printLeftRight("${widget.order.orderMeta![i].products!.title}\t\t\t\t         ",
            //     "        \t\t\t\t${widget.order.orderMeta![i].qty.toString()}", 0) : bluetooth.printLeftRight("${widget.order.orderMeta![i].products!.title}",
            //     "${widget.order.orderMeta![i].qty.toString()}", 0)  ;
            if (widget.order.orderMeta![i].variantName != null) {
              bluetooth.printLeftRight(
                  "(${widget.order.orderMeta![i].variantName})", "", 0);
            }
            // bluetooth.printLeftRight(
            //     "\$ ${widget.order.orderMeta![i].products!.price!.price.toString()} x ${widget.order.orderMeta![i].qty.toString()}",
            //     "",

            if (widget.order.orderMeta![i].orderItemExtras!.isNotEmpty) {
              for (var o = 0;
              o < widget.order.orderMeta![i].orderItemExtras!.length;
              o++) {
                bluetooth.printCustom(
                    "   + ${widget.order.orderMeta![i].orderItemExtras![o].extraName}",
                    0,
                    // "+\$ ${widget.order.orderMeta![i].orderItemExtras![o].extraPrice}",
                    0);

                // bluetooth.printLeftRight("+ ${invoiceData.orderMeta[i].orderItemExtras[o].extraName}       ", "        +\$ ${invoiceData.orderMeta[i].orderItemExtras[o].extraPrice}",0);
              }
            }            await bluetooth.printNewLine();
          }

          await bluetooth.printCustom(
              "-------------------------------------", 0, 1);
          // bluetooth.printLeftRight("Sub Total", "\$ ${widget.order.subtotal}", 0);
          // // await flutterUsbPrinter.printText("\n");
          // bluetooth.printLeftRight("Discount", "\$ ${widget.order.discount}", 0);
          // // await flutterUsbPrinter.printText("\n");
          // bluetooth.printLeftRight("Tax", "\$ ${widget.order.tax}", 0);
          // // await flutterUsbPrinter.printText("\n");
          // // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
          // await bluetooth.printCustom(
          //     "-------------------------------------", 0, 1);
          bluetooth.printLeftRight("Total Items         ".toUpperCase(),
              "         $sum".toUpperCase(), 0);
          await bluetooth.printCustom(
              "-------------------------------------", 0, 1);
        } on PlatformException {
          String response = 'Failed to get platform.';

          Fluttertoast.showToast(
              msg: response,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 20.0.sp);

          print(response);
        }
      } else {
        returned
            ? _print()
            : Fluttertoast.showToast(
                msg: "Invoice printer not connected",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 20.0.sp);
      }
    });
  }
    else  {


      bluetooth.isConnected.then((isConnected) async {
        if (isConnected!) {
          try {
            DateTime now = DateTime.now();

            String split1 = now.toString();
            String date = split1.split(",").first;
            String time = split1.split(',').last;

            await bluetooth.printCustom(
                DateFormat('kk:mm:ss , EEE d MMM').format(now), 0, 0);
            await bluetooth.printCustom("MEALSMASH", 2, 1);
            await bluetooth.printNewLine();
            bluetooth.printLeftRight("Invoice: ${widget.order.invId}", "", 1);
            // bluetooth.printLeftRight("Invoice: ${widget.order.tableName}", "", 1);
            // await bluetooth.printNewLine();
            // bluetooth.printLeftRight("Date: $date","Time: $time",0);
            // bluetooth.printLeftRight("Date: ${widget.order.createdAt!.format('d M y , h:i A')}       ", "", 1);
            await bluetooth.printLeftRight(
                "Order-Type: ${widget.order.orderTypeStatus}", "", 1);

            // await bluetooth.printCustom("\n",0, 0);

            // , "  Type: ${invoiceData.orderTypeStatus}", 0)

            // await bluetooth.printCustom(
            //     "Payment Method: ${widget.order.paymentMethod == 'cod' ? "cash" : 'Bullseye'}",
            //     0,
            //     0);
            // await bluetooth.printCustom(
            //     "Payment Status: ${widget.order.paymentStatus.toString() == "1" ? "Paid" : "Not Paid"}",
            //     0,
            //     0);
            // await bluetooth.printCustom("Payment Method: ${invoiceData.paymentMethod == 'cod' ? "cash": 'Bullseye' } \nPayment Status: ${invoiceData.paymentStatus == '1'? "Paid" : "Not Paid"}\n",0, 0);
            // await bluetooth.printNewLine();
            await bluetooth.printCustom("Kitchen Receipt", 1, 1);
            await bluetooth.printNewLine();
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            await bluetooth.printLeftRight(
                "Items".toUpperCase(), "Qty".toUpperCase(), 0);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            var sum = 0;

            for (var i = 0; i < widget.order.orderMeta!.length; i++) {
              sum = sum + (widget.order.orderMeta![i].qty)!;
              // bluetooth.printLeftRight("${invoiceData.orderMeta[i].products.title}       ", "        ${invoiceData.orderMeta[i].products.total.toString()}",0);
              if (widget.order.orderMeta![i].products!.title!.length < 8) {
                bluetooth.printLeftRight(
                    "${widget.order.orderMeta![i].products!.title}\t\t\t\t               ",
                    " \t\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                    0);
              }
              else if (widget.order.orderMeta![i].products!.title!.length < 14) {
                bluetooth.printLeftRight(
                    "${widget.order.orderMeta![i].products!.title}\t\t\t              ",
                    "          \t\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                    0);
              } else if ((widget.order.orderMeta![i].products!.title)!.length <
                  19) {
                bluetooth.printLeftRight(
                    "${widget.order.orderMeta![i].products!.title}\t\t\t\t       ",
                    "         \t\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                    0);
              } else {
                bluetooth.printLeftRight(
                    "${widget.order.orderMeta![i].products!.title}\t\t\t",
                    "\t\t\t${widget.order.orderMeta![i].qty.toString()}",
                    0);
              }

              // (widget.order.orderMeta![i].products!.title)!.length < 19 ? bluetooth.printLeftRight("${widget.order.orderMeta![i].products!.title}\t\t\t\t         ",
              //     "        \t\t\t\t${widget.order.orderMeta![i].qty.toString()}", 0) : bluetooth.printLeftRight("${widget.order.orderMeta![i].products!.title}",
              //     "${widget.order.orderMeta![i].qty.toString()}", 0)  ;
              if (widget.order.orderMeta![i].variantName != null) {
                bluetooth.printLeftRight(
                    "(${widget.order.orderMeta![i].variantName})", "", 0);
              }
              // bluetooth.printLeftRight(
              //     "\$ ${widget.order.orderMeta![i].products!.price!.price.toString()} x ${widget.order.orderMeta![i].qty.toString()}",
              //     "",

              if (widget.order.orderMeta![i].orderItemExtras!.isNotEmpty) {
                for (var o = 0;
                o < widget.order.orderMeta![i].orderItemExtras!.length;
                o++) {
                  bluetooth.printCustom(
                      "   + ${widget.order.orderMeta![i].orderItemExtras![o].extraName}",
                      0,
                      // "+\$ ${widget.order.orderMeta![i].orderItemExtras![o].extraPrice}",
                      0);

                  // bluetooth.printLeftRight("+ ${invoiceData.orderMeta[i].orderItemExtras[o].extraName}       ", "        +\$ ${invoiceData.orderMeta[i].orderItemExtras[o].extraPrice}",0);
                }
              }            await bluetooth.printNewLine();
            }

            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            // bluetooth.printLeftRight("Sub Total", "\$ ${widget.order.subtotal}", 0);
            // // await flutterUsbPrinter.printText("\n");
            // bluetooth.printLeftRight("Discount", "\$ ${widget.order.discount}", 0);
            // // await flutterUsbPrinter.printText("\n");
            // bluetooth.printLeftRight("Tax", "\$ ${widget.order.tax}", 0);
            // // await flutterUsbPrinter.printText("\n");
            // // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
            // await bluetooth.printCustom(
            //     "-------------------------------------", 0, 1);
            bluetooth.printLeftRight("Total Items         ".toUpperCase(),
                "         $sum".toUpperCase(), 0);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
          } on PlatformException {
            String response = 'Failed to get platform.';

            Fluttertoast.showToast(
                msg: response,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 20.0.sp);

            print(response);
          }
        } else {
          returned
              ? _print58()
              : Fluttertoast.showToast(
              msg: "Invoice printer not connected",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 20.0.sp);
        }
      });
    }


  }

  _print() async {
    profile = await CapabilityProfile.load(name: 'XP-N160I');

    generator = Generator(PaperSize.mm80, profile!);
    printTxt += generator?.setGlobalCodeTable('CP1252') ?? [];
    print("80mm Printing here");
    try {
      DateTime now = DateTime.now();

      // String split1 = now.toString();
      // String date = now.split(",").toString() ;
      // String time = split1.split(',').last;

      printTxt += generator!.text(
          DateFormat('kk:mm:ss , EEE d MMM\n').format(now),
          styles: PosStyles(align: PosAlign.center));
      printTxt += generator!.text("${widget.order.vendorName}\n",
          styles: PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              align: PosAlign.center,
              bold: true));
      printTxt += generator!.row([
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Invoice# : ${widget.order.invId}     ",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      printTxt += generator!.row([
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Order-Type: ${widget.order.orderTypeStatus} ",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      printTxt += generator!.row([
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Kitchen-Status: ${widget.order.kitchenStatus} ",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);
      //
      // if (widget.order.areaName != null && widget.order.areaName != "") {
      //   printTxt += generator!.row([
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: "Area Name: ${widget.order.areaName} ",
      //       width: 10,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //   ]);
      // }
      // if (widget.order.tableName != null && widget.order.tableName != "") {
      //   printTxt += generator!.row([
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: "Table Name: ${widget.order.tableName} \n",
      //       width: 10,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //   ]);
      // }
      //
      //
      //
      //
      //
      // if (widget.order.tableName == null || widget.order.tableName == "") {
      //   printTxt += generator!.row([
      //
      //     PosColumn(
      //       text: "",
      //       width: 12,
      //       styles: PosStyles(
      //         align: PosAlign.right,
      //       ),
      //     ),
      //   ]);
      // }



      printTxt += generator!.text("Kitchen Receipt\n",
          styles: PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              align: PosAlign.center,
              bold: true));


      // printTxt += generator!.row([
      //   PosColumn(
      //     text: '              ',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      //   PosColumn(
      //     text: "---------------------------------------------------------",
      //     width: 10,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      //
      //   PosColumn(
      //     text: '             ',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      // ]);


      printTxt += generator!.row([
        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "ITEMS   ",
          width: 4,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '           ',
          width: 4,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: '       ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      printTxt += generator!.row([
        PosColumn(
          text: '           ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "---------------------------------------------------------",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),

        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);


      var sum = 0;
      for (var i = 0; i < widget.order.orderMeta!.length; i++) {
        sum = sum + (widget.order.orderMeta![i].qty)!;

        printTxt += generator!.row([
          PosColumn(
            text: '        ',
            width: 1,
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "${widget.order.orderMeta![i].products!.title}",
            width: 4,
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: '       ',
            width: 4,
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: ' ${widget.order.orderMeta![i].qty.toString()}',
            width: 2,
            styles: PosStyles(
              align: PosAlign.right,
            ),
          ),
          PosColumn(
            text: '          ',
            width: 1,
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
        ]);


        if (widget.order.orderMeta![i].variantName != null) {

          printTxt += generator!.row([
            PosColumn(
              text: '          ',
              width: 1,
              styles: PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: "(${widget.order.orderMeta![i].variantName})",
              width: 4,
              styles: PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: '       ',
              width: 4,
              styles: PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: '                  ',
              width: 2,
              styles: PosStyles(
                align: PosAlign.right,
              ),
            ),
            PosColumn(
              text: '          ',
              width: 1,
              styles: PosStyles(
                align: PosAlign.left,
              ),
            ),
          ]);

        }

        // await flutterUsbPrinter.printText("\$ ${widget.order.orderMeta![i].products!.price!.price.toString()} x ${widget.order.orderMeta![i].qty.toString()} \n");

        if (widget.order.orderMeta![i].orderItemExtras!.isNotEmpty) {
          for (var o = 0;
          o < widget.order.orderMeta![i].orderItemExtras!.length;
          o++) {

            printTxt += generator!.row([
              PosColumn(
                text: '          ',
                width: 1,
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                text: "+ ${widget.order.orderMeta![i].orderItemExtras![o].extraName}",
                width: 4,
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                text: '       ',
                width: 4,
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                text:
                '         ',
                width: 2,
                styles: PosStyles(
                  align: PosAlign.right,
                ),
              ),
              PosColumn(
                text: '          ',
                width: 1,
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              ),
            ]);

          }
        }


      }

      printTxt += generator!.row([
        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "---------------------------------------------------------",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),

        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      printTxt += generator!.row([
        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Total Items   ",
          width: 4,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '           ',
          width: 4,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '$sum',
          width: 2,
          styles: PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: '       ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      // printTxt += generator!.row([
      //   PosColumn(
      //     text: '',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      //   PosColumn(
      //     text: "---------------------------------------------------------",
      //     width: 10,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      //
      //   PosColumn(
      //     text: '',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      // ]);

      await AppConfig.printerSetupState
          ?.printReceiveTest(printTxt, generator);
      printTxt.clear();

    } on PlatformException {
      String response = 'Failed to get platform version.';
      Fluttertoast.showToast(
          msg: response,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0.sp);
      print(response);
    }
  }
  _print58() async
  {
    print("58mm Printing here");
    profile = await CapabilityProfile.load(name: 'XP-N160I');

    generator = Generator(PaperSize.mm58, profile!);
    printTxt += generator?.setGlobalCodeTable('CP1252') ?? [];
    try {
      DateTime now = DateTime.now();

      // String split1 = now.toString();
      // String date = now.split(",").toString() ;
      // String time = split1.split(',').last;

      printTxt += generator!.text(
          DateFormat('kk:mm:ss , EEE d MMM').format(now),
          styles: PosStyles(align: PosAlign.center));
      printTxt += generator!.row([
        PosColumn(
          text: '',
          width: 12,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),]);
      printTxt += generator!.text("${widget.order.vendorName}",
          styles: PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              align: PosAlign.center,
              bold: true));
      printTxt += generator!.row([
        PosColumn(
          text: '',
          width: 12,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),]);
      printTxt += generator!.row([
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Invoice# : ${widget.order.invId}     ",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      printTxt += generator!.row([
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Order-Type: ${widget.order.orderTypeStatus} ",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);



      printTxt += generator!.row([
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Kitchen-Status: ${widget.order.kitchenStatus} ",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '          ',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      //
      // if (widget.order.areaName != null && widget.order.areaName != "") {
      //   printTxt += generator!.row([
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: "Area Name: ${widget.order.areaName} ",
      //       width: 10,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //   ]);
      // }
      //
      // if (widget.order.tableName != null && widget.order.tableName != "") {
      //   printTxt += generator!.row([
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: "Table Name: ${widget.order.tableName}\n ",
      //       width: 10,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //     PosColumn(
      //       text: '          ',
      //       width: 1,
      //       styles: PosStyles(
      //         align: PosAlign.left,
      //       ),
      //     ),
      //   ]);
      // }
      //
      //
      //
      //
      //
      //
      // if (widget.order.tableName == null || widget.order.tableName == "") {
      //   printTxt += generator!.row([
      //
      //     PosColumn(
      //       text: "",
      //       width: 12,
      //       styles: PosStyles(
      //         align: PosAlign.right,
      //       ),
      //     ),
      //   ]);
      // }

      printTxt += generator!.text("Kitchen Receipt\n",
          styles: PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              align: PosAlign.center,
              bold: true));

      // printTxt += generator!.row([
      //   PosColumn(
      //     text: '',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      //   PosColumn(
      //     text: "--------------------------------------------------------------------------------",
      //     width: 10,
      //     styles: PosStyles(
      //       align: PosAlign.center,
      //     ),
      //   ),
      //
      //   PosColumn(
      //     text: '',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.right,
      //     ),
      //   ),
      // ]);

      printTxt += generator!.row([
        PosColumn(
          text: '           ',
          width: 1,
          // styles: PosStyles(
          //   align: PosAlign.left,
          // ),
        ),
        PosColumn(
          text: "ITEMS                          ",
          width: 4,
          // styles: PosStyles(
          //   align: PosAlign.left,
          // ),
        ),
        PosColumn(
          text: '                        ',
          width: 4,
          // styles: PosStyles(
          //   align: PosAlign.center,
          // ),
        ),
        PosColumn(
          text: ' Qty',
          width: 3,
          styles: PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      printTxt += generator!.row([
        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "--------------------------------------------------------------------------------",
          width: 10,
          styles: PosStyles(
            align: PosAlign.center,
          ),
        ),

        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);


      var sum = 0;
      for (var i = 0; i < widget.order.orderMeta!.length; i++) {
        sum = sum + (widget.order.orderMeta![i].qty)!;

        printTxt += generator!.row([
          PosColumn(
            text: '        ',
            width: 1,
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "${widget.order.orderMeta![i].products!.title}               ",
            width: 4,
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: '                  ',
            width: 4,
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: '  ${widget.order.orderMeta![i].qty.toString()}',
            width: 3,
            styles: PosStyles(
              align: PosAlign.right,
            ),
          ),

        ]);


        if (widget.order.orderMeta![i].variantName != null) {

          printTxt += generator!.row([
            PosColumn(
              text: '            ',
              width: 1,
              styles: PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: "(${widget.order.orderMeta![i].variantName})         ",
              width: 4,
              styles: PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: '               ',
              width: 4,
              styles: PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: '           ',
              width: 3,
              styles: PosStyles(
                align: PosAlign.right,
              ),
            ),
          ]);

        }


        if (widget.order.orderMeta![i].orderItemExtras!.isNotEmpty) {
          for (var o = 0;
          o < widget.order.orderMeta![i].orderItemExtras!.length;
          o++) {
            printTxt += generator!.row([
              PosColumn(
                text: '              ',
                width: 1,
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                text: "+ ${widget.order.orderMeta![i].orderItemExtras![o].extraName}          ",
                width: 4,
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                text: '             ',
                width: 4,
                styles: PosStyles(
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                text:
                '                    ',
                width: 3,
                styles: PosStyles(
                  align: PosAlign.right,
                ),
              ),
            ]);
          }
        }


      }


      printTxt += generator!.row([
        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "---------------------------------------------------------",
          width: 10,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),

        PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
      ]);

      printTxt += generator!.row([
        PosColumn(
          text: '           ',
          width: 1,
          // styles: PosStyles(
          //   align: PosAlign.left,
          // ),
        ),
        PosColumn(
          text: "Total Items                          ",
          width: 4,
          // styles: PosStyles(
          //   align: PosAlign.left,
          // ),
        ),
        PosColumn(
          text: '                           ',
          width: 4,
          // styles: PosStyles(
          //   align: PosAlign.center,
          // ),
        ),
        PosColumn(
          text: '  $sum',
          width: 3,
          styles: PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);

      // printTxt += generator!.row([
      //   PosColumn(
      //     text: '',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      //   PosColumn(
      //     text: "---------------------------------------------------------",
      //     width: 10,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      //
      //   PosColumn(
      //     text: '',
      //     width: 1,
      //     styles: PosStyles(
      //       align: PosAlign.left,
      //     ),
      //   ),
      // ]);
      await AppConfig.printerSetupState
          ?.printReceiveTest(printTxt, generator);
      printTxt.clear();


    } on PlatformException {
      String response = 'Failed to get platform version.';
      Fluttertoast.showToast(
          msg: response,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0.sp);
      print(response);
    }
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 20;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 8 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
