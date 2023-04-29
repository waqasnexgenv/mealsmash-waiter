import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/config.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/model/Sorder.dart';
import 'package:Mealsmash_Waiter/model/order.dart';
import 'package:Mealsmash_Waiter/widgets/custom_circular_button.dart';
import 'package:Mealsmash_Waiter/widgets/entry_field.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';

class SPayNowPage extends StatefulWidget {
  bool isPayAsCashClicked = false;
  String change = "0.0";
  String? error;

  SPayNowPage({Key? key}) : super(key: key);

  @override
  State<SPayNowPage> createState() => _SPayNowPageState();
}

class _SPayNowPageState extends State<SPayNowPage> {
  bool isCompleteOrder = false;
  String? orderId;
  String? price;
  Order? order;
  SQOrder? sorder;

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
          sorder = params[3];
          // print("daniyal");

          // print(sorder!.orderMeta!.last.products!.title);
        } else {
          // print("ahmed");

          sorder = null;
          // fetch order detail
        }
      } else {
        params = null;
        // print("hassan");
      }
    }
    amountController.text = double.parse("${sorder!.total.toString()}")
        .toStringAsFixed(Config.fractionDigits);
    calculateChange("${sorder!.total.toString()}", "${amountController.text}");
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
                              fontSize: 16,
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
                                        width: boxWidth,
                                        height: boxHeight,
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
                                                .getBlackWhiteColor()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40.w,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await payAtCounter();
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
                                        width: boxWidth,
                                        height: boxHeight,
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
                                                .getBlackWhiteColor()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40.w,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    var c = double.parse(widget.change);
                                    if (c >= 0.0) {
                                      await payAtCounter();
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
                                        width: boxWidth,
                                        height: boxHeight,
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
                                                .getBlackWhiteColor()),
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
                            height: MediaQuery.of(context).size.height / 1.1.h,
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
    double value = double.parse("${sorder!.total.toString()}");
    try {
      double dis = double.parse("${sorder!.discount.toString()}");
      // if (dis > 0.0) {
      //   value = value - dis;
      // }
    } catch (e) {
      log("HAHAHA ${e.toString()}");
    }

    return [
      Text(
        Config.currencySymbol + value.toStringAsFixed(Config.fractionDigits),
        style: TextStyle(
          fontSize: 50.sp,
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
          fontSize: 13,
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

  Future<void> payAtCounter() async {
    var res = await controller.payAtCounter(
        orderId: orderId,
        completeOrder: isCompleteOrder ? 1 : 0,
        change: widget.change,
        cashPaid: amountController.text,
    );

    if (res != null) {
      // print(orderInvoice!.orderMeta);
      // if (res is bool) {
      //   if (res) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 260),              child: Dialog(
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
                        // height: MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.38: MediaQuery.of(context).size.height*0.25,
                        // width: MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.4: MediaQuery.of(context).size.width*0.39 ,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "paymentSuccess".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    color: BasicColors.black),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "doYouWantToCompleteOrder".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.sp, color: BasicColors.black),
                              ),
                              Spacer(),
                              // SizedBox(
                              //   height: 30,
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.03.w),
                                    ),
                                    child: TextButton(
                                      child: Text("no".tr,
                                          style: TextStyle(
                                              color: BasicColors.white,
                                              fontSize: 22.sp)),
                                      onPressed: () {
                                        Get.back();
                                        Get.offAllNamed(PageRoutes.splashPage);
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
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.03.w),
                                    ),
                                    child: TextButton(
                                      child: Text("yes".tr,
                                          style: TextStyle(
                                              color: BasicColors.white,
                                              fontSize: 22.sp)),
                                      onPressed: () async {
                                        Get.back();
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
                      Positioned(
                          top: MediaQuery.of(context).size.width * -0.03.w,
                          child: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            radius: MediaQuery.of(context).size.width * 0.03.w,
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width * 0.03.w,
                            ),
                          )),
                    ],
                  )),
            );
          });
      log("Payment Success");
      return;
      // }
      // }
    }

    log("Payment Failed");
  }

  double getNearestTenthValue(double value) {
    double remainder = value % 10;
    return value + (10 - remainder);
  }

  getCashPayScreen() {
    double priceDouble = double.parse("${sorder!.total.toString()}");
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
                    fontSize: 13,
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
                          "${sorder!.total.toString()}", amountController.text);
                    } else {
                      setState(() {
                        widget.error = "pleaseEnterSomethingFirst".tr;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
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
                                fontSize: 13,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            double.parse("${sorder?.subtotal}")
                                .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(
                              fontSize: 13,
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
                                fontSize: 13,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            double.parse("${sorder?.discount}")
                                .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(
                              fontSize: 13,
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
                height: 10,
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
                                fontSize: 13,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            double.parse("${sorder?.tax}")
                                .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(
                              fontSize: 13,
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
                                fontSize: 13,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor(),
                                // color: BasicColors.blueGrey
                              ),
                            ),
                          ),
                          Text(
                            "${widget.change}",
                            style: TextStyle(
                              fontSize: 13,
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
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: GestureDetector(
                      onTap: () {
                        controller.isDiscountBtnClicked.value = true;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: BasicColors.transparentColor,
                            border: Border.all(
                              color: BasicColors.getBlackWhiteColor(),
                              // color: BasicColors.secondaryColor as Color
                            )),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "discount".tr.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
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
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.35,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: getKeyBoardGridView(keyboardKeys, amountController),
          ),
        ),
      ],
    );
  }

  getKeyBoardGridView(
      List<KeyboardKey> keyboardKeys, TextEditingController textController,
      {bool isDiscount = false}) {
    double itemWidthHeight = (Get.width / 2.7) / 4;

    log("Item Widht and Height: ${itemWidthHeight.toString()}");

    return Container(
      height: MediaQuery.of(context).size.height / 1.49,
      child: GridView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        // physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1 / 1,
          crossAxisCount: 4,
          crossAxisSpacing: 1.5,
          mainAxisSpacing: 1.5,
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
                  if (res is SQOrder) {
                    setState(() {
                      sorder = res;
                    });
                    // discountController.clear();
                    controller.showToast("Discount Applied");
                  }
                  controller.isApplyingDiscount.value = false;
                  controller.isDiscountBtnClicked.value = false;
                  amountController.text =
                      double.parse("${sorder!.total.toString()}")
                          .toStringAsFixed(Config.fractionDigits);
                }
              }

              if (isDiscount) {
                setState(() {});
              } else {
                setState(() {
                  calculateChange(
                      "${sorder!.total.toString()}", textController.text);
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
                            size: 35,
                          )
                        : (keyboardKey.type == KeyboardKeyType.remove)
                            ? Icon(
                                Icons.backspace_outlined,
                                color: BasicColors.black,
                              )
                            : Text(
                                keyboardKey.value,
                                style: TextStyle(
                                    fontSize: 22,
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
      ),
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

    return Container(
      width: Get.width / 2.4,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: BasicColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: BasicColors.white,
            margin: EdgeInsets.symmetric(horizontal: 4),
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
