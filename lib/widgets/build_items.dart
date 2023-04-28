import 'dart:developer';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';
import 'package:hungerz_ordering/helper/colors.dart';
import 'package:hungerz_ordering/helper/config.dart';
import 'package:hungerz_ordering/helper/strings.dart';
import 'package:hungerz_ordering/model/categories_response.dart';
import 'package:hungerz_ordering/model/squarecategories.dart';
import 'package:hungerz_ordering/pages/item_info.dart';

class BuildSquareItems {
  var store_id;

  static Widget build(
      List<SquareProduct> squareProduct,
      CommonController controller,
      GlobalKey<ScaffoldState> scaffoldKey,
      store_id) {
    return store_id == null
        ? kLoadingWidget()
        : GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
                top: 16, bottom: 16, start: 16, end: 32),
            itemCount: squareProduct.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              SquareProduct product = squareProduct[index];
              return GestureDetector(
                onTap: () {
                  // print("aliffff");

                  var item_id = product.id;
                  // var store_id = store_id;

                  // print("aliffff${store_id}");
                  controller.getModifiers(item_id: item_id, store_id: store_id);
                  FocusScope.of(scaffoldKey.currentContext!)
                      .requestFocus(FocusNode());
                  product.picture.toString();
                  controller.selectedSquareProduct.value = product;
                  controller.selectedCategoryName.value = controller
                      .scategories
                      .value
                      .scategories![controller.sqselectedCategoryIndex.value]
                      .name!;
                  controller.isDrawerTypeCart.value = 2;
                  scaffoldKey.currentState!.openEndDrawer();
                  // print("aliffff2222");
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: BasicColors.getWhiteBlackColor()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 22,
                        child: Stack(
                          children: [
                            FadedScaleAnimation(
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    image: DecorationImage(
                                        image:
                                            NetworkImage("${product.picture}"),
                                        fit: BoxFit.fill)),
                              ),
                              durationInMilliseconds: 400,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${product.title}",
                          style: TextStyle(
                              fontSize: 14,
                              color: BasicColors.getBlackWhiteColor()),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            FadedScaleAnimation(
                              Image.asset(
                                'assets/ic_veg.png',
                                scale: 2.5,
                              ),
                              durationInMilliseconds: 400,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              Config.currencySymbol +
                                  ("${product.price?.price}"),
                              style: TextStyle(
                                  color: BasicColors.getBlackWhiteColor()),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              );
            });
  }
}

class BuildItems {
  static Widget build(List<Product> products, CommonController controller,
      GlobalKey<ScaffoldState> scaffoldKey) {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        padding:
            EdgeInsetsDirectional.only(top: 16, bottom: 16, start: 10, end: 20),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1),
        itemBuilder: (context, index) {
          Product product = products[index];
          return GestureDetector(
            onTap: () {
              // print("7");
              if(product.price?.quantity!=0){
              FocusScope.of(scaffoldKey.currentContext!)
                  .requestFocus(FocusNode());
              controller.selectedProduct.value = product;
              controller.selectedCategoryName.value = controller
                  .categories
                  .value
                  .categories![controller.selectedCategoryIndex.value]
                  .name!;
              controller.isDrawerTypeCart.value = 2;
              scaffoldKey.currentState!.openEndDrawer();
              // print("8");
            }
              else{
                EasyLoading.showToast('item not available');
                // Fluttertoast.showToast(
                //     msg:
                //     "item not available",
                 //     toastLength:
                //     Toast.LENGTH_SHORT,
                //     gravity:
                //     ToastGravity.BOTTOM,
                //     timeInSecForIosWeb: 1,
                //     backgroundColor:
                //     Colors.red,
                //     textColor: Colors.white,
                //     fontSize: 18.0.sp);
              }
              },
            child:

            product.price?.quantity==0?
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: BasicColors.getWhiteBlackColor()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 22,
                    child: Stack(
                      children: [
                        FadedScaleAnimation(
                          Container(

                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10.sp)),
                                image: DecorationImage(
colorFilter: ColorFilter.mode( Colors.white,
  BlendMode.saturation,),
                                    image: NetworkImage("${product.picture}"),
                                    fit: BoxFit.fill)),
                          ),
                          durationInMilliseconds: 400,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "${product.title}",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: BasicColors.getBlackWhiteColor()),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        FadedScaleAnimation(
                          Image.asset(
                            'assets/ic_veg.png',
                            scale: 2.5,
                            color: Colors.grey,
                          ),
                          durationInMilliseconds: 400,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(

                          child: Text(
                            Config.currencySymbol+double.parse("${product.total}")
                                    .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(

                                color: BasicColors.getBlackWhiteColor(),fontSize: 20.sp),
                            softWrap: true, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Qty'+(" ${product.price?.quantity}")
                          ,
                          style: TextStyle(

                              color: BasicColors.getBlackWhiteColor(),fontSize: 20.sp),
                          softWrap: true, overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            )


                : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: BasicColors.getWhiteBlackColor()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 22,
                    child: Stack(
                      children: [
                        FadedScaleAnimation(
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10.sp)),
                                image: DecorationImage(
                                    image: NetworkImage("${product.picture}"),
                                    fit: BoxFit.fill)),
                          ),
                          durationInMilliseconds: 400,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.0.sp),
                    child: Text(
                      "${product.title}",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: BasicColors.getBlackWhiteColor()),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        FadedScaleAnimation(
                          Image.asset(
                            'assets/ic_veg.png',
                            scale: 2.5.sp,
                          ),
                          durationInMilliseconds: 400,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(

                          child: Text(
                            Config.currencySymbol+double.parse("${product.total}")
                                .toStringAsFixed(Config.fractionDigits),
                            style: TextStyle(

                                color: BasicColors.getBlackWhiteColor(),fontSize: 14.sp),
                            softWrap: true, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                         'Qty'+(" ${product.price?.quantity}")
                              ,
                          style: TextStyle(

                              color: BasicColors.getBlackWhiteColor(),fontSize: 14.sp),
                          softWrap: true, overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            )
            ,
          );
        });
  }
}
