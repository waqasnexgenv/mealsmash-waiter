import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'colors.dart';

class Strings {
  static String appName = "MealSmash Waiter";
  static String keyDbName = "shared";
  static String keyUser = "user";
  static String keyIsDarkTheme = "keyIsDarkTheme";
  static String keySelectedLanguage = "keySelectedLanguage";
  static String keyIsFirstTime = "keyIsFirstTime";
  static String mealSmash = "MealSmash";
  static String ordering = "Waiter";

  static String sampleEmailHint = "example@mealsmash.com";
  static String samplePasswordHint = "********";
  // static String baseUrl = "https://dev.mealsmash.com/api/mealsmash_order_app/";
  // static String baseUrl = "https://mealsmash-dev.crazyphpscripts.com/api/mealsmash_order_app/";
  static String baseUrl = "https://mealsmash.drivethrukiosk.com/api/mealsmash_order_app/";
  // static String test = "https://mealsmash-dev.crazyphpscripts.com/api/mealsmash_kot_app/";
  // static String baseUrl = "http://mealsmashtest.crazyphpscripts.com/api/mealsmash_order_app/";
  static String loginUrl = baseUrl + "login";
  static String saveOrderUrl = baseUrl + "saveOrder/";
  static String applyDiscountUrl = baseUrl + "discount";
  static String tablesUrl = baseUrl + "tables/";
  static String floorsUrl = baseUrl + "floors";
  static String pastOrdersUrl = baseUrl + "past_orders";

  static String placeOrderUrl = baseUrl + "order_place";
  static String cancelOrderUrl = baseUrl + "cancel_order/";
  static String completeOrderUrl = baseUrl + "complete_order/";
  static String searchUrl = baseUrl + "search/";
  static String categoriesUrl = baseUrl + "categories";
  static String modifiersUrl = baseUrl + "square/modifiers";
  static String cartUrl = baseUrl + "cart/";
  static String squarecartUrl = baseUrl + "square_get_cart";
  static String addToCartUrl = baseUrl + "add_to_cart";
  static String squareaddToCartUrl = baseUrl + "square_add_to_cart";
  static String addToOrderUrl = baseUrl + "add_order_product";
  static String deleteCartItemUrl = baseUrl + "delete_item";
  static String SQdeleteCartItemUrl = baseUrl + "square_cart_itemDel";
  static String updateCartItemQtyUrl = baseUrl + "update_qty";
  static String updateSquareCartItemQtyUrl = baseUrl + "square_cart_qtyUpdate";
  static String payAtCounterUrl = baseUrl + "pay_at_counter/";
  static String removeItemFromOrderUrl = baseUrl + "remove_order_product/";
  static String qtyIncrementOrderItemUrl = baseUrl + "order_qty_increment/";
  static String qtyDecrementOrderItemUrl = baseUrl + "order_qty_decrement/";
  static String bullsEyeTokenUrl = baseUrl + "get_bullseye_token/";
  static String checkBullsEyePaymentStatusUrl =
      baseUrl + "check_bullseye_payment/";

  static String convertArrayToCommaSeparatedString(List<dynamic> data) {
    String s = "";
    for (int i = 0; i < data.length; i++) {
      if (i == 0) {
        s = data[i];
      } else {
        s = s + ", ${data[i]}";
      }
    }
    return s.trim();
  }
}

Widget kLoadingWidget({Color? loaderColor, double? size}) => Center(
      child: SpinKitFadingCube(
        color: loaderColor ?? BasicColors.primaryColor,
        size: size ?? 55.0.sp,
      ),
    );
