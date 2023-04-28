import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';
import 'package:hungerz_ordering/helper/colors.dart';
import 'package:get/get.dart';
import 'package:hungerz_ordering/helper/config.dart';
import 'package:hungerz_ordering/helper/strings.dart';
import 'package:hungerz_ordering/model/Scart.dart';
import 'package:hungerz_ordering/model/cart_response.dart';
import 'package:hungerz_ordering/model/categories_response.dart';
import 'package:hungerz_ordering/model/modifiers.dart';
import 'package:hungerz_ordering/model/squarecategories.dart';
import 'package:hungerz_ordering/model/tables_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
// var priice;
double sum=0.0;
double extraPrice = 0.0;
String totalPrice="";

class ItemInfoPage extends StatefulWidget {
  final String catName;
  final String? platform;

  final GlobalKey<ScaffoldState> scaffoldKey;
  MyTable table;

  ItemInfoPage(
      {Key? key,
        required this.catName,
        required this.scaffoldKey,
        required this.table,
        required this.platform})
      : super(key: key);

  @override
  State<ItemInfoPage> createState() => _ItemInfoPageState();
}

class _ItemInfoPageState extends State<ItemInfoPage> {
  final CommonController controller = Get.find<CommonController>();

  String? SquaretotalPrice;
  int? selectedVariation;
bool isadding =false;
  bool isClicked = false;
  List<dynamic> _selectedItems = [];
  int totalprice = 0;
  // double extraPrice= 0.0;
  List<ModifierElement> modifier = [];
  var variantid;
  var variantname;
  var variantprice;
  var variantcurrency;
  var pref;

  getShared() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getShared();
    controller.selectedOptions.clear();
    controller.selectedExtras.clear();
    controller.allExtras.clear();
    // selectedVariation.;
    // controller.allModifiers.clear();
    modifier.clear();
    extraPrice = 0.0;
    totalPrice = "";
    SquaretotalPrice = "0.0";
    if (widget.platform == "SQUARE") {
      if (controller.selectedSquareProduct.value.squarevariants!.isNotEmpty) {
        controller.noOfOptions.value =
            controller.selectedSquareProduct.value.squarevariants!.length;
        SquaretotalPrice =
        "${controller.selectedSquareProduct.value.price!.price}";
        print("${SquaretotalPrice}");
      } else {
        SquaretotalPrice =
        "${controller.selectedSquareProduct.value.price!.price}";
      }
    } else {
      if (controller.selectedProduct.value.variants!.isNotEmpty) {
        controller.noOfOptions.value =
            controller.selectedProduct.value.options!.length;
        totalPrice = double.parse(
            "${controller.selectedProduct.value.price!.price}")
            .toStringAsFixed(Config.fractionDigits);
      } else {
        totalPrice = double.parse(
            "${controller.selectedProduct.value.price!.price}")
            .toStringAsFixed(Config.fractionDigits);
      }
      if (controller.selectedProduct.value.extras!.isNotEmpty) {
        totalPrice = (double.parse(
            "${controller.selectedProduct.value.price!.price}")+ double.parse("${extraPrice.toString()}")).toString()
        // .toStringAsFixed(Config.fractionDigits)
            ;
        controller.allExtras
            .assignAll(controller.selectedProduct.value.extras!);
      }
    }

    setState(() {
      totalPrice;
      extraPrice;
    });
    // Megatotal = (totalPrice) + (sum);
    // print(Megatotal.toString());
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    extraPrice;
    sum = extraPrice==null?double.parse(totalPrice.toString()):
    double.parse(totalPrice.toString())+ double.parse(extraPrice.toString());
// setState(() { });
    sum = extraPrice==null?double.parse(totalPrice.toString()):
    double.parse(totalPrice.toString())+ double.parse(extraPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.6.w,
      child: Drawer(

        child: Container(
          // width: MediaQuery.of(context).size.width*0.5,
          color: BasicColors.getWhiteBlackColor(),
          child: SingleChildScrollView(
            child: widget.platform == "SQUARE"
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        FadedScaleAnimation(
                          Container(
                            height: MediaQuery.of(context).size.height*0.15.h,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.vertical(
                                //     top: Radius.circular(0)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      "${controller.selectedSquareProduct.value.picture}",
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          durationInMilliseconds: 300,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 1),
                          width: MediaQuery.of(context).size.width.w,
                          height: MediaQuery.of(context).size.height*0.6.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  BasicColors.getWhiteBlackColor(),
                                  BasicColors.transparentColor
                                ],
                                stops: [
                                  0.0,
                                  0.5
                                ]),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width.w,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: BasicColors.getWhiteBlackColor(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.selectedSquareProduct.value.title}",
                            style: TextStyle(fontSize: 20.sp,
                                color: BasicColors.getBlackWhiteColor()),
                          ),
                          Row(
                            children: [
                              Text(
                                "${widget.catName}",
                                style: TextStyle(
                                    color: BasicColors.secondaryColor,
                                    height: 1.8.h),
                              ),
                              Spacer(),
                              Text(
                                Config.currencySymbol +
                                    "${SquaretotalPrice.toString()}",
                                style: TextStyle(
                                    color: BasicColors.getBlackWhiteColor(),
                                    fontSize: 20.sp),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Text(
                              "Variants",
                              style: TextStyle(fontSize: 20.sp),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width*0.45,
                                  height: MediaQuery.of(context).size.height*0.05.h,
                                  child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller
                                          .selectedSquareProduct
                                          .value
                                          .squarevariants ==
                                          null
                                          ? 0
                                          : controller
                                          .selectedSquareProduct
                                          .value
                                          .squarevariants
                                          ?.length,
                                      itemBuilder: (context, index) {
                                        // variantid=  widget.squareproduct
                                        //     .squarevariants[index].id
                                        //     .toString();

                                        // var title = controller
                                        //     .selectedSquareProduct
                                        //     .value
                                        //     .squarevariants?[index]
                                        //     .title
                                        //     .toString();
                                        // print("sfdfasdfsfa${title}");
                                        // var id=  widget.squareproduct.squarevariants[index].id;
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedVariation = index;
                                              print(selectedVariation);

                                              variantname = (controller
                                                  .selectedSquareProduct
                                                  .value
                                                  .title! +
                                                  "(${controller.selectedSquareProduct.value.squarevariants?[index].title.toString()})");
                                              variantid =
                                              "(${controller.selectedSquareProduct.value.squarevariants?[index].id.toString()})";
                                              print(
                                                  "variantname${variantname}");
                                              variantprice = controller
                                                  .selectedSquareProduct
                                                  .value
                                                  .squarevariants?[index]
                                                  .price
                                                  .toString();

                                              variantcurrency = controller
                                                  .selectedSquareProduct
                                                  .value
                                                  .squarevariants?[index]
                                                  .currency
                                                  .toString();
                                              //

                                              if (selectedVariation !=
                                                  null) {
                                                isClicked = true;
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 0.0,
                                              top: 5.0,
                                              right: 0.0,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                (selectedVariation ==
                                                    index)
                                                    ? Theme.of(
                                                    context)
                                                    .primaryColor
                                                    : Colors.white,
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        6)),
                                              ),
                                              // color: ( selectedVariation == index) ? Colors.red : Colors.white,

                                              width: 70.w,
                                              height: 40.h,
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceAround,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Container(
                                                        child: Center(
                                                            child: Text(
                                                              "${controller.selectedSquareProduct.value.squarevariants?[index].title.toString()}",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: (selectedVariation ==
                                                                      index)
                                                                      ? Colors
                                                                      .white
                                                                      : Theme.of(context)
                                                                      .primaryColor,
                                                                  fontSize:
                                                                  20.sp,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            )),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        );
                                      })),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          if (isClicked == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Container(
                                    child: (Text(
                                      "Modifiers",
                                      style: TextStyle(fontSize: 16.sp),
                                    )),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      // width: MediaQuery.of(context).size.width,
                                        height:MediaQuery.of(context).size.height*0.05.h,
                                        child: ListView.builder(
                                            physics:
                                            BouncingScrollPhysics(),
                                            scrollDirection:
                                            Axis.horizontal,
                                            itemCount: controller
                                                .Modifiers
                                                .value
                                                .modifiers ==
                                                null
                                                ? 0
                                                : controller
                                                .Modifiers
                                                .value
                                                .modifiers
                                                ?.length,
                                            itemBuilder:
                                                (context, index) {
                                              // var title = controller
                                              //     .Modifiers.value.i
                                              //     .toString();

                                              return InkWell(
                                                onTap: () {
                                                  if (!_selectedItems
                                                      .contains(controller
                                                      .Modifiers
                                                      .value
                                                      .modifiers?[
                                                  index]
                                                      .id)) {
                                                    _selectedItems.add(
                                                        controller
                                                            .Modifiers
                                                            .value
                                                            .modifiers?[
                                                        index]
                                                            .id);
                                                    ModifierElement _ =
                                                    ModifierElement();
                                                    _.id = controller
                                                        .Modifiers
                                                        .value
                                                        .modifiers?[index]
                                                        .id;
                                                    _.name = controller
                                                        .Modifiers
                                                        .value
                                                        .modifiers?[index]
                                                        .name;
                                                    _.price = controller
                                                        .Modifiers
                                                        .value
                                                        .modifiers![index]
                                                        .price;
                                                    modifier.add(_);
                                                    print(
                                                        "heelo ${jsonEncode(modifier)}");

                                                    print(_selectedItems);
                                                  } else {
                                                    _selectedItems.remove(
                                                        controller
                                                            .Modifiers
                                                            .value
                                                            .modifiers?[
                                                        index]
                                                            .id);
                                                    ModifierElement _ =
                                                    ModifierElement();
                                                    _.id = controller
                                                        .Modifiers
                                                        .value
                                                        .modifiers?[index]
                                                        .id;
                                                    _.name = controller
                                                        .Modifiers
                                                        .value
                                                        .modifiers?[index]
                                                        .name;
                                                    _.price = (controller
                                                        .Modifiers
                                                        .value
                                                        .modifiers![index]
                                                        .price);
                                                    // modifier.remove(_);
                                                    modifier.removeWhere(
                                                            (item) =>
                                                        item.id ==
                                                            _.id);
                                                    print(
                                                        "bye ${jsonEncode(modifier)}");
                                                  }
                                                  // SquaretotalPrice =
                                                  //     (SquaretotalPrice! +
                                                  //         controller
                                                  //             .Modifiers
                                                  //             .value
                                                  //             .modifiers![
                                                  //                 index]
                                                  //             .price);
                                                  // print(
                                                  //     "totalprice${SquaretotalPrice}");
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                    left: 0.0,
                                                    top: 10.0,
                                                    right: 0.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                          children: <
                                                              Widget>[
                                                            Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                color: (_selectedItems.contains(controller
                                                                    .Modifiers
                                                                    .value
                                                                    .modifiers?[
                                                                index]
                                                                    .id))
                                                                    ? Theme.of(context)
                                                                    .primaryColor
                                                                    : Colors
                                                                    .white,
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(6)),
                                                              ),
                                                              // color: (_selectedItems.contains(index)) ? Colors.red : Colors.white,

                                                              width: 90.w,
                                                              height: 40.h,

                                                              child:
                                                              Center(
                                                                child:
                                                                Text(
                                                                  "${controller.Modifiers.value.modifiers?[index].name.toString()}",
                                                                  style: TextStyle(
                                                                      color: (_selectedItems.contains(controller.Modifiers.value.modifiers?[index].id))
                                                                          ? Colors.white
                                                                          : Theme.of(context).primaryColor,
                                                                      fontSize: 20.sp,
                                                                      fontWeight: FontWeight.bold),
                                                                  overflow:
                                                                  TextOverflow.clip,
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })),
                                  ],
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Obx(
                                () => widget.table.ongoing_order_square == null
                            // for add to cart
                                ? InkWell(
                              onTap: () async {
                                print("fun1");

                                if (!controller
                                    .isUpdatingCart.value) {
                                  if (SquareisAlreadyInCart()) {
                                    controller
                                        .isDrawerTypeCart.value = 1;
                                    print("fun2");
                                  } else {
                                    print("fun3");

                                    if (controller
                                        .selectedSquareProduct
                                        .value
                                        .squarevariants!
                                        .isNotEmpty) {
                                      if (selectedVariation != null) {
                                        await controller
                                            .SquareaddToCart(
                                          product_id: variantid,
                                          product_name: variantname,
                                          product_price: variantprice,
                                          qty: 1,
                                          tax_value: 0,
                                          vendor_id: pref
                                              .getString('vendor_id'),
                                          product_currency:
                                          variantcurrency,
                                          image: controller
                                              .selectedSquareProduct
                                              .value
                                              .picture
                                              .toString(),
                                          modifiers: modifier,
                                        );
                                        Navigator.pop(context);
                                        setState(() {});
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                            "pleaseSelectAVariationFirst",
                                            toastLength:
                                            Toast.LENGTH_SHORT,
                                            gravity:
                                            ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                            Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 18.0.sp);
                                      }
                                      // else {
                                      //   controller.showToast(
                                      //       "Please select a variation first");
                                      // }

                                    }
                                  }
                                }
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height:MediaQuery.of(context).size.height*0.05.h,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    color: Colors.red,
                                  ),
                                  child: controller
                                      .isUpdatingCart.value
                                      ? kLoadingWidget(
                                      loaderColor:
                                      BasicColors.white,
                                      size: 25.sp)
                                      : Center(
                                    child: Text(
                                      SquareisAlreadyInCart()
                                          ? "viewCart".tr
                                          : "addToCart".tr,
                                      style: TextStyle(
                                        color:
                                        BasicColors.white,
                                          fontSize: 20.sp
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            // for add to order
                                : InkWell(
                              onTap: () async {
                                print("khan");
                                if (!controller
                                    .isUpdatingOrder.value &&
                                    widget.table.ongoingOrder
                                        ?.paymentStatus
                                        .toString() !=
                                        "1") {
                                  print("khan2");

                                  if (SquareisAlreadyInCart()) {
                                    controller
                                        .isDrawerTypeCart.value = 1;
                                  } else {
                                    print("khan3");

                                    if (controller
                                        .selectedSquareProduct
                                        .value
                                        .squarevariants!
                                        .isNotEmpty) {
                                      if (selectedVariation != null) {
                                        var r = await controller
                                            .SquareaddToCart(
                                          product_id: variantid,
                                          product_name: variantname,
                                          product_price: variantprice,
                                          qty: 1,
                                          tax_value: 0,
                                          vendor_id: pref
                                              .getString('vendor_id'),
                                          product_currency:
                                          variantcurrency,
                                          image: controller
                                              .selectedSquareProduct
                                              .value
                                              .picture
                                              .toString(),
                                          modifiers: modifier,
                                        );
                                        setState(() {});

                                        // await controller.addToOrder(
                                        //     productId: controller
                                        //         .selectedProduct.value.id
                                        //         .toString(),
                                        //     qty: "1",
                                        //     orderId: widget.table.ongoingOrder!.id
                                        //         .toString(),
                                        //     variationId:
                                        //         selectedVariation.id.toString(),
                                        //     extrasIds: extrasIds);

                                        if (r != null) {
                                          if (r is bool) {
                                            if (r) {
                                              controller
                                                  .isDrawerTypeCart
                                                  .value = 1;
                                              widget.scaffoldKey
                                                  .currentState!
                                                  .openEndDrawer();
                                            }
                                          }
                                        }
                                      }

                                      // else {
                                      //   controller.showToast(
                                      //       "Please select a variation first");
                                      // }
                                    } else {
                                      print("khan4");

                                      var r = await controller
                                          .SquareaddToCart(
                                          product_id: variantid,
                                          product_name:
                                          variantname,
                                          product_price:
                                          variantprice,
                                          qty: 1,
                                          tax_value: 0,
                                          vendor_id:
                                          pref.getString(
                                              'vendor_id'),
                                          product_currency:
                                          variantcurrency,
                                          image: controller
                                              .selectedSquareProduct
                                              .value
                                              .picture
                                              .toString(),
                                          modifiers: modifier);
                                      setState(() {});
                                      // await controller.addToOrder(
                                      //     productId: controller
                                      //         .selectedProduct.value.id
                                      //         .toString(),
                                      //     qty: "1",
                                      //     orderId: widget.table.ongoingOrder!.id
                                      //         .toString());
                                      if (r != null) {
                                        if (r is bool) {
                                          if (r) {
                                            controller
                                                .isDrawerTypeCart
                                                .value = 1;
                                            widget.scaffoldKey
                                                .currentState!
                                                .openEndDrawer();
                                            print("khan5");
                                          }
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder:
                                          (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 260),
                                          child: Dialog(
                                              shape:
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      4.0)),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                // overflow:
                                                // Overflow.visible,
                                                alignment:
                                                Alignment.topCenter,
                                                children: [
                                                  Container(
                                                    height: MediaQuery.of(context).size.height* 0.5.h,
                                                    width: MediaQuery.of(context).size.width* 0.6.w,
                                                    // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.12.h,:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.38: MediaQuery.of(context).size.height*0.25,
                                                    // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.56:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.4: MediaQuery.of(context).size.width*0.39,

                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .fromLTRB(
                                                          10,
                                                          20,
                                                          10,
                                                          10),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Text(
                                                            "alert".tr,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                20,
                                                                color: BasicColors
                                                                    .black),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                              10),
                                                          Text(
                                                            "orderAlreadyPaid"
                                                                .tr,
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize:
                                                                20.sp,
                                                                color: BasicColors
                                                                    .black),
                                                          ),
                                                          Spacer(),
                                                          // SizedBox(
                                                          //   height: 20.h,
                                                          // ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
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
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                    20.w,
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
                                                                    onPressed: () {
                                                                      Get.back();
                                                                      controller.completeOrder(orderId: widget.table.ongoingOrder!.id.toString(), gotoTables: true);
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
                                                      top: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          -0.03.w,
                                                      child:
                                                      CircleAvatar(
                                                        backgroundColor:
                                                        Colors
                                                            .redAccent,
                                                        radius: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.03.w,
                                                        child: Icon(
                                                          Icons
                                                              .info_outline,
                                                          color: Colors
                                                              .white,
                                                          size: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.03.w,
                                                        ),
                                                      )),
                                                ],
                                              )),
                                        );
                                      });
                                }
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height:MediaQuery.of(context).size.height*0.08.h,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    color: Colors.red,
                                  ),
                                  child: controller
                                      .isUpdatingOrder.value
                                      ? kLoadingWidget(
                                      loaderColor:
                                      BasicColors.white,
                                      size: 25.sp)
                                      : Center(
                                    child: Text(
                                      SquareisAlreadyInCart()
                                          ? "viewCart".tr
                                          : "addToCart".tr,
                                      style: TextStyle(
                                        color:
                                        BasicColors.white,
                                          fontSize: 20.sp
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: BasicColors.getWhiteBlackColor(),
                      ),
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "description".tr + '\n\n',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                    color: BasicColors.secondaryColor)),
                            TextSpan(
                                text:
                                '${controller.selectedSquareProduct.value.title}',
                                style: TextStyle(
                                  height: 1.3.h,
                                  color: BasicColors.getBlackWhiteColor(),
                                )),
                          ])),
                    ),
                  ],
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        FadedScaleAnimation(
                          Container(
                            height:MediaQuery.of(context).size.height*0.5.h,
                            // height: MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.25: MediaQuery.of(context).size.height*0.39,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      "${controller.selectedProduct.value.picture}",
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          durationInMilliseconds: 300,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 1),
                          width: MediaQuery.of(context).size.width.w,
                            height:MediaQuery.of(context).size.height*0.5.h,
                            // height: MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.25: MediaQuery.of(context).size.height*0.39,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  BasicColors.getWhiteBlackColor(),
                                  BasicColors.transparentColor
                                ],
                                stops: [
                                  0.0,
                                  0.5
                                ]),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 10.sp),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 15.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.sp),
                        color: BasicColors.getWhiteBlackColor(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.selectedProduct.value.title}",
                            style: TextStyle(fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: BasicColors.getBlackWhiteColor()),
                          ),
                          Row(
                            children: [
                              Text(
                                "${widget.catName}",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: BasicColors.secondaryColor,
                                    height: 1.8.h),
                              ),
                              Spacer(),
                              Text(
                                Config.currencySymbol +
                                    "${double.parse(totalPrice.toString()) + extraPrice}",
                                style: TextStyle(
                                    color: BasicColors.getBlackWhiteColor(),
                                    fontSize: 20.sp),
                              ),
                            ],
                          ),
                          (controller.selectedProduct.value.variants!
                              .isNotEmpty)
                              ? Obx(() =>
                          (controller.isVariationItemClicked.value)
                              ? buildOptions()
                              : buildOptions())
                              : Container(),
                          (controller.selectedProduct.value.variants!
                              .isNotEmpty)
                              ? Obx(() =>
                          (controller.isVariationItemClicked.value)
                              ? buildExtras(controller)
                              : buildExtras(controller))
                              : Container(),
                        ],
                      ),
                    ),
                    Obx(
                          () => widget.table.ongoingOrder == null
                      // for add to cart
                          ? InkWell(
                        onTap: () async {
                          if(isadding==true){

                          }
                          else{
                          if (!controller.isUpdatingCart.value) {
                            if (isAlreadyInCart()) {
                              controller.isDrawerTypeCart.value = 1;
                            } else {
                              if (controller.selectedProduct.value
                                  .variants!.isNotEmpty) {
                                if (controller
                                    .selectedOptions.length ==
                                    controller.noOfOptions.value) {
                                  List<int> extrasIds = [];

                                  if (controller
                                      .selectedExtras.isNotEmpty) {
                                    controller.selectedExtras
                                        .forEach((key, ex) {
                                      controller.allExtras
                                          .forEach((element) {
                                        if (element.id == ex.id) {
                                          extrasIds.add(ex.id as int);
                                        }
                                      });
                                    });
                                  }
                                  var selectedVariation =
                                  isVariationSelected(
                                      controller
                                          .selectedProduct.value,
                                      controller);
                                  if (selectedVariation != null) {

                                    if (controller
                                        .selectedProduct.value.price
                                        ?.quantity! != 0) {

                                      setState(() {
                                        isadding = true;
                                      });
                                    await controller.addToCart(
                                        widget.table.id.toString(),
                                        productId: controller
                                            .selectedProduct.value.id
                                            .toString(),
                                        qty: "1",
                                        vendorId: controller
                                            .restaurant.value.data!.id
                                            .toString(),
                                        variationId: selectedVariation
                                            .id
                                            .toString(),
                                        extrasIds: extrasIds);
                                    setState(() {
                                      isadding = false;
                                    });
                                      Fluttertoast.showToast(
                                          msg:
                                          "Item Added in Cart",
                                          toastLength:
                                          Toast.LENGTH_SHORT,
                                          gravity:
                                          ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 18.0.sp);
                                  }
                                    else{
                                      Fluttertoast.showToast(
                                          msg:
                                          "Item has no quantity",
                                          toastLength:
                                          Toast.LENGTH_SHORT,
                                          gravity:
                                          ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 18.0.sp);
                                    }

                                  }

                                }
                                // else {
                                //   controller.showToast(
                                //       "Please select a variation first");
                                // }

                              } else {


                                if( controller
                                    .selectedProduct.value.price?.quantity! != 0) {
                                  setState(() {

                                    isadding=true;
                                  });
                                  await controller.addToCart(
                                      widget.table.id.toString(),
                                      productId: controller
                                          .selectedProduct.value.id
                                          .toString(),
                                      qty: "1",
                                      vendorId: controller
                                          .restaurant.value.data!.id
                                          .toString());

                                  setState(() {
                                    isadding = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                      "Item Added in Cart",
                                      toastLength:
                                      Toast.LENGTH_SHORT,
                                      gravity:
                                      ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                      Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 18.0.sp);
                                }
                                else{
                                  Fluttertoast.showToast(
                                      msg:
                                      "Item has no quantity",
                                      toastLength:
                                      Toast.LENGTH_SHORT,
                                      gravity:
                                      ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                      Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 18.0.sp);
                                }
                              }
                            }
                          }}
                        },
                        child: Center(
                          child: Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: 10.sp),
                            height: MediaQuery.of(context).size.height*0.08.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(8.sp),
                                color: getAddToCartBtnBackground()),
                            child: isadding
                                ? kLoadingWidget(
                                loaderColor: BasicColors.white,
                                size: 18.sp)
                                : Center(
                              child: Text(
                                isAlreadyInCart()
                                    ? "viewCart".tr
                                    : "addToCart".tr,
                                style: TextStyle(
                                  color: BasicColors.white,
                                    fontSize: 18.sp
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      // for add to order
                          : InkWell(
                        onTap: () async {
                          print("heavyduty");
if(isadding){

}
                        else{
                        if (!controller.isUpdatingOrder.value &&
                              widget.table.ongoingOrder?.paymentStatus
                                  .toString() !=
                                  "1") {
                            print("heavyduty2");

                            if (isAlreadyInCart()) {
                              controller.isDrawerTypeCart.value = 1;
                              print("heavyduty3");
                            } else {
                              print("heavyduty4");

                              if (controller.selectedProduct.value
                                  .variants!.isNotEmpty) {
                                print("heavyduty5");

                                if (controller
                                    .selectedOptions.length ==
                                    controller.noOfOptions.value) {
                                  List<int> extrasIds = [];

                                  if (controller
                                      .selectedExtras.isNotEmpty) {
                                    controller.selectedExtras
                                        .forEach((key, ex) {
                                      controller.allExtras
                                          .forEach((element) {
                                        if (element.id == ex.id) {
                                          extrasIds.add(ex.id as int);
                                        }
                                      });
                                    });
                                  }
                                  print("heavyduty6");

                                  var selectedVariation =
                                  isVariationSelected(
                                      controller
                                          .selectedProduct.value,
                                      controller);
                                  if (selectedVariation != null) {
                                    print("heavyduty7");

                                    if (controller
                                        .selectedProduct.value.price
                                        ?.quantity! != 0){
                                      setState(() {

                                        isadding=true;
                                      });
                                      var r = await controller.addToCart(
                                          widget.table.id.toString(),
                                          productId: controller
                                              .selectedProduct.value.id
                                              .toString(),
                                          qty: "1",
                                          vendorId: controller
                                              .restaurant.value.data!.id
                                              .toString(),
                                          variationId: selectedVariation
                                              .id
                                              .toString(),
                                          extrasIds: extrasIds);
                                      setState(() {

                                        isadding=false;
                                      });
                                      Fluttertoast.showToast(
                                          msg:
                                          "Item Added in Cart",
                                          toastLength:
                                          Toast.LENGTH_SHORT,
                                          gravity:
                                          ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 18.0.sp);
                                      if (r != null) {
                                        if (r is bool) {
                                          if (r) {
                                            controller.isDrawerTypeCart
                                                .value = 1;
                                            widget.scaffoldKey
                                                .currentState!
                                                .openEndDrawer();
                                            print("heavyduty8");
                                          }
                                        }
                                      }
                                    }

                                    else{
                                      Fluttertoast.showToast(
                                          msg:
                                          "Item has no quantity",
                                          toastLength:
                                          Toast.LENGTH_SHORT,
                                          gravity:
                                          ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 18.0.sp);
                                    }

                                    // await controller.addToOrder(
                                    //     productId: controller
                                    //         .selectedProduct.value.id
                                    //         .toString(),
                                    //     qty: "1",
                                    //     orderId: widget.table.ongoingOrder!.id
                                    //         .toString(),
                                    //     variationId:
                                    //         selectedVariation.id.toString(),
                                    //     extrasIds: extrasIds);


                                  }
                                }
                                // else {
                                //   controller.showToast(
                                //       "Please select a variation first");
                                // }
                              } else {
                                print("heavyduty9");

                                if (controller
                                    .selectedProduct.value.price
                                    ?.quantity! != 0){
                                  setState(() {
                                    isadding=true;
                                  });
                                  var r = await controller.addToCart(
                                      widget.table.id.toString(),
                                      productId: controller
                                          .selectedProduct.value.id
                                          .toString(),
                                      qty: "1",
                                      vendorId: controller
                                          .restaurant.value.data!.id
                                          .toString());
                                  setState(() {

                                    isadding=false;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                      "Item Added in Cart",
                                      toastLength:
                                      Toast.LENGTH_SHORT,
                                      gravity:
                                      ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                      Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 18.0.sp);
                                  // await controller.addToOrder(
                                  //     productId: controller
                                  //         .selectedProduct.value.id
                                  //         .toString(),
                                  //     qty: "1",
                                  //     orderId: widget.table.ongoingOrder!.id
                                  //         .toString());
                                  if (r != null) {
                                    if (r is bool) {
                                      if (r) {
                                        controller
                                            .isDrawerTypeCart.value = 1;
                                        widget.scaffoldKey.currentState!
                                            .openEndDrawer();
                                        print("heavyduty10");
                                      }
                                    }
                                  }
                                }
                                else{
                                  Fluttertoast.showToast(
                                      msg:
                                      "Item has no quantity",
                                      toastLength:
                                      Toast.LENGTH_SHORT,
                                      gravity:
                                      ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                      Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 18.0.sp);
                                }

                              }
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 260),
                                    child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                4.0)),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          // overflow: Overflow.visible,
                                          alignment:
                                          Alignment.topCenter,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context).size.height* 0.5.h,
                                              width: MediaQuery.of(context).size.width* 0.6.w,
                                              // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.38: MediaQuery.of(context).size.height*0.25,
                                              // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.56:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.4: MediaQuery.of(context).size.width*0.39,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .fromLTRB(
                                                    10, 20, 10, 10),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Text(
                                                      "alert".tr,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize: 20.sp,
                                                          color:
                                                          BasicColors
                                                              .black),
                                                    ),
                                                    SizedBox(
                                                        height: 10.h),
                                                    Text(
                                                      "orderAlreadyPaid"
                                                          .tr,
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          fontSize: 20.sp,
                                                          color:
                                                          BasicColors
                                                              .black),
                                                    ),
                                                    Spacer(),
                                                    // SizedBox(
                                                    //   height: 30.h,
                                                    // ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .end,
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
                                                              child:
                                                              TextButton(
                                                                child: Text("yes".tr,
                                                                    style: TextStyle(
                                                                        color: BasicColors.white,
                                                                        fontSize: 22.sp)),
                                                                onPressed:
                                                                    () {
                                                                  Get.back();
                                                                  controller.completeOrder(
                                                                      orderId: widget.table.ongoingOrder!.id.toString(),
                                                                      gotoTables: true);
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
                                                top: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width *
                                                    -0.03.w,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                  Colors.redAccent,
                                                  radius: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.03.w,
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    color: Colors.white,
                                                    size: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        0.03.w,
                                                  ),
                                                )),
                                          ],
                                        )),
                                  );
                                });
                          }
                        }},
                        child: Center(
                          child: Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: 10),
                            height: MediaQuery.of(context).size.height*0.08.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: getAddToOrderBtnBackground(),
                            ),
                            child: isadding
                                ? kLoadingWidget(
                                loaderColor: BasicColors.white,
                                size: 25.sp)
                                : Center(
                              child: Text(
                                isAlreadyInCart()
                                    ? "viewCart".tr
                                    : "addToCart".tr,
                                style: TextStyle(
                                  color: BasicColors.white,
                                  fontSize: 20.sp
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: BasicColors.getWhiteBlackColor(),
                      ),
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "description".tr + '\n\n',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5.sp,
                                    color: BasicColors.secondaryColor)),
                            TextSpan(
                                text:
                                '${controller.selectedProduct.value.description}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  height: 1.3.h,
                                  color: BasicColors.getBlackWhiteColor(),
                                )),
                          ])),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool SquareisAlreadyInCart() {
    if (controller.scart.value.cartData != null) {
      if (controller.scart.value.cartData!.length > 0) {
        for (int x = 0; x < controller.scart.value.cartData!.length; x++) {
          CartDatumm cartItem = controller.scart.value.cartData![x];
          if (controller.selectedSquareProduct.value.squarevariants!.isEmpty) {
            if (cartItem.itemId == controller.selectedSquareProduct.value.id) {
              print("jutt");

              return true;
            }
          } else {
            print("jutt2");
            if (cartItem.itemId == controller.selectedSquareProduct.value.id) {
              // Get Selected Variation

              if (controller.selectedSquareProduct.value.squarevariants !=
                  null) {
                if (cartItem.squareCarItemModifiers == selectedVariation) {
                  return true;
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  bool isAlreadyInCart() {
    if (controller.cart.value.cartData != null) {
      if (controller.cart.value.cartData!.length > 0) {
        for (int x = 0; x < controller.cart.value.cartData!.length; x++) {
          CartItem cartItem = controller.cart.value.cartData![x];
          if (controller.selectedProduct.value.variants!.isEmpty) {
            if (cartItem.productId == controller.selectedProduct.value.id) {
              return true;
            }
          } else {
            if (controller.noOfOptions.value ==
                controller.selectedOptions.length) {
              if (cartItem.productId == controller.selectedProduct.value.id) {
                // Get Selected Variation
                var selectedVariation = isVariationSelected(
                    controller.selectedProduct.value, controller);
                if (selectedVariation != null) {
                  if (cartItem.variantId == selectedVariation.id) {
                    return true;
                  }
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  getAddToCartBtnBackground() {
    if (controller.selectedProduct.value.variants!.isEmpty) {
      return BasicColors.primaryColor;
    } else {
      if (controller.selectedOptions.length == controller.noOfOptions.value) {
        return BasicColors.primaryColor;
      } else {
        return BasicColors.secondaryColor;
      }
    }
  }

  getAddToOrderBtnBackground() {
    if (controller.selectedProduct.value.variants!.isEmpty) {
      return widget.table.ongoingOrder!.paymentStatus.toString() == "1"
          ? BasicColors.secondaryColor
          : BasicColors.primaryColor;
    } else {
      if (controller.selectedOptions.length == controller.noOfOptions.value) {
        return widget.table.ongoingOrder!.paymentStatus.toString() == "1"
            ? BasicColors.secondaryColor
            : BasicColors.primaryColor;
      } else {
        return BasicColors.secondaryColor;
      }
    }
  }

  static SquareVariant? isSquareVariationSelected(
      SquareProduct squareProduct, CommonController controller) {
    for (int z = 0; z < squareProduct.squarevariants!.length; z++) {
      SquareVariant variant = squareProduct.squarevariants![z];
      final stringToCheck = variant.title;
      List<String> valuesToCheck = [];
      for (int y = 0; y < controller.selectedOptions.length; y++) {
        valuesToCheck.add(
            "${controller.selectedOptions[squareProduct.squarevariants![y].id]}");
      }

      List<bool> isSelected =
      List.generate(valuesToCheck.length, (index) => false);

      for (int t = 0; t < valuesToCheck.length; t++) {
        if (stringToCheck!.contains(valuesToCheck[t])) {
          isSelected[t] = true;
        }
      }

      bool isVariationSelected = true;

      for (int r = 0; r < isSelected.length; r++) {
        if (!isSelected[r]) {
          isVariationSelected = false;
          break;
        }
      }

      if (isVariationSelected) {
        return SquareVariant();
      }
    }
    return null;
  }

  static Variant? isVariationSelected(
      Product product, CommonController controller) {
    for (int z = 0; z < product.variants!.length; z++) {
      Variant variant = product.variants![z];
      final stringToCheck = variant.options;
      List<String> valuesToCheck = [];
      for (int y = 0; y < controller.selectedOptions.length; y++) {
        valuesToCheck
            .add("${controller.selectedOptions[product.options![y].id]}");
      }

      List<bool> isSelected =
      List.generate(valuesToCheck.length, (index) => false);

      for (int t = 0; t < valuesToCheck.length; t++) {
        if (stringToCheck!.contains(valuesToCheck[t])) {
          isSelected[t] = true;
        }
      }

      bool isVariationSelected = true;

      for (int r = 0; r < isSelected.length; r++) {
        if (!isSelected[r]) {
          isVariationSelected = false;
          break;
        }
      }

      if (isVariationSelected) {
        return variant;
      }
    }
    return null;
  }

  // buildSquareOptions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(
  //           top: 10,
  //         ),
  //         child: Text(
  //           "selectVariation".tr,
  //           style: TextStyle(
  //               fontSize: 14, color: BasicColors.getBlackWhiteColor()),
  //         ),
  //       ),
  //       ListView.builder(
  //           physics: NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           itemCount:
  //               controller.selectedSquareProduct.value.squarevariants!.length,
  //           itemBuilder: (context, index) {
  //             var op =
  //                 controller.selectedSquareProduct.value.squarevariants![index];
  //             var allOptions = op.title!.split(',');
  //             var listOptions = [];
  //             allOptions.forEach(
  //               (opValue) {
  //                 if (index < 1) {
  //                   for (int x = 0;
  //                       x <
  //                           controller.selectedSquareProduct.value
  //                               .squarevariants!.length;
  //                       x++) {
  //                     SquareVariant variant = controller
  //                         .selectedSquareProduct.value.squarevariants![x];
  //                     if (variant.title!.contains(opValue)) {
  //                       // print(
  //                       // "${controller.cart.value.cartData![index].variantPrice}");
  //                       listOptions.add(opValue);
  //
  //                       break;
  //                     }
  //                   }
  //                 } else {
  //                   controller.selectedSquareProduct.value.squarevariants!
  //                       .forEach((variant) {
  //                     bool isToShow = isToShowSquareItem(
  //                         controller.selectedSquareProduct.value,
  //                         opValue,
  //                         variant,
  //                         index);
  //                     if (isToShow) {
  //                       // print(
  //                       //     "${controller.cart.value.cartData![index].variantPrice}");
  //                       listOptions.add(opValue);
  //                       // print(opValue);
  //                     }
  //                   });
  //                 }
  //               },
  //             );
  //             listOptions = listOptions.toSet().toList();
  //             return index > controller.selectedOptions.length
  //                 ? Container()
  //                 : Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                         margin: EdgeInsets.symmetric(vertical: 10),
  //                         child: Text(
  //                           // ${controller.cart.value.cartData![index].variantPrice != null ? double.parse(controller.cart.value.cartData![index].variantPrice.toString()) : double.parse("0.0")}
  //                           "${op.title}   ".toUpperCase(),
  //                           style: TextStyle(
  //                               fontSize: 14,
  //                               color: BasicColors.getBlackWhiteColor(),
  //                               fontWeight: FontWeight.w800),
  //                         ),
  //                       ),
  //                       // SizedBox(
  //                       //   height: 40,
  //                       //   child: ListView.builder(
  //                       //       scrollDirection: Axis.horizontal,
  //                       //       shrinkWrap: true,
  //                       //       itemCount: listOptions.length,
  //                       //       itemBuilder: (context, i) {
  //                       //         return Container(
  //                       //           margin: EdgeInsets.only(
  //                       //             right: 10,
  //                       //           ),
  //                       //           child: Obx(() => FilterItemLayout(
  //                       //                 title: listOptions[i],
  //                       //                 controller: controller,
  //                       //                 isActive:
  //                       //                     isActiveItem(op.id, listOptions[i]),
  //                       //                 onPressed: () {
  //                       //                   controller.selectedExtras.clear();
  //                       //                   var selectedOptionsLocal =
  //                       //                       <int, String>{};
  //                       //                   controller.selectedOptions[
  //                       //                       op.id!.toInt()] = listOptions[i];
  //                       //
  //                       //                   for (int q = 0; q <= index; q++) {
  //                       //                     selectedOptionsLocal[controller
  //                       //                             .selectedProduct
  //                       //                             .value
  //                       //                             .options![q]
  //                       //                             .id!
  //                       //                             .toInt()] =
  //                       //                         controller.selectedOptions[
  //                       //                             controller.selectedProduct
  //                       //                                 .value.options![q].id!
  //                       //                                 .toInt()] as String;
  //                       //                   }
  //                       //                   controller.selectedOptions.value =
  //                       //                       selectedOptionsLocal;
  //                       //
  //                       //                   controller.isVariationItemClicked
  //                       //                           .value =
  //                       //                       !controller
  //                       //                           .isVariationItemClicked.value;
  //                       //                 },
  //                       //               )),
  //                       //         );
  //                       //       }),
  //                       // )
  //                     ],
  //                   );
  //           }),
  //     ],
  //   );
  // }

  buildOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Text(
            "selectVariation".tr,
            style: TextStyle(
                fontSize: 20.sp, color: BasicColors.getBlackWhiteColor()),
          ),
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.selectedProduct.value.options!.length,
            itemBuilder: (context, index) {
              var op = controller.selectedProduct.value.options![index];
              var allOptions = op.options!.split(',');
              var listOptions = [];
              allOptions.forEach(
                    (opValue) {
                  if (index < 1) {
                    for (int x = 0;
                    x < controller.selectedProduct.value.variants!.length;
                    x++) {
                      Variant variant =
                      controller.selectedProduct.value.variants![x];
                      if (variant.options!.contains(opValue)) {
                        // print(
                        // "${controller.cart.value.cartData![index].variantPrice}");
                        listOptions.add(opValue);

                        break;
                      }
                    }
                  } else {
                    controller.selectedProduct.value.variants!
                        .forEach((variant) {
                      bool isToShow = isToShowItem(
                          controller.selectedProduct.value,
                          opValue,
                          variant,
                          index);
                      if (isToShow) {
                        // print(
                        //     "${controller.cart.value.cartData![index].variantPrice}");
                        listOptions.add(opValue);
                        // print(opValue);
                      }
                    });
                  }
                },
              );
              listOptions = listOptions.toSet().toList();
              return index > controller.selectedOptions.length
                  ? Container()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      // ${controller.cart.value.cartData![index].variantPrice != null ? double.parse(controller.cart.value.cartData![index].variantPrice.toString()) : double.parse("0.0")}
                      "${op.name}   ".toUpperCase(),
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: BasicColors.getBlackWhiteColor(),
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.06.h,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: listOptions.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Obx(() => FilterItemLayout(
                              title: listOptions[i],
                              controller: controller,
                              isActive:
                              isActiveItem(op.id, listOptions[i]),
                              onPressed: () {
                                controller.selectedExtras.clear();
                                var selectedOptionsLocal =
                                <int, String>{};
                                controller.selectedOptions[
                                op.id!.toInt()] = listOptions[i];

                                for (int q = 0; q <= index; q++) {
                                  selectedOptionsLocal[controller
                                      .selectedProduct
                                      .value
                                      .options![q]
                                      .id!
                                      .toInt()] =
                                  controller.selectedOptions[
                                  controller.selectedProduct
                                      .value.options![q].id!
                                      .toInt()] as String;
                                }
                                controller.selectedOptions.value =
                                    selectedOptionsLocal;

                                controller.isVariationItemClicked
                                    .value =
                                !controller
                                    .isVariationItemClicked.value;
                              },
                            )),
                          );
                        }),
                  )
                ],
              );
            }),
      ],
    );
  }

  bool isActiveItem(int? id, String itemValue) {
    if (controller.selectedOptions.length > 0) {
      for (int key in controller.selectedOptions.keys) {
        if (key == id && controller.selectedOptions[key] == itemValue) {
          return true;
        }
      }
    }
    return false;
  }

  //
  // bool isToShowSquareItem(SquareProduct squareProduct, String currentValue,
  //     SquareVariant variants, int i) {
  //   final stringToCheck = variants.title;
  //
  //   List<String> valuesToCheck = [];
  //
  //   for (int y = 0; y < i; y++) {
  //     valuesToCheck
  //         .add("${controller.selectedOptions[squareProduct.title![y]]}");
  //   }
  //   valuesToCheck.add(currentValue);
  //
  //   List<bool> isSelected =
  //       List.generate(valuesToCheck.length, (index) => false);
  //
  //   for (int t = 0; t < valuesToCheck.length; t++) {
  //     if (stringToCheck!.contains(valuesToCheck[t])) {
  //       isSelected[t] = true;
  //     }
  //   }
  //
  //   for (int r = 0; r < isSelected.length; r++) {
  //     if (!isSelected[r]) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  bool isToShowItem(
      Product product, String currentValue, Variant variant, int i) {
    final stringToCheck = variant.options;

    List<String> valuesToCheck = [];

    for (int y = 0; y < i; y++) {
      valuesToCheck
          .add("${controller.selectedOptions[product.options![y].id]}");
    }
    valuesToCheck.add(currentValue);

    List<bool> isSelected =
    List.generate(valuesToCheck.length, (index) => false);

    for (int t = 0; t < valuesToCheck.length; t++) {
      if (stringToCheck!.contains(valuesToCheck[t])) {
        isSelected[t] = true;
      }
    }

    for (int r = 0; r < isSelected.length; r++) {
      if (!isSelected[r]) {
        return false;
      }
    }
    return true;
  }

  // static buildSquareExtras(
  //   CommonController controller,
  // ) {
  //   controller.allExtras.clear();
  //   // controller.allExtras.assignAll(controller.selectedSquareProduct.value.extras!);
  //   if (controller.selectedOptions.length != controller.noOfOptions.value) {
  //     return Container();
  //   } else {
  //     var selectedVariation = isSquareVariationSelected(
  //         controller.selectedSquareProduct.value, controller);
  //     if (selectedVariation != null) {
  //       print("aaaaaa");
  //       print(selectedVariation.price);
  //       // totalPrice = (double.parse(selectedVariation.price.toString())
  //       //     .toStringAsFixed(Config.fractionDigits));
  //       sum = double.parse(totalPrice) +
  //           double.parse(selectedVariation.price.toString());
  //       print(sum);
  //
  //       if (selectedVariation.title!.isNotEmpty) {
  //         // if (selectedVariation.title!.length > 0) {
  //         //   selectedVariation.title!.forEach((ext) {
  //         //     controller.allExtras.add(ext);
  //         //     // print("total ${sum.toString()}");
  //         //   });
  //         // }
  //       }
  //     }
  //   }
  //
  //   //log("${controller.selectedProduct.value.toJson()}");
  //
  //   var selectedVariation;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
  //         child: Text(
  //           "extras".tr,
  //           style: TextStyle(
  //               fontSize: 14, color: BasicColors.getBlackWhiteColor()),
  //         ),
  //       ),
  //       Obx(
  //         () => ListView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: (controller.allExtras.isEmpty)
  //               ? 0
  //               : controller.allExtras.length,
  //           itemBuilder: (context, index) => Row(
  //             mainAxisSize: MainAxisSize.max,
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 child: Row(
  //                   children: [
  //                     Obx(
  //                       () => Checkbox(
  //                         side: BorderSide(
  //                             color: BasicColors.secondaryColor ?? Colors.grey),
  //                         activeColor: BasicColors.primaryColor,
  //                         checkColor: BasicColors.white,
  //                         value: controller.selectedExtras
  //                             .containsKey(controller.allExtras[index].id),
  //                         onChanged: (bool? value) {
  //                           if (value != null) {
  //                             // log("onChangedCalled");
  //                             if (value) {
  //                               controller.selectedExtras[
  //                                       controller.allExtras[index].id as int] =
  //                                   controller.allExtras[index];
  //                               extraPrice = double.parse(controller
  //                                   .allExtras[index].price
  //                                   .toString());
  //                               print(extraPrice);
  //                             } else {
  //                               controller.selectedExtras
  //                                   .remove(controller.allExtras[index].id);
  //                               extraPrice = 0.0;
  //                             }
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                     Text("${controller.allExtras[index].name}",
  //                         style: TextStyle(
  //                             color: BasicColors.secondaryColor,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w400)),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(right: 20),
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       "+",
  //                       style: TextStyle(
  //                           color: BasicColors.secondaryColor,
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w400),
  //                     ),
  //                     Text(
  //                       "\$ ${controller.allExtras[index].price.toString()}",
  //                       style: TextStyle(
  //                           color: BasicColors.secondaryColor,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w400),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Text(
  //             "SubTotal  ",
  //             style: TextStyle(
  //                 color: BasicColors.secondaryColor,
  //                 fontSize: 19,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //           Text(
  //             "\$${sum.toString()}",
  //             style: TextStyle(
  //                 color: BasicColors.secondaryColor,
  //                 fontSize: 19,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  buildExtras(
      CommonController controller,
      ) {
    controller.allExtras.clear();
    controller.allExtras.assignAll(controller.selectedProduct.value.extras!);
    if (controller.selectedOptions.length != controller.noOfOptions.value) {
      return Container();
    } else {
      var selectedVariation =
      isVariationSelected(controller.selectedProduct.value, controller);
      if (selectedVariation != null) {
        print("aaaaaa");
        print(selectedVariation.price);
        // totalPrice = (double.parse(selectedVariation.price.toString())
        //     .toStringAsFixed(Config.fractionDigits));
        sum = double.parse(totalPrice) +
            double.parse(selectedVariation.price.toString());
        print(sum);

        if (selectedVariation.extras!.isNotEmpty) {
          if (selectedVariation.extras!.length > 0) {
            selectedVariation.extras!.forEach((ext) {
              controller.allExtras.add(ext);
              // print("total ${sum.toString()}");
            });
          }
        }
      }
    }

    //log("${controller.selectedProduct.value.toJson()}");

    var selectedVariation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            "extras".tr,
            style: TextStyle(
                fontSize: 20.sp, color: BasicColors.getBlackWhiteColor()),
          ),
        ),
        Obx(
              () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (controller.allExtras.isEmpty)
                  ? 0
                  : controller.allExtras.length,
              itemBuilder: (context, index){
                // priice=controller.allExtras[index].price.toString();
                return  Row(

                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Obx(
                                () => Checkbox(
                              side: BorderSide(
                                  color: BasicColors.secondaryColor ?? Colors.grey),
                              activeColor: BasicColors.primaryColor,
                              checkColor: BasicColors.white,
                              value: controller.selectedExtras
                                  .containsKey(controller.allExtras[index].id),
                              onChanged: (bool? value) {

                                if (value != null) {
                                  // log("onChangedCalled");
                                  if (value) {
                                    controller.selectedExtras[
                                    controller.allExtras[index].id as int] =
                                    controller.allExtras[index];
                                    extraPrice = double.parse(controller
                                        .allExtras[index].price
                                        .toString());

                                    print(extraPrice);
                                    setState(() {});
                                  } else {
                                    controller.selectedExtras
                                        .remove(controller.allExtras[index].id);
                                    extraPrice = 0.0;
                                  }
                                  setState(() {});

                                }

                              },
                            ),
                          ),
                          Text("${controller.allExtras[index].name}",
                              style: TextStyle(
                                  color: BasicColors.secondaryColor,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "+",
                            style: TextStyle(
                                color: BasicColors.secondaryColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "\$ ${controller.allExtras[index].price.toString()}",
                            style: TextStyle(
                                color: BasicColors.secondaryColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                );}
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "SubTotal  ",
              style: TextStyle(
                  color: BasicColors.secondaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
            extraPrice==null?   Text(
              "\$${sum.toString()}",
              style: TextStyle(
                  color: BasicColors.secondaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ):
            Text(
              "\$${double.parse(sum.toString())+double.parse(extraPrice.toString())}",
              style: TextStyle(
                  color: BasicColors.secondaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class FilterItemLayout extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final CommonController controller;
  bool isActive = false;

  FilterItemLayout(
      {Key? key,
        required this.title,
        required this.controller,
        required this.onPressed,
        required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: isActive
            ? BasicColors.primaryColor
            : BasicColors.secondSecondaryColor,
      ),
      child: SizedBox(
        child: Text(
          title,
          style: isActive
              ? TextStyle(
              color: controller.isDarkTheme.value
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold, fontSize: 20.sp)
              : TextStyle(
            color: BasicColors.black,
              fontSize: 20.sp
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}