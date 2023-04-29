import 'dart:async';
import 'dart:developer';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/config.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/model/Scart.dart';
import 'package:Mealsmash_Waiter/model/cart_response.dart';
import 'package:Mealsmash_Waiter/model/tables_response.dart';
import 'package:Mealsmash_Waiter/widgets/custom_circular_button.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartInfo extends StatefulWidget {
  final CommonController controller;
  final MyTable table;
  final scaffoldKey;
  final tableId;
  final orderType;
  final platform;

  CartInfo(
      {Key? key,
      required this.controller,
      required this.table,
      this.scaffoldKey,
      this.tableId,
      this.orderType,
      this.platform})
      : super(key: key);

  @override
  State<CartInfo> createState() => _CartInfoState();
}

class _CartInfoState extends State<CartInfo> {
  final CommonController controller = Get.find<CommonController>();
  Timer? timer;
  int _start = 3;

  // var pref;
  var platform;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   Configure();
  //   print("dsfsdffsd${platform}");
  //   // controller.getCart(widget.tableId.toString());
  // }

  // Configure() async {
  //   pref = await SharedPreferences.getInstance();
  //   platform = pref.getString('platform_configured');
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 2.5.w,
      child: Drawer(
        child: Container(
          color: widget.controller.isDarkTheme.value
              ? BasicColors.secondaryBlackColor
              : BasicColors.secondSecondaryColor,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  vertical: 20.0.h, horizontal: 5.0.w),
                              child: widget.table.name == null
                                  ? Text(
                                      'Take away',
                                      style: TextStyle(
                                        fontSize: 19.sp,
                                        fontWeight: FontWeight.bold,
                                        color: BasicColors.getBlackWhiteColor(),
                                      ),
                                    )
                                  : Text(
                                      '${widget.table.name}',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: BasicColors.getBlackWhiteColor(),
                                      ),
                                    ),
                            ),
                            Spacer(),
                            widget.platform == "SQUARE"
                                ? buildSquareItemsInCartButton(
                                    controller: widget.controller)
                                : buildItemsInCartButton(
                                    controller: widget.controller),
                          ],
                        ),
                        widget.platform == "SQUARE"
                            ? Obx(
                                () => widget.controller.scart.value.cartData ==
                                        null
                                    ? Container(
                                        padding: EdgeInsets.only(top: 30.h),
                                        child: Center(
                                          child: Text(
                                            "cartIsEmpty".tr,
                                            style: TextStyle(fontSize: 22.sp, color: BasicColors
                                                .getBlackWhiteColor(), ),
                                          ),
                                        ),
                                      )
                                    // controller.selectedCategoryIndex.value == widget.controller.cart.value.cartData?
                                    : AbsorbPointer(
                                        absorbing: widget
                                            .controller.isUpdatingCart.value,
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding:
                                                EdgeInsets.only(bottom: 100.h),
                                            itemCount: widget.controller.scart
                                                .value.cartData!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              CartDatumm item = widget
                                                  .controller
                                                  .scart
                                                  .value
                                                  .cartData![index];
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.w,
                                                            horizontal: 10.h),
                                                    leading: GestureDetector(
                                                      onTap: () {},
                                                      child:
                                                          FadedScaleAnimation(
                                                        SizedBox(
                                                          width: 60.w,
                                                          height: 100.h,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.sp),
                                                            child:
                                                                FadedScaleAnimation(
                                                              Image.network(
                                                                "${item.image}",
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              durationInMilliseconds:
                                                                  400,
                                                            ),
                                                          ),
                                                        ),
                                                        durationInMilliseconds:
                                                            400,
                                                      ),
                                                    ),
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
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                "${item.name}",
                                                                style:
                                                                    TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize:
                                                                      20.sp,
                                                                  color: BasicColors
                                                                      .getBlackWhiteColor(),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8.w,
                                                              ),
                                                              FadedScaleAnimation(
                                                                Image.asset(
                                                                  'assets/ic_veg.png',
                                                                  height: 20.h,
                                                                ),
                                                                durationInMilliseconds:
                                                                    400,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          6,
                                                                      horizontal:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                border: Border.all(
                                                                    color: BasicColors
                                                                        .completedOrderColor,
                                                                    width: 0.2),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      log("Decrease Qty Clicked");
                                                                      widget
                                                                          .controller
                                                                          .scart
                                                                          .value
                                                                          .cartData![
                                                                              index]
                                                                          .quantity = item
                                                                              .quantity! -
                                                                          1;
                                                                      cancelTimer();

                                                                      setState(
                                                                          () {});
                                                                      if (double.parse(
                                                                              "${item.quantity.toString()}") <
                                                                          1) {
                                                                        cancelTimer();
                                                                        setState(
                                                                            () {});
                                                                        await widget.controller.SqremoveCartItem(
                                                                            tableId:
                                                                                widget.tableId.toString(),
                                                                            cartItemId: item.id!);
                                                                        setState(
                                                                            () {});
                                                                        widget
                                                                            .controller
                                                                            .scart
                                                                            .value
                                                                            .cartData!
                                                                            .removeAt(index);

                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        setState(
                                                                            () {});
                                                                        SQupdateQty(
                                                                            widget.controller.scart.value.cartData![index],
                                                                            index);
                                                                      }
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: BasicColors
                                                                          .completedOrderColor,
                                                                      size:
                                                                          29.sp,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Text(
                                                                    "${item.quantity}",
                                                                    style: TextStyle(
                                                                        fontSize: 20
                                                                            .sp,
                                                                        color: BasicColors
                                                                            .getBlackWhiteColor()),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 12.w,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      widget
                                                                          .controller
                                                                          .scart
                                                                          .value
                                                                          .cartData![
                                                                              index]
                                                                          .quantity = item
                                                                              .quantity! +
                                                                          1;

                                                                      setState(
                                                                          () {});
                                                                      SQupdateQty(
                                                                          widget
                                                                              .controller
                                                                              .scart
                                                                              .value
                                                                              .cartData![index],
                                                                          index);
                                                                    },
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color: BasicColors
                                                                          .completedOrderColor,
                                                                      size:
                                                                          29.sp,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              Config.currencySymbol +
                                                                  "${double.parse(item.price == null ? item.total.toString() : (item.total!).toString()).toStringAsFixed(Config.fractionDigits)}",
                                                              style: TextStyle(
                                                                  color: BasicColors
                                                                      .getBlackWhiteColor(),
                                                                  fontSize:
                                                                      20.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),

                                                        ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: item
                                                              .squareCarItemModifiers
                                                              ?.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, ind) {
                                                            return Row(
                                                              children: [
                                                                Text(
                                                                  item
                                                                      .squareCarItemModifiers![
                                                                          ind]
                                                                      .name
                                                                      .toString(),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle1
                                                                      ?.copyWith(
                                                                          fontSize:
                                                                              20.sp),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  '\$' +
                                                                      item
                                                                          .squareCarItemModifiers![
                                                                              ind]
                                                                          .amount
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20.sp),
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                        // item.squareCarItemModifiers ==
                                                        //         null
                                                        //     ? SizedBox.shrink()
                                                        //     : Row(
                                                        //         children: [
                                                        //           Expanded(
                                                        //             child: Text(
                                                        //               "(${item.squareCarItemModifiers.name})",
                                                        //               style: TextStyle(
                                                        //                   fontSize:
                                                        //                       14,
                                                        //                   color: BasicColors
                                                        //                       .getBlackWhiteColor()),
                                                        //             ),
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        // item.cartItemExtras == null
                                                        //     ? SizedBox.shrink()
                                                        //     : item.cartItemExtras!
                                                        //     .length <
                                                        //     1
                                                        //     ? SizedBox.shrink()
                                                        //     : buildItemExtras(
                                                        //     item.cartItemExtras)
                                                      ],
                                                    ),
                                                  ),
                                                  // SizedBox(height: 200,),
                                                ],
                                              );
                                            }),
                                      ),
                              )
                            : Obx(
                                () => widget.controller.cart.value.cartData ==
                                        null
                                    ? Container(
                                        padding: EdgeInsets.only(top: 30.sp),
                                        child: Center(
                                          child: Text(
                                            "cartIsEmpty".tr,
                                            style: TextStyle(fontSize: 18.sp,color: BasicColors.getBlackWhiteColor() ),),),
                                      )
                                    // controller.selectedCategoryIndex.value == widget.controller.cart.value.cartData?
                                    : AbsorbPointer(
                                        absorbing: widget
                                            .controller.isUpdatingCart.value,
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding:
                                                EdgeInsets.only(bottom: 150),
                                            itemCount: widget.controller.cart
                                                .value.cartData!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              CartItem item = widget.controller
                                                  .cart.value.cartData![index];
                                              // final items = widget.controller.cart
                                              //     .value.cartData![index];
                                              return Dismissible(
                                                // key: Key(item.id.toString()),
                                                key: UniqueKey(),
                                                direction: DismissDirection.endToStart,
                                                background: Container(
                                                  color: Colors.red,
                                                  alignment: Alignment.centerRight,
                                                  child: Icon(Icons.delete, color: Colors.white),
                                                ),
                                                onDismissed: (direction) async {
                                                  setState(() {
                                                    widget.controller
                                                        .cart.value.cartData?.removeAt(index);
                                                  });


                                                  widget.controller.removeCartItem(
                                                      tableId:
                                                      widget.tableId.toString(),
                                                      cartItemId: item.id!);





                                                  // Fluttertoast.showToast(
                                                  //     msg: "item removed from cart",
                                                  //     toastLength: Toast.LENGTH_SHORT,
                                                  //     gravity: ToastGravity.CENTER,
                                                  //     timeInSecForIosWeb: 1,
                                                  //     backgroundColor: Colors.red,
                                                  //     textColor: Colors.white,
                                                  //     fontSize: 12.sp);
                                                  // Remove the item from the list.

                                                },
                                                child: Column(
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
                                                                          8.sp),
                                                              child:
                                                                  // FadedScaleAnimation(
                                                                Image.network(
                                                                  "${item.picture}",
                                                                  fit:
                                                                      BoxFit.fill,
                                                                ),
                                                                // durationInMilliseconds:
                                                                //     400,
                                                              // ),
                                                            ),
                                                          ),
                                                          // durationInMilliseconds:
                                                          //     400,
                                                        // ),
                                                      ),
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
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.13.w,
                                                                  child: Text(
                                                                    item.title
                                                                        .toString(),
                                                                    softWrap:
                                                                        true,
                                                                    style: TextStyle(
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        fontSize:
                                                                            18.sp,
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
                                                                    height: 18.h,
                                                                  ),
                                                                  // durationInMilliseconds:
                                                                  //     400,
                                                                // ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            4.sp,
                                                                        horizontal:
                                                                            10.sp),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.sp),
                                                                  border: Border.all(
                                                                      color: BasicColors
                                                                          .completedOrderColor,
                                                                      width:
                                                                          0.2.w),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        log("Decrease Qty Clicked");

                                                                        widget
                                                                            .controller
                                                                            .cart
                                                                            .value
                                                                            .cartData![
                                                                                index]
                                                                            .qty = (int.parse(item.qty as String) -
                                                                                1)
                                                                            .toString();
                                                                        cancelTimer();

                                                                        setState(
                                                                            () {});
                                                                        if (double.parse(
                                                                                "${item.qty.toString()}") <
                                                                            1) {
                                                                          cancelTimer();
                                                                          setState(
                                                                              () {});
                                                                          await widget.controller.removeCartItem(
                                                                              tableId:
                                                                                  widget.tableId.toString(),
                                                                              cartItemId: item.id!);
                                                                          setState(
                                                                              () {});
                                                                          // widget
                                                                          //     .controller
                                                                          //     .cart
                                                                          //     .value
                                                                          //     .cartData!
                                                                          //     .removeAt(
                                                                          //         index);
                                                                          // setState(
                                                                          //     () {});
                                                                        } else {
                                                                          setState(
                                                                              () {});
                                                                          updateQty(
                                                                              widget.controller.cart.value.cartData![index],
                                                                              index);
                                                                        }
                                                                      },
                                                                      child: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: BasicColors
                                                                            .completedOrderColor,
                                                                        size:
                                                                            22.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 11.w,
                                                                    ),
                                                                    Text(
                                                                      "${item.qty}",
                                                                      style: TextStyle(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: BasicColors
                                                                              .getBlackWhiteColor()),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 11.w,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        var quantity = widget
                                                                            .controller
                                                                            .cart
                                                                            .value
                                                                            .cartData![
                                                                                index]
                                                                            .term
                                                                            ?.price
                                                                            ?.quantity?.toInt();
                                                                        log("increase Qty Clicked ${quantity}");

                                                                        widget
                                                                            .controller
                                                                            .cart
                                                                            .value
                                                                            .cartData![
                                                                                index]
                                                                            .qty = (int.parse(item.qty as String) +
                                                                                1)
                                                                            .toString();

                                                                        setState(
                                                                            () {});
                                                                        var qty =double.parse(widget.controller.cart.value.cartData![index].qty.toString());
                                                                        log(qty.toString());
                                                                        if(qty  < quantity!){
                                                                          log("true");
                                                                          updateQty(
                                                                              widget
                                                                                  .controller
                                                                                  .cart
                                                                                  .value
                                                                                  .cartData![index],
                                                                              index);
                                                                        }
                                                                        else{
                                                                          Fluttertoast.showToast(
                                                                              msg:
                                                                              "Quantity Exceeded",
                                                                              toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                              gravity:
                                                                              ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor:
                                                                              Colors.red,
                                                                              textColor: Colors.white,
                                                                              fontSize: 12.0.sp);
                                                                          log("Quantity cannot exceed");
                                                                          widget.controller.cart.value.cartData![index].qty = widget.controller.cart.value.cartData![index].term?.price?.quantity.toString();
                                                                          updateQty(
                                                                              widget
                                                                                  .controller
                                                                                  .cart
                                                                                  .value
                                                                                  .cartData![index],
                                                                              index);

                                                                          // setState(() {
                                                                          //   quantity = qty;
                                                                          // });
                                                                        }
                                                                        // updateQty(
                                                                        //     widget
                                                                        //         .controller
                                                                        //         .cart
                                                                        //         .value
                                                                        //         .cartData![index],
                                                                        //     index);
                                                                      },
                                                                      child: Icon(
                                                                        Icons.add,
                                                                        color: BasicColors
                                                                            .completedOrderColor,
                                                                        size:
                                                                            22.sp,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                Config.currencySymbol +
                                                                    "${item.variantPrice == null ? item.total : (double.parse(item.price!.toString()) + double.parse(item.variantPrice.toString())).toStringAsFixed(Config.fractionDigits)}",
                                                                style: TextStyle(
                                                                    color: BasicColors
                                                                        .getBlackWhiteColor(),
                                                                    fontSize:
                                                                        10.sp),
                                                              ),
                                                            ],
                                                          ),
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
                                                                            fontSize: 12
                                                                                .sp,
                                                                            color:
                                                                                BasicColors.getBlackWhiteColor()),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                          item.cartItemExtras ==
                                                                  null
                                                              ? SizedBox.shrink()
                                                              : item.cartItemExtras!
                                                                          .length <
                                                                      1
                                                                  ? SizedBox
                                                                      .shrink()
                                                                  : buildItemExtras(
                                                                      item.cartItemExtras)
                                                        ],
                                                      ),
                                                    ),
                                                    // SizedBox(height: 200,),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                              )
                      ],
                    ),
                    // Obx(
                    //   () => (widget.controller.isUpdatingCart.value)
                    //       ? kLoadingWidget()
                    //       : Container(),
                    // ),
                  ],
                ),
              ),
              widget.platform == "SQUARE"
                  ? widget.controller.scart.value.cartData == null
                      ? SizedBox.shrink()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: BasicColors.getWhiteBlackColor(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                (widget.controller.isUpdatingCart.value ||
                                        widget
                                            .controller
                                            .isDoingCartIncrementDecrement
                                            .value)
                                    ? SizedBox.shrink()
                                    : Obx(
                                        () => ListTile(
                                          title: Text(
                                              "subTotal".tr,
                                              style: TextStyle(
                                                  fontSize: 22.sp,
                                                  color: BasicColors
                                                      .getBlackWhiteColor())),
                                          trailing: Text(
                                            Config.currencySymbol +
                                                double.parse(
                                                        "${(widget.controller.scart.value.subtotal == null) ? "0.0".toString() : widget.controller.scart.value.subtotal.toString()}")
                                                    .toStringAsFixed(
                                                        Config.fractionDigits),
                                            style: TextStyle(
                                                color: BasicColors
                                                    .getBlackWhiteColor(),
                                                fontSize: 22.sp),
                                          ),
                                        ),
                                      ),
                                Obx(
                                  () => CustomButton(
                                    onTap: () async {
                                      // print("hassan");
                                      if (widget.controller.isUpdatingCart
                                              .value ||
                                          widget
                                              .controller
                                              .isDoingCartIncrementDecrement
                                              .value) {
                                        // print("hassan2");
                                      } else {
                                        // print("hassan3");

                                        if (!widget
                                            .controller.isPlacingOrder.value) {
                                          widget.controller.isPlacingOrder
                                              .value = true;
                                          // print("hassan4");

                                          if (widget
                                                  .table.ongoing_order_square ==
                                              null) {
                                            // print("hassan5");

                                            if (widget.orderType ==
                                                'take_away') {
                                              print(widget.orderType);
                                              // print("hassanapi");

                                              var res = await widget.controller
                                                  .placeOrder(
                                                      widget.tableId.toString(),
                                                      widget.orderType,
                                                      widget.platform);
                                              // print("zabardast2");
                                              //  log("resdf  ${res.runtimeType}");
                                              // log(res);
                                              if (res is Map) {
                                                Get.back();
                                                Get.toNamed(
                                                    PageRoutes.orderPlacedPage,
                                                    arguments: [res]);
                                                widget.controller.scart.value =
                                                    SCart();
                                              }
                                              // print("hassan7");

                                              widget.controller.isPlacingOrder
                                                  .value = false;
                                            } else {
                                              // print("hassan8");

                                              var res = await widget.controller
                                                  .placeOrder(
                                                      widget.table.id
                                                          .toString(),
                                                      widget.orderType,
                                                      widget.platform);
                                              // print("okkkkkkk");

                                              //  log("resdf  ${res.runtimeType}");
                                              // log(res);
                                              if (res is Map) {
                                                Get.back();
                                                // print("hmmmmm");

                                                Get.toNamed(
                                                  PageRoutes.orderPlacedPage,
                                                  arguments: [res],
                                                );
                                                // print("yayyyyy");

                                                widget.controller.scart.value =
                                                    SCart();
                                              }
                                              // print("hassan9");

                                              widget.controller.isPlacingOrder
                                                  .value = false;
                                            }
                                          } else {
                                            // print(
                                            //     "hassan${widget.table.ongoing_order_square!.id}");
                                            // print(
                                            //     "DANIYAL${widget.table.ongoingOrder!.id}");
                                            var r = await widget.controller
                                                .addToOrder(
                                                    orderId: widget
                                                        .table
                                                        .ongoing_order_square!
                                                        .id,
                                                    platform: widget.platform);
                                            widget.controller.isPlacingOrder
                                                .value = false;
                                            if (r != null) {
                                              if (r is bool) {
                                                if (r) {
                                                  controller.isDrawerTypeCart
                                                      .value = 3;
                                                  setState(() {
                                                    widget.controller.scart
                                                        .value.cartData = null;
                                                  });

                                                  widget
                                                      .scaffoldKey.currentState!
                                                      .openEndDrawer();
                                                }
                                              }
                                            }
                                            // print("hassan11");
                                          }
                                          widget.controller.isPlacingOrder
                                              .value = false;
                                        } else {
                                          widget.controller.isPlacingOrder
                                              .value = false;
                                        }
                                      }
                                    },
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    bgColor: widget
                                            .controller.isUpdatingCart.value
                                        ? BasicColors.secondaryColor
                                        : widget
                                                .controller
                                                .isDoingCartIncrementDecrement
                                                .value
                                            ? BasicColors.secondaryColor
                                            : BasicColors.primaryColor,
                                    title: (widget
                                            .controller.isPlacingOrder.value)
                                        ? kLoadingWidget(
                                            loaderColor: BasicColors.white)
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "finishOrdering".tr,
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: BasicColors.white),
                                            ),
                                          ),
                                    borderRadius: 0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                  : widget.controller.cart.value.cartData == null
                      ? SizedBox.shrink()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: BasicColors.getWhiteBlackColor(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                (widget.controller.isUpdatingCart.value ||
                                        widget
                                            .controller
                                            .isDoingCartIncrementDecrement
                                            .value)
                                    ? SizedBox.shrink()
                                    :

                                Obx(
                                        () => ListTile(
                                          title: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Tax".tr,
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: BasicColors
                                                          .getBlackWhiteColor())),
                                              Text("subTotal".tr,
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: BasicColors
                                                          .getBlackWhiteColor())),
                                            ],
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                Config.currencySymbol +
                                                    double.parse(
                                                        "${(widget.controller.cart.value.tax == null) ? "0.0".toString() : widget.controller.cart.value.tax.toString()}")
                                                        .toStringAsFixed(
                                                        Config.fractionDigits),
                                                style: TextStyle(
                                                    color: BasicColors
                                                        .getBlackWhiteColor(),
                                                    fontSize: 18.sp),
                                              ),
                                              Text(
                                                Config.currencySymbol +
                                                    double.parse(
                                                            "${(widget.controller.cart.value.subtotal == null) ? "0.0".toString() : widget.controller.cart.value.subtotal.toString()}")
                                                        .toStringAsFixed(
                                                            Config.fractionDigits),
                                                style: TextStyle(
                                                    color: BasicColors
                                                        .getBlackWhiteColor(),
                                                    fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                Obx(
                                  () => CustomButton(
                                    onTap: () async {
                                      print("yayyyy");
                                      if (widget.controller.isUpdatingCart
                                              .value ||
                                          widget
                                              .controller
                                              .isDoingCartIncrementDecrement
                                              .value) {
                                        print("yayyyy2");
                                      } else {
                                        print("yayyyy3");

                                        if (!widget
                                            .controller.isPlacingOrder.value) {
                                          widget.controller.isPlacingOrder
                                              .value = true;
                                          print("yayyyy4");

                                          if (widget.table.ongoingOrder ==
                                              null) {
                                            print("yayyyy5");

                                            if (widget.orderType ==
                                                'take_away') {
                                              print("yayyyy6");

                                              var res = await widget.controller
                                                  .placeOrder(
                                                      widget.tableId.toString(),
                                                      widget.orderType,
                                                      widget.platform
                                                          .toString());
                                              //  log("resdf  ${res.runtimeType}");
                                              // log(res);
                                              if (res is Map) {
                                                Get.back();
                                                Get.toNamed(
                                                    PageRoutes.orderPlacedPage,
                                                    arguments: [res,  widget.orderType,]);
                                                widget.controller.cart.value =
                                                    CartResponse();
                                              }
                                              print("yayyyy7");

                                              widget.controller.isPlacingOrder
                                                  .value = false;
                                            } else {
                                              print("yayyyy8");

                                              var res = await widget.controller
                                                  .placeOrder(
                                                      widget.table.id
                                                          .toString(),
                                                      widget.orderType,
                                                      widget.platform);
                                              //  log("resdf  ${res.runtimeType}");
                                              // log(res);
                                              if (res is Map) {
                                                await widget.controller.getCategoriesDetail();
                                                Get.back();
                                                Get.toNamed(
                                                    PageRoutes.orderPlacedPage,
                                                    arguments: [res, widget.orderType]);
                                                widget.controller.cart.value =
                                                    CartResponse();
                                                print("yayyyy9");
                                              }

                                              widget.controller.isPlacingOrder
                                                  .value = false;
                                            }
                                          } else {
                                            print("yayyyy10");

                                            var r = await widget.controller
                                                .addToOrder(
                                                    orderId: widget
                                                        .table.ongoingOrder!.id,
                                                    platform: widget.platform);



                                            widget.controller.isPlacingOrder
                                                .value = false;
                                            if (r != null) {
                                              if (r is bool) {
                                                if (r) {
                                                  await widget.controller.getCategoriesDetail();
                                                  controller.isDrawerTypeCart
                                                      .value = 3;
                                                  setState(() {
                                                    widget.controller.cart.value
                                                        .cartData = null;
                                                  });

                                                  widget
                                                      .scaffoldKey.currentState!
                                                      .openEndDrawer();
                                                }
                                              }
                                            }
                                            print("yayyyy11");
                                          }
                                          widget.controller.isPlacingOrder
                                              .value = false;
                                          print("yayyyy12");
                                        } else {
                                          print("yayyyy13");

                                          widget.controller.isPlacingOrder
                                              .value = false;
                                        }
                                      }
                                    },
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.sp, vertical: 10.sp),
                                    bgColor: widget
                                            .controller.isUpdatingCart.value
                                        ? BasicColors.secondaryColor
                                        : widget
                                                .controller
                                                .isDoingCartIncrementDecrement
                                                .value
                                            ? BasicColors.secondaryColor
                                            : BasicColors.primaryColor,
                                    title: (widget
                                            .controller.isPlacingOrder.value)
                                        ? kLoadingWidget(
                                            loaderColor: BasicColors.white)
                                        : Padding(
                                            padding:  EdgeInsets.symmetric(
                                                vertical: 5.sp),
                                            child: Text(
                                              "finishOrdering".tr,
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: BasicColors.white),
                                            ),
                                          ),
                                    borderRadius: 0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSquareItemsInCartButton({required CommonController controller}) {
    return Obx(() {
      int cartCount = 0;

      if (controller.scart.value.cartData == null) {
        cartCount = 0;
      } else {
        cartCount = controller.scart.value.cartData!.length;
      }
      return CustomButton(
        onTap: () {
          controller.getSquareCart(widget.table.id.toString());
        },
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        title: Text(
          "itemsInCart".tr + " (${cartCount.toString()})",
          style: TextStyle(color: BasicColors.white, fontSize: 18.sp),
        ),
        bgColor: cartCount == 0
            ? BasicColors.secondaryColor
            : BasicColors.primaryColor,
      );
    });
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
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 3.w),
        title: Text(
          "itemsInCart".tr + " (${cartCount.toString()})",
          style: TextStyle(color: BasicColors.white, fontSize: 14.sp),
        ),
        bgColor: cartCount == 0
            ? BasicColors.secondaryColor
            : BasicColors.primaryColor,
      );
    });
  }

  Widget buildItemExtras(List<CartItemExtra>? cartItemExtras) {
    List<Widget> extras = <Widget>[];

    cartItemExtras!.forEach((extra) {
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
              style: TextStyle(
                  fontSize: 20.sp, color: BasicColors.getBlackWhiteColor()))
        ],
      ));
    });

    return Column(
      children: extras,
    );
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
            // controller.getCart(widget.tableId.toString());
            widget.controller.updateCartItemQty(
              tableId: widget.tableId.toString(),
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
      // controller.getCart(widget.tableId.toString());
      widget.controller.updateCartItemQty(
        tableId: widget.tableId.toString(),
        cartItemId: widget.controller.cart.value.cartData?[widget.controller.previousClickedCartItemIndex as int].id as int,
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
            // controller.getCart(widget.tableId.toString());
            widget.controller.updateCartItemQty(
              tableId: widget.tableId.toString(),
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

  void SQupdateQty(CartDatumm item, int index) {
    widget.controller.isDoingCartIncrementDecrement.value = true;
    if (timer == null) {
      widget.controller.previousClickedCartItem = item.toJson().toString();
      widget.controller.previousClickedCartItemIndex = index;
      log("Timer Null");
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          if (_start == 0) {
            // controller.getCart(widget.tableId.toString());
            await widget.controller.updateSquareCartItemQty(
              tableId: widget.tableId.toString(),
              cartItemId: widget
                  .controller
                  .scart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .id as int,
              productId: widget
                  .controller
                  .scart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .id as int,
              qty: double.parse(
                  "${widget.controller.scart.value.cartData![widget.controller.previousClickedCartItemIndex as int].quantity.toString()}"),
            );
            cancelTimer();
            setState(() {});
          } else {
            _start--;
          }
        },
      );
    }
    CartDatumm oldItem = CartDatumm(id: -1);
    if (widget.controller.previousClickedCartItem.toString() != null) {
      oldItem = CartDatumm.fromJson(item.toJson());
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
      // controller.getCart(widget.tableId.toString());
      widget.controller.updateCartItemQty(
        tableId: widget.tableId.toString(),
        cartItemId: widget
            .controller
            .scart
            .value
            .cartData?[widget.controller.previousClickedCartItemIndex as int]
            .id as int,
        productId: widget
            .controller
            .scart
            .value
            .cartData?[widget.controller.previousClickedCartItemIndex as int]
            .id as int,
        qty: double.parse(
            "${widget.controller.scart.value.cartData![widget.controller.previousClickedCartItemIndex as int].quantity.toString()}"),
      );
      widget.controller.previousClickedCartItem = item.toJson().toString();
      widget.controller.previousClickedCartItemIndex = index;
      log("Timer Null");
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          if (_start == 0) {
            // controller.getCart(widget.tableId.toString());
            widget.controller.updateCartItemQty(
              tableId: widget.tableId.toString(),
              cartItemId: widget
                  .controller
                  .scart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .id as int,
              productId: widget
                  .controller
                  .scart
                  .value
                  .cartData?[
                      widget.controller.previousClickedCartItemIndex as int]
                  .id as int,
              qty: double.parse(
                  "${widget.controller.scart.value.cartData![widget.controller.previousClickedCartItemIndex as int].quantity.toString()}"),
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
