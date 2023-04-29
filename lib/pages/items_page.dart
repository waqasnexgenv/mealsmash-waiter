import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/model/Sorder.dart';
import 'package:Mealsmash_Waiter/model/categories_response.dart';
import 'package:Mealsmash_Waiter/model/order.dart';
import 'package:Mealsmash_Waiter/model/squarecategories.dart';
import 'package:Mealsmash_Waiter/model/tables_response.dart';
import 'package:Mealsmash_Waiter/pages/cart_info.dart';
import 'package:Mealsmash_Waiter/pages/item_info.dart';
import 'package:Mealsmash_Waiter/widgets/build_items.dart';
import 'package:Mealsmash_Waiter/widgets/custom_circular_button.dart';
import 'package:Mealsmash_Waiter/widgets/logo_widget.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order_info.dart';

class ItemsPage extends StatefulWidget {
  int? tableId;
  String? orderType;
  String? platform;

  ItemsPage({Key? key}) : super(key: key) {
    var params = Get.arguments;
    if (params != null) {
      if (params.length > 0) {
        tableId = params[0];
        orderType = params[1];
        platform = params[2];
      }
    }
  }

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final CommonController controller = Get.find<CommonController>();

  final TextEditingController searchTextController = TextEditingController();

  MyTable table = MyTable();

  PageController _pageController = PageController();

  Timer? _timer;
  int secToWait = 3;
  int _start = 3;
  int looper = 0;
  var pref;

  // var platform;
  var store_id;

  @override
  void initState() {
    super.initState();
    startTimer();
    Configure();
    // print("dsfsdffsd${platform}");
    print("dsfsdffsd${store_id}");
    // controller.getCart(widget.tableId.toString());
  }

  @override
  void dispose() async {
    stopTimer();
    super.dispose();
  }

  Configure() async {
    pref = await SharedPreferences.getInstance();
    // platform = pref.getString('platform_configured');
    store_id = pref.getString('vendor_id');
  }

  startTimer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          if (_start == 0) {
            looper++;
            // log("Loop is $looper");
            setState(() {
              _start = secToWait;
            });
            await controller.getTablesDetail(showLoading: false);
            //log("$_start");
          } else {
            _start--;
            //log("$_start");
          }
        },
      );
    });
  }

  stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("sdfsdf             ${widget.platform}");

    return SafeAreaHelper(
      child: Obx(() {
        var tables = controller.tables.value.data
            ?.where((element) => element.id == widget.tableId);
        if (tables != null) {
          if (tables.length > 0) {
            table = tables.first;
            if (table.ongoingOrder == null) {
              stopTimer();
            }
          } else {
            stopTimer();
          }
        } else {
          stopTimer();
        }
        // print("asjkasjkasjkas ${controller.categories.value.categories}");
        return Stack(
          children: [
            AbsorbPointer(
              absorbing: controller.isCompletingOrder.value,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Scaffold(
                  floatingActionButton:
                      table.ongoingOrder == null &&
                              table.ongoing_order_square == null
                          ? null
                          : Container(
                              height: 40.0.h,
                              width: 130.0.w,
                              child: FittedBox(
                                child: FloatingActionButton.extended(
                                  backgroundColor: BasicColors.primaryColor,
                                  onPressed: () {
                                    if (table.ongoingOrder != null ||
                                        table.ongoing_order_square != null) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0.sp)),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  // overflow: Overflow.visible,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      height: MediaQuery.of(context).size.height * 0.5.h,
                                                      width: MediaQuery.of(context).size.width * 0.6.w,
                                                      // height: 50,
                                                      // height: MediaQuery.of(context).size.width < 950? MediaQuery.of(context).size.height*0.88:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.48: MediaQuery.of(context).size.height*0.25,
                                                      // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.56:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.45: MediaQuery.of(context).size.width*0.3,

                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(0, 10, 10, 10),
                                                        child: Column(
                                                          children: [
                                                            Spacer(),

                                                            SizedBox(
                                                              height: 30.h
                                                              // MediaQuery.of(context).size.height*0.00,
                                                            ),
                                                            Text(
                                                              "Complete Order"
                                                                  .tr,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: BasicColors
                                                                      .black),
                                                            ),
                                                            SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.01.h),
                                                            Text(
                                                              table.ongoingOrder ==
                                                                      null
                                                                  ? table.ongoing_order_square!.paymentStatus.toString() ==
                                                                          "1"
                                                                      ? "orderAlreadyPaid"
                                                                          .tr
                                                                      : "payToCompleteOrder"
                                                                          .tr
                                                                  : table.ongoingOrder!.paymentStatus.toString() ==
                                                                          "1"
                                                                      ? "orderAlreadyPaid"
                                                                          .tr
                                                                      : "payToCompleteOrder"
                                                                          .tr,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: BasicColors
                                                                      .black),
                                                            ),
                                                            Spacer(),

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                // table.ongoingOrder!
                                                                //                 .paymentStatus
                                                                //                 .toString() ==
                                                                //             "1" ||

                                                                widget.platform ==
                                                                            "SQUARE" &&
                                                                        table.ongoing_order_square !=
                                                                            null
                                                                    ? table.ongoing_order_square!.paymentStatus.toString() ==
                                                                            "1"
                                                                        ? Row(
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width * 0.1.w,
                                                                                height: MediaQuery.of(context).size.height * 0.13.h,
                                                                                decoration: BoxDecoration(
                                                                                  color: BasicColors.primaryColor,
                                                                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                                                                ),
                                                                                child: TextButton(
                                                                                  child:
                                                                                  Text("no".tr, style: TextStyle(color: BasicColors.white, fontSize: 22.sp)),
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.02.w,
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width * 0.1.w,
                                                                                height: MediaQuery.of(context).size.height * 0.13.h,
                                                                                decoration: BoxDecoration(
                                                                                  color: BasicColors.primaryColor,
                                                                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.08.w),
                                                                                ),
                                                                                child: TextButton(
                                                                                  child: Text("yes".tr, style: TextStyle(color: BasicColors.white, fontSize: 22.sp)),
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                    controller.completeOrder(orderId: table.ongoing_order_square!.id.toString(), gotoTables: true);
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Container(
                                                                            width: MediaQuery.of(context).size.width * 0.12.w,
                                                                            height: MediaQuery.of(context).size.height * 0.13.h,
                                                                            decoration: BoxDecoration(
                                                                              color: BasicColors.primaryColor,
                                                                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                                                            ),
                                                                            child: TextButton(
                                                                              child: Text("payNow".tr, maxLines: 1, style: TextStyle(color: BasicColors.white, fontSize: 22.sp)),
                                                                              onPressed: () async {
                                                                                Get.back();
                                                                                stopTimer();
                                                                                await Get.toNamed(PageRoutes.SquarepayNowPage, arguments: [
                                                                                  true,
                                                                                  table.ongoing_order_square!.id.toString(),
                                                                                  table.ongoing_order_square!.total,
                                                                                  table.ongoing_order_square,
                                                                                ]);
                                                                                startTimer();
                                                                              },
                                                                            ),
                                                                          )
                                                                    : table.ongoingOrder!.paymentStatus.toString() ==
                                                                            "1"
                                                                        ? Row(
                                                                  // mainAxisAlignment: MainAxisAlignment.,
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width * 0.15.w,
                                                                                height: MediaQuery.of(context).size.height * 0.06.h,
                                                                                decoration: BoxDecoration(
                                                                                  color: BasicColors.primaryColor,
                                                                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                                                                ),
                                                                                child: TextButton(
                                                                                  child: Text("no".tr, style: TextStyle(color: BasicColors.white, fontSize: 22.sp)),
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.02.w,
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width * 0.19.w,
                                                                                height: MediaQuery.of(context).size.height * 0.06.h,
                                                                                decoration: BoxDecoration(
                                                                                  color: BasicColors.primaryColor,
                                                                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                                                                ),
                                                                                child: TextButton(
                                                                                  child: Text("yes".tr, style: TextStyle(color: BasicColors.white, fontSize: 22.sp)),
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                    controller.completeOrder(orderId: table.ongoingOrder!.id.toString(), gotoTables: true);
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.02.w,
                                                                              ),
                                                                              ///Yesprint
                                                                              // Container(
                                                                              //   width: MediaQuery.of(context).size.width * 0.3.w,
                                                                              //   height: MediaQuery.of(context).size.height * 0.09.h,
                                                                              //   decoration: BoxDecoration(
                                                                              //     color: BasicColors.primaryColor,
                                                                              //     borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                                                              //   ),
                                                                              //   child: TextButton(
                                                                              //     child: Text("Yes and\n print".tr, style: TextStyle(color: BasicColors.white, fontSize: 16.sp)),
                                                                              //     onPressed: () {
                                                                              //       Get.back();
                                                                              //       controller.payAtCounter(
                                                                              //         orderId: table.ongoingOrder!.id.toString(),
                                                                              //         completeOrder: 1,
                                                                              //         change: "0.00",
                                                                              //         cashPaid: table.ongoingOrder!.total.toString(),
                                                                              //         type: "Cash",
                                                                              //       );
                                                                              //       controller.completeOrder(orderId: table.ongoingOrder!.id.toString(), gotoTables: true);
                                                                              //     },
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          )
                                                                        : Container(
                                                                            width: MediaQuery.of(context).size.width * 0.33.w,
                                                                            height: MediaQuery.of(context).size.height * 0.06.h,
                                                                            decoration: BoxDecoration(
                                                                              color: BasicColors.primaryColor,
                                                                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                                                            ),
                                                                            child: TextButton(
                                                                              child: Text("payNow".tr, style: TextStyle(color: BasicColors.white, fontSize: 18.sp)),
                                                                              onPressed: () async {
                                                                                Get.back();
                                                                                stopTimer();
                                                                                await Get.toNamed(PageRoutes.payNowPage, arguments: [
                                                                                  true,
                                                                                  table.ongoingOrder!.id.toString(),
                                                                                  table.ongoingOrder!.total,
                                                                                  table.ongoingOrder,
                                                                                ]);
                                                                                startTimer();
                                                                              },
                                                                            ),
                                                                          ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 10.h,),
                                                            table.ongoingOrder!.paymentStatus.toString() ==
                                                                "1"
                                                                ? Container(
                                                              width: MediaQuery.of(context).size.width * 0.5.w,
                                                              height: MediaQuery.of(context).size.height * 0.06.h,
                                                              decoration: BoxDecoration(
                                                                color: BasicColors.primaryColor,
                                                                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                                              ),
                                                              child: TextButton(
                                                                child: Text("Yes and print".tr, style: TextStyle(color: BasicColors.white, fontSize: 18.sp)),
                                                                onPressed: () {
                                                                  Get.back();
                                                                  controller.payAtCounter(
                                                                    orderId: table.ongoingOrder!.id.toString(),
                                                                    completeOrder: 1,
                                                                    change: "0.00",
                                                                    cashPaid: table.ongoingOrder!.total.toString(),
                                                                    type: "Cash",
                                                                  );
                                                                  controller.completeOrder(orderId: table.ongoingOrder!.id.toString(), gotoTables: true);
                                                                },
                                                              ),
                                                            ):Container(),
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
                                                          backgroundColor:
                                                              Colors
                                                                  .redAccent,
                                                          radius: MediaQuery.of(context).size.width * 0.1.w,
                                                          child: Icon(
                                                            Icons
                                                                .info_outline,
                                                            color:
                                                                Colors.white,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1.w,
                                                          ),
                                                        )),
                                                  ],
                                                ));
                                          });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: BasicColors.white,
                                    size: 22.sp,
                                  ),
                                  label: Text("Complete Order"),
                                ),
                              ),
                            ),
                  backgroundColor: BasicColors.getWhiteBlackColor(),
                  key: _scaffoldKey,
                  endDrawer: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6.w),
                    child: Obx(
                      () => controller.isDrawerTypeCart.value == 1
                          ? CartInfo(
                              controller: controller,
                              table: table,
                              scaffoldKey: _scaffoldKey,
                              tableId: widget.tableId,
                              orderType: widget.orderType,
                              platform: widget.platform,
                            )
                          : controller.isDrawerTypeCart.value == 2
                              ? showItemInfo()
                              : controller.isDrawerTypeCart.value == 3
                                  ? OrderInfo(
                                      controller: controller,
                                      table: table,
                                      platform: widget.platform)
                                  : Container(),
                    ),
                  ),
                  appBar: AppBar(
                    // toolbarHeight: MediaQuery.of(context).size.height * 0.16.h,
// MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.16:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.1: MediaQuery.of(context).size.height*0.06,

                    automaticallyImplyLeading: false,
                    title: LogoWidgetmo(),
                    actions: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4.w,
                        // height: MediaQuery.of(context).size.height*0.2.h,
                        padding:
                            EdgeInsets.symmetric(vertical: 8.sp, horizontal: 2.sp),
                        child: TextFormField(
                          style: TextStyle(fontSize: 14.sp),
                          controller: searchTextController,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: BasicColors.primaryColor,
                          autofocus: false,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (searchTextController.text.length > 1) {
                              searchItems(searchTextController.text);
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  searchTextController.clear();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: BasicColors.primaryColor,
                                  size: 18.sp,
                                ),
                              ),
                              //Icon at the end

                              prefixIcon: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (searchTextController.text.length > 1) {
                                    searchItems(searchTextController.text);
                                  } else {
                                    controller.showToast(
                                        "pleaseEnterSomethingFirst".tr);
                                  }
                                },
                                child: Icon(
                                  Icons.search,
                                  color: BasicColors.primaryColor,
                                  size: 18.sp,
                                ),
                              ),
                              hintText: "searchItem".tr,
                              hintStyle: TextStyle(fontSize: 14.sp),
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              filled: true,
                              fillColor: BasicColors.secondSecondaryColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(16.sp))),
                        ),
                      ),
                      table.ongoingOrder == null &&
                              table.ongoing_order_square == null
                          ? widget.platform == "SQUARE"
                              ? buildSquareItemsInCartButton(
                                  controller: controller, isClickable: true)
                              : buildItemsInCartButton(
                                  controller: controller, isClickable: true)
                          : widget.platform == "SQUARE" &&
                                  table.ongoing_order_square != null
                              ? Row(
                                  children: [
                                    buildSquareOrderItemsButton(
                                        controller: controller,
                                        onGoingOrder: table.ongoing_order_square
                                            as SQOrder),
                                    Obx(() {
                                      // print("achaaaok");
                                      int cartCount = 0;
                                      if (controller.scart.value.cartData ==
                                          null) {
                                        cartCount = 0;
                                      } else {
                                        cartCount = controller
                                            .scart.value.cartData!.length;
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          controller.isDrawerTypeCart.value = 1;
                                          _scaffoldKey.currentState!
                                              .openEndDrawer();
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 13.0, top: 8.0),
                                              child: Icon(
                                                Icons.shopping_cart,
                                                color: BasicColors.primaryColor,
                                              ),
                                            ),
                                            Positioned(
                                                left: 10,
                                                top: 0,
                                                child: new Stack(
                                                  children: <Widget>[
                                                    new Icon(Icons.brightness_1,
                                                        size: 15.0.sp,
                                                        color: Colors.black26),
                                                    new Positioned(
                                                        top: 2.0,
                                                        right: 5.0,
                                                        child: new Center(
                                                          child: new Text(
                                                            cartCount
                                                                .toString(),
                                                            style: new TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    8.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                          ],
                                          // child: Icon(
                                          //   Icons.shopping_cart,
                                          //   color: BasicColors.primaryColor,
                                          // ),
                                        ),
                                      );
                                    }),
                                  ],
                                )
                              : table.ongoingOrder != null
                                  ? Row(
                                      children: [
                                        buildOrderItemsButton(
                                            controller: controller,
                                            onGoingOrder:
                                                table.ongoingOrder as Order),
                                        Obx(() {
                                          // print("1");
                                          int cartCount = 0;
                                          if (controller.cart.value.cartData ==
                                              null) {
                                            cartCount = 0;
                                          } else {
                                            cartCount = controller
                                                .cart.value.cartData!.length;
                                            // print("2");
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              controller
                                                  .isDrawerTypeCart.value = 1;
                                              _scaffoldKey.currentState!
                                                  .openEndDrawer();
                                              // print("achaaa jiiiii");
                                            },
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                       EdgeInsets.only(
                                                          right: 10.0.sp,
                                                          top: 8.0.sp),
                                                  child: Icon(
                                                    Icons.shopping_cart,
                                                    color: BasicColors
                                                        .primaryColor,
                                                    size: 20.sp,
                                                  ),
                                                ),
                                                Positioned(
                                                    left: 10,
                                                    top: 0,
                                                    child: new Stack(
                                                      children: <Widget>[
                                                        new Icon(
                                                            Icons.brightness_1,
                                                            size: 14.0.sp,
                                                            color:
                                                                Colors.black26),
                                                        new Positioned(
                                                            top: 2.0,
                                                            right: 5,
                                                            child: new Center(
                                                              child: new Text(
                                                                cartCount
                                                                    .toString(),
                                                                style: new TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            )),
                                                      ],
                                                    )),
                                              ],
                                              // child: Icon(
                                              //   Icons.shopping_cart,
                                              //   color: BasicColors.primaryColor,
                                              // ),
                                            ),
                                          );
                                        },
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        buildSquareOrderItemsButton(
                                            controller: controller,
                                            onGoingOrder:
                                                table.ongoing_order_square
                                                    as SQOrder),
                                        Obx(() {
                                          // print("achaaaok");
                                          int cartCount = 0;
                                          if (controller.scart.value.cartData ==
                                              null) {
                                            cartCount = 0;
                                          } else {
                                            cartCount = controller
                                                .scart.value.cartData!.length;
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              controller
                                                  .isDrawerTypeCart.value = 1;
                                              _scaffoldKey.currentState!
                                                  .openEndDrawer();
                                            },
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, top: 8.0),
                                                  child: Icon(
                                                    Icons.shopping_cart,
                                                    color: BasicColors
                                                        .primaryColor,
                                                    size: 29.sp,
                                                  ),
                                                ),
                                                Positioned(
                                                    left: 10,
                                                    top: 0,
                                                    child: new Stack(
                                                      children: <Widget>[
                                                        new Icon(
                                                            Icons.brightness_1,
                                                            size: 17.0.sp,
                                                            color:
                                                                Colors.black26),
                                                        new Positioned(
                                                            top: 2.0,
                                                            right: 5.0,
                                                            child: new Center(
                                                              child: new Text(
                                                                cartCount
                                                                    .toString(),
                                                                style: new TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            )),
                                                      ],
                                                    )),
                                              ],
                                              // child: Icon(
                                              //   Icons.shopping_cart,
                                              //   color: BasicColors.primaryColor,
                                              // ),
                                            ),
                                          );
                                        }),
                                      ],
                                    )
                    ],
                  ),
                  body: Obx(
                    () =>
                        controller.isLoadingCategories.value ||
                                controller.isLoadingSquareCategories.value
                            ? kLoadingWidget()
                            : widget.platform == "SQUARE"
                                ? Container(
                                    color: controller.isDarkTheme.value
                                        ? BasicColors.secondaryBlackColor
                                        : BasicColors.secondSecondaryColor,
                                    child:
                                        controller.scategories.value
                                                    .scategories ==
                                                null
                                            ? Center(
                                                child:
                                                    Text("noCategoryFound".tr),
                                              )
                                            : Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6.w,
                                                    child: ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemCount: controller
                                                            .scategories
                                                            .value
                                                            .scategories!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          SCategory category =
                                                              controller
                                                                      .scategories
                                                                      .value
                                                                      .scategories![
                                                                  index];
                                                          return InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .sqselectedCategoryIndex
                                                                  .value = index;
                                                              // log("${category.name}");
                                                              _pageController.animateToPage(
                                                                  index,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linearToEaseOut);
                                                            },
                                                            child: Obx(
                                                                () => Container(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.15.h,
                                                                      // width: 60,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8.sp,
                                                                          vertical:
                                                                              6.sp),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.sp),
                                                                        color: controller.sqselectedCategoryIndex.value ==
                                                                                index
                                                                            ? BasicColors.primaryColor
                                                                            : BasicColors.getWhiteBlackColor(),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Spacer(),
                                                                          // FadedScaleAnimation(
                                                                          //   Image.network(
                                                                          //     "${category.myRestCatUrl}",
                                                                          //     scale: 3.5,
                                                                          //   ),
                                                                          //   durationInMilliseconds: 400,
                                                                          // ),
                                                                          Spacer(),
                                                                          Text(
                                                                            category.name!.toUpperCase(),
                                                                            style:
                                                                                TextStyle(color: BasicColors.getBlackWhiteColor(), fontSize: 16.sp),
                                                                          ),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                    )),
                                                          );
                                                        }),
                                                  ),
                                                  Expanded(
                                                    child: PageView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      controller:
                                                          _pageController,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      onPageChanged: (index) {
                                                        controller
                                                            .sqselectedCategoryIndex
                                                            .value = index;
                                                      },
                                                      children:
                                                          getSquareCategoryItems(
                                                              controller),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                  )
                                : Container(
                                    color: controller.isDarkTheme.value
                                        ? BasicColors.secondaryBlackColor
                                        : BasicColors.secondSecondaryColor,
                                    child:
                                        controller.categories.value
                                                    .categories ==
                                                null
                                            ? Center(
                                                child:
                                                    Text("noCategoryFound".tr),
                                              )
                                            : Row(
                                                children: [
                                                  Container(
                                                    width: 100.sp,
                                                    // width:
                                                    //     MediaQuery.of(context)
                                                    //             .size
                                                    //             .width *
                                                    //         0.46.w,
                                                    child: ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemCount: controller
                                                            .categories
                                                            .value
                                                            .categories!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          Category category =
                                                              controller
                                                                      .categories
                                                                      .value
                                                                      .categories![
                                                                  index];
                                                          // print("alliiiiiiiiihhhhhhhhh${category.myRestCatUrl}");

                                                          return InkWell(
                                                            onTap: () {
                                                              // print("4");

                                                              controller
                                                                  .selectedCategoryIndex
                                                                  .value = index;
                                                              // log("${category.name}");
                                                              _pageController.animateToPage(
                                                                  index,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linearToEaseOut);
                                                              // print("5");
                                                            },
                                                            child: Obx(
                                                                () => Container(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.15.h,
                                                                      // width: MediaQuery.of(context).size.width*0.12.w,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              13,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.sp),
                                                                        color: controller.selectedCategoryIndex.value ==
                                                                                index
                                                                            ? BasicColors.primaryColor
                                                                            : BasicColors.getWhiteBlackColor(),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Spacer(),
                                                                          category.myRestCatUrl == null
                                                                              ? Container()
                                                                              : FadedScaleAnimation(
                                                                                  Padding(
                                                                                    padding:  EdgeInsets.all(8.0.sp),
                                                                                    child: Container(
                                                                                      height: MediaQuery.of(context).size.height * 0.09.h,
                                                                                      // width: context.screenWidth,
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage(
                                                                                            "${category.myRestCatUrl}",
                                                                                            // scale: 6.5,
                                                                                          ),
                                                                                          fit: BoxFit.fill,
                                                                                          // colorFilter: ColorFilter.mode(
                                                                                          //   kDarkBgColor.withOpacity(0.5),
                                                                                          //   BlendMode.darken,
                                                                                          // ),
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(20.sp),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  durationInMilliseconds: 400,
                                                                                ),
                                                                          Spacer(),
                                                                          Text(
                                                                            category.name!.toUpperCase(),
                                                                            style:
                                                                                TextStyle(color: BasicColors.getBlackWhiteColor(), fontSize: 12.sp),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                    )),
                                                          );
                                                        }),
                                                  ),
                                                  Expanded(
                                                    child: PageView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      controller:
                                                          _pageController,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      onPageChanged: (index) {
                                                        print(index);
                                                        // print("waqas ahmad");
                                                        controller
                                                            .selectedCategoryIndex
                                                            .value = index;
                                                      },
                                                      children:
                                                          getCategoryItems(
                                                              controller),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                  ),
                  ),
                ),
              ),
            ),
            controller.isCompletingOrder.value
                ? kLoadingWidget()
                : SizedBox.shrink()
          ],
        );
      }),
    );
  }

  Widget buildSquarePage(List<SquareProduct>? squareProduct) {
    return (squareProduct == null)
        ? Center(
            child: Text("noItemInCategory".tr,
                style: TextStyle(color: BasicColors.getBlackWhiteColor())),
          )
        : (squareProduct.length < 1)
            ? Center(
                child: Text(
                  "noItemInCategory".tr,
                  style: TextStyle(color: BasicColors.getBlackWhiteColor()),
                ),
              )
            : BuildSquareItems.build(
                squareProduct, controller, _scaffoldKey, store_id);
  }

  Widget buildPage(List<Product>? products) {
    return (products == null)
        ? Center(
            child: Text("noItemInCategory".tr,
                style: TextStyle(
                    color: BasicColors.getBlackWhiteColor(), fontSize: 21.sp)),
          )
        : (products.length < 1)
            ? Center(
                child: Text(
                  "noItemInCategory".tr,
                  style: TextStyle(
                      color: BasicColors.getBlackWhiteColor(), fontSize: 21.sp),
                ),
              )
            : BuildItems.build(
                products,
                controller,
                _scaffoldKey,
              );
  }

  Widget buildSquareOrderItemsButton(
      {required CommonController controller, required SQOrder onGoingOrder}) {
    return CustomButton(
      onTap: () {
        if (onGoingOrder.id != null) {
          controller.isDrawerTypeCart.value = 3;
          _scaffoldKey.currentState!.openEndDrawer();
        }
      },
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      title: Text(
        "orderItems".tr + " (${onGoingOrder.orderMeta?.length})",
        style: TextStyle(color: BasicColors.white, fontSize: 22.sp),
      ),
      bgColor: BasicColors.primaryColor,
    );
  }

  Widget buildOrderItemsButton(
      {required CommonController controller, required Order onGoingOrder}) {
    return CustomButton(
      onTap: () {
        // print("9");

        if (onGoingOrder.id != null) {
          controller.isDrawerTypeCart.value = 3;
          _scaffoldKey.currentState!.openEndDrawer();
        }
        // print("10");
      },
      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 4.sp),
      title: Text(
        "orderItems".tr + " (${onGoingOrder.orderMeta?.length})",
        style: TextStyle(color: BasicColors.white, fontSize: 14.sp),
      ),
      bgColor: BasicColors.primaryColor,
    );
  }

  Widget buildSquareItemsInCartButton(
      {required CommonController controller, bool isClickable = false}) {
    return Obx(() {
      int cartCount = 0;
      if (controller.scart.value.cartData == null) {
        cartCount = 0;
      } else {
        cartCount = controller.scart.value.cartData!.length;
      }
      return CustomButton(
        onTap: () {
          if (isClickable) {
            // Show Cart In Drawer
            controller.isDrawerTypeCart.value = 1;
            if (controller.scart.value.cartData != null) {
              _scaffoldKey.currentState!.openEndDrawer();
            }
          }
        },
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        title: Text(
          // "",
           "Cart".tr + " (${cartCount.toString()})",
          style: TextStyle(color: BasicColors.white, fontSize: 14.sp),
        ),
        bgColor: cartCount == 0
            ? BasicColors.secondaryColor
            : BasicColors.primaryColor,
      );
    });
  }

  Widget buildItemsInCartButton(
      {required CommonController controller, bool isClickable = false}) {
    return Obx(() {
      int cartCount = 0;
      if (controller.cart.value.cartData == null) {
        cartCount = 0;
      } else {
        cartCount = controller.cart.value.cartData!.length;
      }
      return CustomButton(
        onTap: () {
          // print("11");

          if (isClickable) {
            // Show Cart In Drawer
            controller.isDrawerTypeCart.value = 1;
            if (controller.cart.value.cartData != null) {
              _scaffoldKey.currentState!.openEndDrawer();
            }
          }
          // print("12");
        },
        padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 8.sp),
        margin: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 8.sp),
        title: Text(
          "itemsInCart".tr + " (${cartCount.toString()})",
          style: TextStyle(color: BasicColors.white, fontSize: 12.sp),
        ),
        bgColor: cartCount == 0
            ? BasicColors.secondaryColor
            : BasicColors.primaryColor,
      );
    });
  }

  getSquareCategoryItems(CommonController controller) {
    List<Widget> categoryItemsPages = <Widget>[];
    controller.scategories.value.scategories!.forEach((category) {
      categoryItemsPages.add(
        buildSquarePage(category.squareProducts),
      );
    });
    return categoryItemsPages;
  }

  getCategoryItems(CommonController controller) {
    List<Widget> categoryItemsPages = <Widget>[];
    controller.categories.value.categories!.forEach((category) {
      categoryItemsPages.add(
        buildPage(category.products),
      );
    });
    return categoryItemsPages;
  }

  Future<void> searchItems(String text) async {
    controller.searchItems(text);
    stopTimer();
    await Get.toNamed(PageRoutes.searchResultPage,
        arguments: [widget.tableId, widget.orderType, widget.platform]);
    startTimer();
  }

  showItemInfo() {
    return ItemInfoPage(
        catName: controller.selectedCategoryName.value,
        scaffoldKey: _scaffoldKey,
        table: table,
        platform: widget.platform);
  }
}
