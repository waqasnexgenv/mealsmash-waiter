import 'dart:async';
import 'dart:developer';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/config.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/model/Sorder.dart';
import 'package:Mealsmash_Waiter/model/cart_response.dart';
import 'package:Mealsmash_Waiter/model/order.dart';
import 'package:Mealsmash_Waiter/model/tables_response.dart';
import 'package:Mealsmash_Waiter/widgets/custom_circular_button.dart';
import 'package:get/get.dart';

class OrderInfo extends StatefulWidget {
  final CommonController controller;
  final MyTable table;
  String? platform;


  OrderInfo(
      {Key? key, required this.controller, required this.table, this.platform})
      : super(key: key);

  @override
  State<OrderInfo> createState() => _OrderInfoInfoState();
}

class _OrderInfoInfoState extends State<OrderInfo> {
  Timer? timer;
  int _start = 3;
  var kstatus ;
   OrderMeta? item2;
  bool hasZeroKstatus = false;
  var test;
  @override
  Widget build(BuildContext context) {
    print("wwwwwwww                 ${widget.platform}");
    return Drawer(
      child: Container(
        color: widget.controller.isDarkTheme.value
            ? BasicColors.secondaryBlackColor
            : BasicColors.secondSecondaryColor,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: widget.controller.isUpdatingOrder.value,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  vertical: 11.0.sp, horizontal: 5.0.sp),
                              child: Text(
                                '${widget.table.name}',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: BasicColors.getBlackWhiteColor()),
                              ),
                            ),
                          ],
                        ),
                        // order Item List showing
                        Obx(
                          () => widget.table.ongoingOrder == null &&
                                  widget.table.ongoing_order_square == null
                              // || widget.controller.cart.value.cartData == null
                              ? Container(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Center(
                                    child: Text("noDetailsFound".tr),
                                  ),
                                )
                              : AbsorbPointer(
                                  absorbing:
                                      widget.controller.isUpdatingCart.value,
                                  child: widget.table.ongoingOrder == null
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          // padding: EdgeInsets.only(bottom: 150),
                                          itemCount: widget.table
                                                      .ongoing_order_square ==
                                                  null
                                              ? 0
                                              : widget
                                                  .table
                                                  .ongoing_order_square
                                                  ?.orderMeta
                                                  ?.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            Ordermeta item = widget
                                                    .table
                                                    .ongoing_order_square
                                                    ?.orderMeta?[index]
                                                as Ordermeta;
                                            print(
                                                "hanjiii${widget.table.ongoing_order_square!.subtotal.toString()}");
                                            return Column(
                                              children: [
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2,
                                                          horizontal: 10),
                                                  // leading: GestureDetector(
                                                  //   onTap: () {},
                                                  //   child: FadedScaleAnimation(
                                                  //     SizedBox(
                                                  //       width: 60,
                                                  //       height: 100,
                                                  //       child: ClipRRect(
                                                  //           borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(8),
                                                  //           child:
                                                  //           FadedScaleAnimation(
                                                  //             Image.network(
                                                  //               "${item.squareItems!}",
                                                  //               fit: BoxFit.fill,
                                                  //             ),
                                                  //             durationInMilliseconds:
                                                  //             400,
                                                  //           )),
                                                  //     ),
                                                  //     durationInMilliseconds: 400,
                                                  //   ),
                                                  // ),
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "${item.variantName}",
                                                              style: TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 20.sp,
                                                                  color: BasicColors
                                                                      .getBlackWhiteColor()),
                                                            ),
                                                            SizedBox(
                                                              width: 8.w,
                                                            ),
                                                            FadedScaleAnimation(
                                                              Image.asset(
                                                                'assets/ic_veg.png',
                                                                height: 12.h,
                                                              ),
                                                              durationInMilliseconds:
                                                                  400,
                                                            ),
                                                          ],
                                                        ),
                                                        getSquareDeleteBtn(
                                                            item),
                                                      ],
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          item.kStatus != null
                                                              ? (item.kStatus ==
                                                                      0)
                                                                  ? (widget.table.ongoing_order_square
                                                                              ?.paymentStatus !=
                                                                          "1")
                                                                      ?
                                                                      // remove item add and remove container.......
                                                                      // Container(
                                                                      //     padding: EdgeInsets.symmetric(
                                                                      //         vertical:
                                                                      //             6,
                                                                      //         horizontal:
                                                                      //             8),
                                                                      //     decoration: BoxDecoration(
                                                                      //         borderRadius: BorderRadius.circular(
                                                                      //             20),
                                                                      //         border: Border.all(
                                                                      //             color: BasicColors.completedOrderColor,
                                                                      //             width: 0.2)),
                                                                      //     child:
                                                                      //         Row(
                                                                      //       mainAxisSize:
                                                                      //           MainAxisSize.min,
                                                                      //       children: [
                                                                      //         GestureDetector(
                                                                      //             onTap: () async {
                                                                      //               if (item.qty! <= 1) {
                                                                      //                 // Remove Item
                                                                      //                 await widget.controller.removeItemFromOrder(item.id as int);
                                                                      //               } else {
                                                                      //                 await widget.controller.qtyDecrementOrderItem(item.id as int);
                                                                      //               }
                                                                      //             },
                                                                      //             child: Icon(
                                                                      //               Icons.remove,
                                                                      //               color: BasicColors.completedOrderColor,
                                                                      //               size: 18,
                                                                      //             )),
                                                                      //         SizedBox(
                                                                      //           width:
                                                                      //               8,
                                                                      //         ),
                                                                      //         Text(
                                                                      //           "${item.qty}",
                                                                      //           style:
                                                                      //               TextStyle(fontSize: 12, color: BasicColors.getBlackWhiteColor()),
                                                                      //         ),
                                                                      //         SizedBox(
                                                                      //           width:
                                                                      //               8,
                                                                      //         ),
                                                                      //         GestureDetector(
                                                                      //             onTap: () async {
                                                                      //               await widget.controller.qtyIncrementOrderItem(item.id as int);
                                                                      //             },
                                                                      //             child: Icon(
                                                                      //               Icons.add,
                                                                      //               color: BasicColors.completedOrderColor,
                                                                      //               size: 18,
                                                                      //             )),
                                                                      //       ],
                                                                      //     ),
                                                                      //   )
                                                                      // :
                                                                      Text(
                                                                          "Qty: ${item.qty}",
                                                                          style:
                                                                              TextStyle(color: BasicColors.getBlackWhiteColor(),fontSize: 20.sp),
                                                                        )
                                                                      : Container()
                                                                  : Text(
                                                                      "Qty: ${item.qty}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              BasicColors.getBlackWhiteColor(),fontSize: 20.sp),
                                                                    )
                                                              : Text(
                                                                  "Qty: ${item.qty}",
                                                                  style: TextStyle(
                                                                      color: BasicColors
                                                                          .getBlackWhiteColor(),fontSize: 20.sp),
                                                                ),
                                                          Spacer(),
                                                          Text(
                                                            // Config.currencySymbol +
                                                            //     double.parse(
                                                            //             "${(item.variantPrice == null ? item.products!.total.toString() : (double.parse("${item.variantPrice}") + double.parse("${item.products!.total}")))}")
                                                            //         .toStringAsFixed(
                                                            //             Config
                                                            //                 .fractionDigits),
                                                            Config.currencySymbol +
                                                                "${double.parse(item.variantPrice == null ? item.total.toString() : "${item.total}".toString()).toStringAsFixed(Config.fractionDigits)}",
                                                            style: TextStyle(
                                                                color: BasicColors
                                                                    .getBlackWhiteColor(),fontSize: 20.sp),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      // Text(
                                                      //   "Status: ${item.kitchenStatus}",
                                                      //   style: TextStyle(
                                                      //       color: BasicColors
                                                      //           .getBlackWhiteColor()),
                                                      // ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      // widget
                                                      //     .table
                                                      //     .ongoing_order_square
                                                      //     ?.orderMeta !=
                                                      //     null?
                                                      // ListView.builder(
                                                      //     physics:
                                                      //         NeverScrollableScrollPhysics(),
                                                      //     // padding: EdgeInsets.only(bottom: 150),
                                                      //     itemCount: widget
                                                      //                 .table
                                                      //                 .ongoing_order_square
                                                      //                 ?.orderMeta ==
                                                      //             null
                                                      //         ? 0
                                                      //         : widget
                                                      //             .table
                                                      //             .ongoingOrder
                                                      //             ?.orderMeta
                                                      //             ?.length,
                                                      //     shrinkWrap: true,
                                                      //     itemBuilder:
                                                      //         (context, index) {
                                                      //       Ordermeta item = widget
                                                      //               .table
                                                      //               .ongoing_order_square
                                                      //               ?.orderMeta?[
                                                      //           index] as Ordermeta;
                                                      //       return Column(
                                                      //         children: [
                                                      //           Text(
                                                      //               "${item.orderItemExtras![index].extraName.toString()}")
                                                      //         ],
                                                      //       );
                                                      //     }):SizedBox.shrink(),

                                                      // item.variantName == null
                                                      //     ? SizedBox.shrink()
                                                      //     : Row(
                                                      //         children: [
                                                      //           Expanded(
                                                      //             child: Text(
                                                      //               "(${item.variantName})",
                                                      //               style: TextStyle(
                                                      //                   fontSize:
                                                      //                       14,
                                                      //                   color: BasicColors
                                                      //                       .getBlackWhiteColor()),
                                                      //             ),
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      item.orderItemExtras ==
                                                              null
                                                          ? SizedBox.shrink()
                                                          : item.orderItemExtras!
                                                                      .length <
                                                                  1
                                                              ? SizedBox
                                                                  .shrink()
                                                              : buildSquareItemExtras(
                                                                  item.orderItemExtras)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          })
                                      : ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          // padding: EdgeInsets.only(bottom: 150),
                                          itemCount:
                                              widget.table.ongoingOrder == null
                                                  ? 0
                                                  : widget.table.ongoingOrder
                                                      ?.orderMeta?.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                          // List orderlist = widget.table.ongoingOrder?.orderMeta;


                                            OrderMeta item = widget
                                                    .table
                                                    .ongoingOrder
                                                    ?.orderMeta?[index]
                                                as OrderMeta;

                                             test = widget
                                                .table
                                                .ongoingOrder
                                                ?.orderMeta
                                                ?.where((element) => element.kStatus == 1);
                                            // bool hasKstatusOne = item.where((item) => item["kstatus"] == 1).isNotEmpty;
                                            item2 = widget
                                                .table
                                                .ongoingOrder
                                                ?.orderMeta?[index]
                                            as OrderMeta;

                                            //  hasZeroKstatus = item2?.kStatus.contains(0);
                                            print("hasZeroKstatus${test}"); // Output: true

                                            // print("Checking${kstatus}");

                                            // item.any((order) => order["ordermeta"].any((meta) => meta["status"] == 1));
                                            return Column(
                                              children: [
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2,
                                                          horizontal: 10),
                                                  leading: GestureDetector(
                                                    onTap: () {},
                                                    child:
                                                    // FadedScaleAnimation(
                                                      SizedBox(
                                                        width: 50.w,
                                                        height: 50.h,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.sp),
                                                            child:
                                                                // FadedScaleAnimation(
                                                              Image.network(
                                                                "${item.products!.picture}",
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            //   durationInMilliseconds:
                                                            //       400,
                                                            // )
                                                        ),
                                                      ),
                                                    //   durationInMilliseconds:
                                                    //       400,
                                                    // ),
                                                  ),
                                                  title: Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            bottom: 10.0.sp),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width*0.13.w,
                                                              child: Text(
                                                                "${item.products?.title}",
                                                                softWrap: false,

                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                style: TextStyle(


                                                                    fontSize: 18.sp,

                                                                    color: BasicColors
                                                                        .getBlackWhiteColor()),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8.w,
                                                            ),
                                                            // FadedScaleAnimation(
                                                              Image.asset(
                                                                'assets/ic_veg.png',
                                                                height: 16.h,
                                                              ),
                                                            //   durationInMilliseconds:
                                                            //       400,
                                                            // ),
                                                          ],
                                                        ),
                                                        getDeleteBtn(item),
                                                      ],
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          item.kStatus != null
                                                              ? (item.kStatus ==
                                                                      0)
                                                                  ? (widget.table.ongoingOrder
                                                                              ?.paymentStatus !=
                                                                          "1")
                                                                      ?
                                                                      // remove item add and remove container.......
                                                                      // Container(
                                                                      //     padding: EdgeInsets.symmetric(
                                                                      //         vertical:
                                                                      //             6,
                                                                      //         horizontal:
                                                                      //             8),
                                                                      //     decoration: BoxDecoration(
                                                                      //         borderRadius: BorderRadius.circular(
                                                                      //             20),
                                                                      //         border: Border.all(
                                                                      //             color: BasicColors.completedOrderColor,
                                                                      //             width: 0.2)),
                                                                      //     child:
                                                                      //         Row(
                                                                      //       mainAxisSize:
                                                                      //           MainAxisSize.min,
                                                                      //       children: [
                                                                      //         GestureDetector(
                                                                      //             onTap: () async {
                                                                      //               if (item.qty! <= 1) {
                                                                      //                 // Remove Item
                                                                      //                 await widget.controller.removeItemFromOrder(item.id as int);
                                                                      //               } else {
                                                                      //                 await widget.controller.qtyDecrementOrderItem(item.id as int);
                                                                      //               }
                                                                      //             },
                                                                      //             child: Icon(
                                                                      //               Icons.remove,
                                                                      //               color: BasicColors.completedOrderColor,
                                                                      //               size: 18,
                                                                      //             )),
                                                                      //         SizedBox(
                                                                      //           width:
                                                                      //               8,
                                                                      //         ),
                                                                      //         Text(
                                                                      //           "${item.qty}",
                                                                      //           style:
                                                                      //               TextStyle(fontSize: 12, color: BasicColors.getBlackWhiteColor()),
                                                                      //         ),
                                                                      //         SizedBox(
                                                                      //           width:
                                                                      //               8,
                                                                      //         ),
                                                                      //         GestureDetector(
                                                                      //             onTap: () async {
                                                                      //               await widget.controller.qtyIncrementOrderItem(item.id as int);
                                                                      //             },
                                                                      //             child: Icon(
                                                                      //               Icons.add,
                                                                      //               color: BasicColors.completedOrderColor,
                                                                      //               size: 18,
                                                                      //             )),
                                                                      //       ],
                                                                      //     ),
                                                                      //   )
                                                                      // :
                                                                      Text(
                                                                          "Qty: ${item.qty}",
                                                                          style:
                                                                              TextStyle(color: BasicColors.getBlackWhiteColor(),fontSize: 18.sp),
                                                                        )
                                                                      : Container()
                                                                  : Text(
                                                                      "Qty: ${item.qty}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              BasicColors.getBlackWhiteColor(),fontSize: 18.sp),
                                                                    )
                                                              : Text(
                                                                  "Qty: ${item.qty}",
                                                                  style: TextStyle(
                                                                      color: BasicColors
                                                                          .getBlackWhiteColor(),fontSize: 18.sp),
                                                                ),
                                                          Spacer(),
                                                          Text(
                                                            // Config.currencySymbol +
                                                            //     double.parse(
                                                            //             "${(item.variantPrice == null ? item.products!.total.toString() : (double.parse("${item.variantPrice}") + double.parse("${item.products!.total}")))}")
                                                            //         .toStringAsFixed(
                                                            //             Config
                                                            //                 .fractionDigits),
                                                            Config.currencySymbol +
                                                                "${double.parse(item.variantPrice == null ? item.total.toString() : (double.parse("${item.products!.total}") + double.parse("${item.variantPrice}")).toString()).toStringAsFixed(Config.fractionDigits)}",
                                                            style: TextStyle(
                                                                color: BasicColors
                                                                    .getBlackWhiteColor(),fontSize: 18.sp),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      // Text(
                                                      //   "Status: ${item.kitchenStatus}",
                                                      //   style: TextStyle(
                                                      //       color: BasicColors
                                                      //           .getBlackWhiteColor()),
                                                      // ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      item.variantName == null
                                                          ? SizedBox.shrink()
                                                          : Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    "(${item.variantName})",
                                                                    style: TextStyle(
                                                                        fontSize: 16.sp,
                                                                        color: BasicColors
                                                                            .getBlackWhiteColor()),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                      item.orderItemExtras ==
                                                              null
                                                          ? SizedBox.shrink()
                                                          : item.orderItemExtras!
                                                                      .length <
                                                                  1
                                                              ? SizedBox
                                                                  .shrink()
                                                              : buildItemExtras(
                                                                  item.orderItemExtras)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                ),
                        ),
                      ],
                    ),
                  ),
                  (widget.controller.isUpdatingOrder.value)
                      ? kLoadingWidget()
                      : Container(),
                  // (widget.controller.isUpdatingCart.value)
                  //     ? kLoadingWidget()
                  //     : Container(),
                ],
              ),
            ),
            // (widget.table.ongoingOrder == null &&
            //         widget.table.ongoingOrder == null)
            //     // ||
            //     //         widget.controller.cart.value.cartData == null)
            //     ? SizedBox.shrink()
            //     :
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: BasicColors.getWhiteBlackColor(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (widget.controller.isUpdatingOrder.value)
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                        "subTotal".tr,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color:
                                                BasicColors.getBlackWhiteColor())),
                                    Text("Tax".tr,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color:
                                            BasicColors.getBlackWhiteColor())),
                                  ],
                                ),
                                trailing: widget.table.ongoingOrder == null
                                    ? Text(
                                        Config.currencySymbol +
                                            "${
                                            // (
                                            double.parse(widget.table.ongoing_order_square!.subtotal.toString())
                                            // double.parse(widget.controller.cart.value.subtotal!.toString())
                                            // + (widget.controller.cart.value.subtotal != null ? double.parse(widget.controller.cart.value.subtotal!.toString()) : double.parse("0.0")))
                                            }",
                                        style: TextStyle(
                                            color: BasicColors
                                                .getBlackWhiteColor(),fontSize: 22.sp),
                                      )
                                    : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Text(
                                            Config.currencySymbol +
                                                "${
                                                // (
                                                double.parse(widget.table.ongoingOrder!.subtotal.toString())
                                                // double.parse(widget.controller.cart.value.subtotal!.toString())
                                                // + (widget.controller.cart.value.subtotal != null ? double.parse(widget.controller.cart.value.subtotal!.toString()) : double.parse("0.0")))
                                                }",
                                            style: TextStyle(
                                                color: BasicColors
                                                    .getBlackWhiteColor(),fontSize: 18.sp),
                                          ),
                                        Text(
                                          Config.currencySymbol +
                                              "${
                                              // (
                                                  double.parse(widget.table.ongoingOrder!.tax.toString())
                                              // double.parse(widget.controller.cart.value.subtotal!.toString())
                                              // + (widget.controller.cart.value.subtotal != null ? double.parse(widget.controller.cart.value.subtotal!.toString()) : double.parse("0.0")))
                                              }",
                                          style: TextStyle(
                                              color: BasicColors
                                                  .getBlackWhiteColor(),fontSize: 18.sp),
                                        ),
                                      ],
                                    ),
                              ),

                              // calling place order
                              // Obx(
                              //   () => CustomButton(
                              //     onTap: () async {
                              //       if (widget.controller.isUpdatingCart
                              //               .value ||
                              //           widget
                              //               .controller
                              //               .isDoingCartIncrementDecrement
                              //               .value) {
                              //       } else {
                              //         if (!widget.controller
                              //             .isPlacingOrder.value) {
                              //           widget.controller.isPlacingOrder
                              //               .value = true;
                              //
                              //           // var res =
                              //           await widget.controller
                              //               .addToOrder(
                              //                   orderId: widget.table
                              //                       .ongoingOrder!.id);
                              //
                              //           // var res = await widget.controller
                              //           //     .placeOrder(widget.table.id
                              //           //         .toString());
                              //           //  log("resdf  ${res.runtimeType}");
                              //           // log(res);
                              //           // if (res is Map) {
                              //           //   Get.back();
                              //           //   Get.toNamed(
                              //           //       PageRoutes.orderPlacedPage,
                              //           //       arguments: [res]);
                              //           //   widget.controller.cart.value =
                              //           //       CartResponse();
                              //           // }
                              //
                              //           widget.controller.isPlacingOrder
                              //               .value = false;
                              //         } else {
                              //           widget.controller.isPlacingOrder
                              //               .value = false;
                              //         }
                              //       }
                              //     },
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 40, vertical: 20),
                              //     bgColor: widget
                              //             .controller.isUpdatingCart.value
                              //         ? BasicColors.secondaryColor
                              //         : widget
                              //                 .controller
                              //                 .isDoingCartIncrementDecrement
                              //                 .value
                              //             ? BasicColors.secondaryColor
                              //             : BasicColors.primaryColor,
                              //     title: (widget.controller.isPlacingOrder
                              //             .value)
                              //         ? kLoadingWidget(
                              //             loaderColor: BasicColors.white)
                              //         : Padding(
                              //             padding:
                              //                 const EdgeInsets.symmetric(
                              //                     vertical: 5),
                              //             child: Text(
                              //               "finishOrdering".tr,
                              //               style: TextStyle(
                              //                   fontSize: 16,
                              //                   color: BasicColors.white),
                              //             ),
                              //           ),
                              //     borderRadius: 0,
                              //   ),
                              // )
                            ],
                          ),
                    // widget.table.ongoingOrder!.orderMeta!.length < 1 ||
                    //         widget.table.ongoing_order_square!.orderMeta!
                    //                 .length <
                    //             1
                    //     ?


    item2?.kStatus != null ?test.isEmpty?
    item2?.kStatus == 0?
    widget.table.ongoingOrder?.paymentStatus != "1"?
                          CustomButton(
                        onTap: (){
                          Get.back();
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
                                                                                            widget.table.ongoingOrder == null
                                                                                                  ? await widget.controller.cancelOrder(
                                                                                                      "${widget.table.ongoing_order_square!.id.toString()}")
                                                                                                  : await widget.controller.cancelOrder(
                                                                                                      "${widget.table.ongoingOrder!.id.toString()}");
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
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal: 260),
                          //         child: Dialog(
                          //             shape: RoundedRectangleBorder(
                          //                 borderRadius:
                          //                 BorderRadius.circular(4.0)),
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
                          //                     const EdgeInsets.fromLTRB(
                          //                         10, 20, 10, 10),
                          //                     child: Column(
                          //                       children: [
                          //                         // SizedBox(
                          //                         //   height: 10,
                          //                         // ),
                          //                         Spacer(),
                          //                         Text(
                          //                           "Cancel Order".tr,
                          //                           style: TextStyle(
                          //                               fontWeight:
                          //                               FontWeight.bold,
                          //                               fontSize: 18.sp),
                          //                         ),
                          //                         // Spacer(),
                          //                         // SizedBox(height: 10),
                          //                         Text(
                          //                           "doYouWantToCancelOrder".tr,
                          //                           style:
                          //                           TextStyle(fontSize: 18.sp),
                          //                         ),
                          //                         Spacer(),
                          //                         // SizedBox(height: 30),
                          //                         Row(
                          //                           mainAxisAlignment:
                          //                           MainAxisAlignment.center,
                          //                           crossAxisAlignment:
                          //                           CrossAxisAlignment.center,
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
                          //                               decoration:
                          //                               BoxDecoration(
                          //                                 color: BasicColors
                          //                                     .primaryColor,
                          //                                 borderRadius:
                          //                                 BorderRadius.circular(
                          //                                     MediaQuery.of(
                          //                                         context)
                          //                                         .size
                          //                                         .width *
                          //                                         0.03.w),
                          //                               ),
                          //                               child: TextButton(
                          //                                 child: Text("no".tr,
                          //                                     style: TextStyle(
                          //                                         color: BasicColors
                          //                                             .white,fontSize: 24.sp)),
                          //                                 onPressed: () {
                          //                                   Get.back();
                          //                                 },
                          //                               ),
                          //                             ),
                          //                             SizedBox(
                          //                               width: MediaQuery.of(
                          //                                   context)
                          //                                   .size
                          //                                   .width *
                          //                                   0.02.w,
                          //                             ),
                          //                             Container(
                          //                               width: MediaQuery
                          //                                   .of(context)
                          //                                   .size
                          //                                   .width * 0.1.w,
                          //                               height: MediaQuery
                          //                                   .of(context)
                          //                                   .size
                          //                                   .height * 0.13.h,
                          //                               decoration:
                          //                               BoxDecoration(
                          //                                 color: BasicColors
                          //                                     .primaryColor,
                          //                                 borderRadius:
                          //                                 BorderRadius.circular(
                          //                                     MediaQuery.of(
                          //                                         context)
                          //                                         .size
                          //                                         .width *
                          //                                         0.03.w),
                          //                               ),
                          //                               child: TextButton(
                          //                                 child: Text("yes".tr,
                          //                                     style: TextStyle(
                          //                                         color: BasicColors
                          //                                             .white,fontSize: 18.sp)),
                          //                                 onPressed: () async {
                          //                                   Get.back();
                          //                                   widget.table.ongoingOrder == null
                          //                                         ? await widget.controller.cancelOrder(
                          //                                             "${widget.table.ongoing_order_square!.id.toString()}")
                          //                                         : await widget.controller.cancelOrder(
                          //                                             "${widget.table.ongoingOrder!.id.toString()}");
                          //                                 },
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 // Positioned(
                          //                 //     top: MediaQuery.of(context)
                          //                 //         .size
                          //                 //         .width *
                          //                 //         -0.03.w,
                          //                 //     child: CircleAvatar(
                          //                 //       backgroundColor:
                          //                 //       Colors.redAccent,
                          //                 //       radius: MediaQuery.of(context)
                          //                 //           .size
                          //                 //           .width *
                          //                 //           0.03.w,
                          //                 //       child: Icon(
                          //                 //         Icons.warning_amber_rounded,
                          //                 //         color: Colors.white,
                          //                 //         size: MediaQuery.of(context)
                          //                 //             .size
                          //                 //             .width *
                          //                 //             0.03.w,
                          //                 //       ),
                          //                 //     )),
                          //               ],
                          //             )),
                          //       );
                          //     });
                        },







                        // onTap: () async {
                        //   widget.table.ongoingOrder == null
                        //       ? await widget.controller.cancelOrder(
                        //           "${widget.table.ongoing_order_square!.id.toString()}")
                        //       : await widget.controller.cancelOrder(
                        //           "${widget.table.ongoingOrder!.id.toString()}");
                        // },
                        padding:
                            EdgeInsets.symmetric(horizontal: 30.sp, vertical: 16.sp),
                        bgColor: BasicColors.primaryColor,
                        title: (widget.controller.isCancelingOrder.value)
                            ? kLoadingWidget(loaderColor: BasicColors.white)
                            : Padding(
                                padding:
                                     EdgeInsets.symmetric(vertical: 5.sp),
                                child: Text(
                                  "cancelOrder".tr,
                                  style: TextStyle(
                                      fontSize: 18.sp, color: BasicColors.white),
                                ),
                              ),
                        borderRadius: 0,
                      ):Container():Container():Container():Container(),

                    // : SizedBox.shrink()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItemsInCartButton({required CommonController controller}) {
    return Obx(() {
      int cartCount = 0;
      if (controller.cart.value.cartData == null) {
        cartCount = 0;
      } else {
        cartCount = controller.cart.value.cartData!.length;
      }
      return CustomButton(
        onTap: () {
          controller.getCart(widget.table.id.toString());
        },
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        title: Text(
          "itemsInCart".tr + " (${cartCount.toString()})",
          style: TextStyle(color: BasicColors.white),
        ),
        bgColor: cartCount == 0
            ? BasicColors.secondaryColor
            : BasicColors.primaryColor,
      );
    });
  }

  Widget buildSquareItemExtras(List<OrderItemExtras>? orderItemExtra) {
    List<Widget> extras = <Widget>[];

    orderItemExtra!.forEach((extra) {
      extras.add(Row(
        children: [
          Text(
            "${extra.extraName}",
            style: TextStyle(
                fontSize: 20.sp, color: BasicColors.getBlackWhiteColor()),
          ),
          Spacer(),
          Text(
              Config.currencySymbol +
                  double.parse("${extra.extraPrice}")
                      .toStringAsFixed(Config.fractionDigits),
              style: TextStyle(color: BasicColors.getBlackWhiteColor(),fontSize: 20.sp))
        ],
      ));
    });

    return Column(
      children: extras,
    );
  }

  Widget buildItemExtras(List<OrderItemExtra>? orderItemExtra) {
    List<Widget> extras = <Widget>[];

    orderItemExtra!.forEach((extra) {
      extras.add(Row(
        children: [
          Text(
            "${extra.extraName}",
            style: TextStyle(
                fontSize: 18.sp, color: BasicColors.getBlackWhiteColor()),
          ),
          Spacer(),
          Text(
              Config.currencySymbol +
                  double.parse("${extra.extraPrice}")
                      .toStringAsFixed(Config.fractionDigits),
              style: TextStyle(color: BasicColors.getBlackWhiteColor(),fontSize: 18.sp))
        ],
      ));
    });

    return Column(
      children: extras,
    );
  }

  Widget buildCartItemExtras(List<CartItemExtra>? cartItemExtras) {
    List<Widget> extras = <Widget>[];

    cartItemExtras!.forEach((extra) {
      extras.add(Row(
        children: [
          Text(
            "${extra.extraName}",
            style: TextStyle(
                fontSize: 22.sp, color: BasicColors.getBlackWhiteColor()),
          ),
          Spacer(),
          Text(
              Config.currencySymbol +
                  double.parse("${extra.extraPrice}")
                      .toStringAsFixed(Config.fractionDigits),
              style: TextStyle(color: BasicColors.getBlackWhiteColor(),fontSize: 22.sp))
        ],
      ));
    });

    return Column(
      children: extras,
    );
  }

  getSquareDeleteBtn(Ordermeta item) {
    if (item.kStatus != null) {
      if (item.kStatus == 0) {
        if (widget.table.ongoing_order_square?.paymentStatus != "1") {
          return GestureDetector(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 260),
                      child: Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Stack(
                            clipBehavior: Clip.none,
                            // overflow: Overflow.visible,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height* 0.5.h,
                                width: MediaQuery.of(context).size.width* 0.6.w,
                                // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.48: MediaQuery.of(context).size.height*0.25,
                                // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.96:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.45: MediaQuery.of(context).size.width*0.3,

                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "alert".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.sp,
                                            color: BasicColors.black),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        "youWantToDelete".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22.sp,
                                            color: BasicColors.black),
                                      ),
                                      Spacer(),
                                      // SizedBox(
                                      //   height: 30.h,
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.1.w,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.13.h,
                                                decoration: BoxDecoration(
                                                  color: BasicColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03.w),
                                                ),
                                                child: TextButton(
                                                  child: Text("no".tr,
                                                      style: TextStyle(
                                                          color:
                                                              BasicColors.white)),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.1.w,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.13.h,
                                                decoration: BoxDecoration(
                                                  color: BasicColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03.w),
                                                ),
                                                child: TextButton(
                                                  child: Text("yes".tr,
                                                      style: TextStyle(
                                                          color:
                                                              BasicColors.white)),
                                                  onPressed: () async {
                                                    Get.back();
                                                    await widget.controller
                                                        .removeItemFromOrder(
                                                            item.id as int);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: MediaQuery.of(context).size.width * -0.03.w,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    radius:
                                        MediaQuery.of(context).size.width * 0.03.w,
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.width *
                                          0.03.w,
                                    ),
                                  )),
                            ],
                          )),
                    );
                  });
            },
            child: Icon(
              Icons.delete,
              size: 25.sp,
              color: BasicColors.getBlackWhiteColor(),
            ),
          );
        }
      }
    }
    return SizedBox.shrink();
  }

  getDeleteBtn(OrderMeta item) {
    if (item.kStatus != null) {
      if (item.kStatus == 0) {
        if (widget.table.ongoingOrder?.paymentStatus != "1") {
          return GestureDetector(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 260),
                      child: Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Stack(
                            clipBehavior: Clip.none,
                            // overflow: Overflow.visible,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height* 0.5.h,
                                width: MediaQuery.of(context).size.width* 0.6.w,
                                // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.48: MediaQuery.of(context).size.height*0.25,
                                // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.96:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.45: MediaQuery.of(context).size.width*0.3,

                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      // SizedBox(
                                      //   height: 10.h,
                                      // ),
                                      Text(
                                        "alert".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.sp,
                                            color: BasicColors.black),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        "youWantToDelete".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22.sp,
                                            color: BasicColors.black),
                                      ),
                                      Spacer(),
                                      // SizedBox(
                                      //   height: 30.h,
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.1.w,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.13.h,
                                                decoration: BoxDecoration(
                                                  color: BasicColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03.w),
                                                ),
                                                child: TextButton(
                                                  child: Text("no".tr,
                                                      style: TextStyle(
                                                          color:
                                                              BasicColors.white,fontSize: 22.sp)),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.1.w,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.13.h,
                                                decoration: BoxDecoration(
                                                  color: BasicColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03.w),
                                                ),
                                                child: TextButton(
                                                  child: Text("yes".tr,
                                                      style: TextStyle(
                                                          color:
                                                              BasicColors.white,fontSize: 22.sp)),
                                                  onPressed: () async {
                                                    Get.back();
                                                    await widget.controller
                                                        .removeItemFromOrder(
                                                            item.id as int);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: MediaQuery.of(context).size.width * -0.03.w,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    radius:
                                        MediaQuery.of(context).size.width * 0.03.w,
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.width *
                                          0.03.w,
                                    ),
                                  )),
                            ],
                          )),
                    );
                  });
            },
            child: Container(
              // color: Colors.yellow,
              height: 40.h,
              width: 40.w,
              child: Icon(
                Icons.delete,
                size: 18.sp,
                color: BasicColors.getBlackWhiteColor(),
              ),
            ),
          );
        }
      }
    }
    return SizedBox.shrink();
  }

  void cancelTimer() {
    if (timer != null) {
      widget.controller.isDoingCartIncrementDecrement.value = false;
      log("Cancel Timer Called");
      timer!.cancel();
      timer = null;
    }
  }

  void updateQty(CartItem item, int index) {
    widget.controller.isDoingCartIncrementDecrement.value = true;
    if (timer == null) {
      widget.controller.previousClickedCartItem = item.toJson();
      widget.controller.previousClickedCartItemIndex = index;
      log("Timer Null");
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          if (_start == 0) {
            widget.controller.updateCartItemQty(
              tableId: widget.table.id.toString(),
              cartItemId: widget
                  .controller
                  .cart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .id as int,
              productId: widget
                  .controller
                  .cart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .productId as int,
              qty: double.parse(
                  "${widget.controller.cart.value.cartData![widget.controller.previousClickedCartItemIndex as int].qty.toString()}"),
            );
            cancelTimer();
            setState(() {});
          } else {
            _start--;
          }
        },
      );
    }
    CartItem oldItem = CartItem(id: -1);
    if (widget.controller.previousClickedCartItem != null) {
      oldItem =
          CartItem.fromJson("${widget.controller.previousClickedCartItem}");
    }

    // if previous item clicked increase 3 seconds
    if (item.id == oldItem.id) {
      log("Cart -- same Item Clicked Again");
      setState(() {
        _start = 3;
      });
    } else {
      // If different item clicked update previous item and cancel timer start a new timer.
      log("Cart -- Different Item Clicked");
      cancelTimer();
      widget.controller.updateCartItemQty(
        tableId: widget.table.id.toString(),
        cartItemId: widget
            .controller
            .cart
            .value
            .cartData?[widget.controller.previousClickedCartItemIndex as int]
            .id as int,
        productId: widget
            .controller
            .cart
            .value
            .cartData?[widget.controller.previousClickedCartItemIndex as int]
            .productId as int,
        qty: double.parse(
            "${widget.controller.cart.value.cartData![widget.controller.previousClickedCartItemIndex as int].qty.toString()}"),
      );
      widget.controller.previousClickedCartItem = item.toJson();
      widget.controller.previousClickedCartItemIndex = index;
      log("Timer Null");
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          if (_start == 0) {
            widget.controller.updateCartItemQty(
              tableId: widget.table.id.toString(),
              cartItemId: widget
                  .controller
                  .cart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .id as int,
              productId: widget
                  .controller
                  .cart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .productId as int,
              qty: double.parse(
                  "${widget.controller.cart.value.cartData![widget.controller.previousClickedCartItemIndex as int].qty.toString()}"),
            );
            cancelTimer();
            setState(() {});
          } else {
            _start--;
          }
        },
      );
    }
  }
}
