// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_usb_printer/flutter_usb_printer.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:Mealsmash_Waiter/helper/colors.dart';
// import 'package:Mealsmash_Waiter/helper/routes.dart';
// import 'package:Mealsmash_Waiter/helper/strings.dart';
// import 'package:Mealsmash_Waiter/model/Scart.dart';
// import 'package:Mealsmash_Waiter/model/Sorder.dart';
// import 'package:Mealsmash_Waiter/model/area_response.dart';
// import 'package:Mealsmash_Waiter/model/cart_response.dart';
// import 'package:Mealsmash_Waiter/model/categories_response.dart';
// import 'package:Mealsmash_Waiter/model/login_response.dart';
// import 'package:Mealsmash_Waiter/model/modifiers.dart';
// import 'package:Mealsmash_Waiter/model/order.dart';
// import 'package:Mealsmash_Waiter/model/squarecategories.dart';
// import 'package:Mealsmash_Waiter/model/tables_response.dart';
//
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'service/base_client.dart';
//
// class CommonController extends GetxController {
//   var isDarkTheme = false.obs;
//   var selectedLanguage = "en".obs;
//   final localStorage = GetStorage(Strings.keyDbName);
//   var isLoginBtnClicked = false.obs;
//   var restaurant = LoginResponse().obs;
//   var tables = TablesResponse().obs;
//   var areaNames = <AreaResponse>[].obs;
//   var categories = CategoriesResponse().obs;
//   var scategories = SquareData().obs;
//   var cart = CartResponse().obs;
//   var scart = SCart().obs;
//   var searchResult = <Product>[].obs;
//   var isLoadingTables = false.obs;
//   var isPlacingOrder = false.obs;
//   var isLoadingCategories = false.obs;
//   var isLoadingSquareCategories = false.obs;
//   var isUpdatingOrder = false.obs;
//   var isLoadingCart = false.obs;
//   var isMakingPayment = false.obs;
//   var isDrawerTypeCart = 0.obs;
//   var isCancelingOrder = false.obs;
//   var isSavingOrder = false.obs;
//   var isApplyingDiscount = false.obs;
//   var isDiscountBtnClicked = false.obs;
//   var isCompletingOrder = false.obs;
//   var isSearchingItems = false.obs;
//   var isVariationItemClicked = false.obs;
//   var isUpdatingCart = false.obs;
//   var isDoingCartIncrementDecrement = false.obs;
//   var selectedProduct = Product().obs;
//   var selectedSquareProduct = SquareProduct().obs;
//   var Modifiers = Modifier().obs;
//
//   var selectedCategoryName = "".obs;
//   var selectedCategoryIndex = 0.obs;
//   var sqselectedCategoryIndex = 0.obs;
//   var noOfOptions = 0.obs;
//   var selectedOptions = <int, String>{}.obs;
//   var selectedVariation = <int, String>{}.obs;
//   var allExtras = <Extra>[].obs;
//   var selectedExtras = Map<int, Extra>().obs;
//   var allModifiers = <Modifier>[].obs;
//   var selectedModifier = Map<int, Modifier>().obs;
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   String orderId = '0';
//   var printerVendorId;
//   var printerProductId;
//   FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
//   bool connected = false;
//   bool returned = true;
//   var pref;
//   var platform;
//   String vendor_id = "";
//   List<OrderMeta> orderMeta = <OrderMeta>[];
//   // List<Ordermeta> orderMetaa = <Ordermeta>[];
//
//   String? previousClickedCartItem;
//   int? previousClickedCartItemIndex;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getThemeFromStorage();
//     getSelectedLanguage();
//   }
//
//   Future<bool> isFirstTime() async {
//     var res = await localStorage.read(Strings.keyIsFirstTime);
//     if (res != null) {
//       return !res;
//     }
//     return true;
//   }
//
//   Future<void> setNotFirstTime() async {
//     await localStorage.write(Strings.keyIsFirstTime, true);
//   }
//
//   Future<void> getSelectedLanguage() async {
//     var res = await localStorage.read(Strings.keySelectedLanguage);
//     if (res != null) {
//       selectedLanguage.value = res;
//       Get.updateLocale(Locale(selectedLanguage.value));
//       return;
//     }
//     selectedLanguage.value = "en";
//     Get.updateLocale(Locale(selectedLanguage.value));
//   }
//
//   Future<void> setSelectedLanguage({required String languageCode}) async {
//     await localStorage.write(Strings.keySelectedLanguage, languageCode);
//     selectedLanguage.value = languageCode;
//     Get.updateLocale(Locale(selectedLanguage.value));
//   }
//
//   Future<void> getThemeFromStorage() async {
//     var res = await localStorage.read(Strings.keyIsDarkTheme);
//     if (res != null) {
//       isDarkTheme.value = res;
//       return;
//     }
//     isDarkTheme.value = false;
//   }
//
//   Future<void> setDarkTheme({required bool enableDarkTheme}) async {
//     await localStorage.write(Strings.keyIsDarkTheme, enableDarkTheme);
//     isDarkTheme.value = enableDarkTheme;
//   }
//
//   showToast(String message) {
//     Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: BasicColors.primaryColor,
//         textColor: BasicColors.white,
//         fontSize: 16.0);
//   }
//
//   Future<bool> isLogin() async {
//     var res = await localStorage.read(Strings.keyUser);
//     if (res != null) {
//       restaurant.value = LoginResponse.fromJson(res);
//       if (restaurant.value.token == null) {
//         print("heeyyyyy1");
//         return false;
//       } else {
//         print("heeyyyyy2");
//
//         return true;
//       }
//     }
//     restaurant.value = LoginResponse();
//     return false;
//   }
//
//   Future<bool> logOutUser() async {
//     await localStorage.remove(Strings.keyUser);
//     await Get.offAllNamed(PageRoutes.loginPage);
//     return true;
//   }
//
//   Future<bool> saveCredentials(LoginResponse loginResponse) async {
//     await localStorage.write(Strings.keyUser, loginResponse.toJson());
//     return await isLogin();
//   }
//
//   getFloorsDetail({bool showLoading = true}) async {
//     areaNames = <AreaResponse>[].obs;
//     if (showLoading) {
//       isLoadingTables.value = true;
//     }
//
//     var response = await BaseClient().getWithAuth(Strings.floorsUrl);
//     if (response != null) {
//       var decodedResponse = jsonDecode(response.body);
//       // log(decodedResponse.toString());
//       if (decodedResponse['status']) {
//         var data = decodedResponse['data'];
//
//         print("Floor name:  ");
//         // print(data[0]['name'].toString());
//         // log(data['tables'].toString());
//
//         for (int d = 0; d < data.length; d++) {
//           // for (int i = 0; i < d!.length; i++) {
//           // print(data != null ? data[d]['name'].toString() : "aa");
//           var da =
//               List<AreaResponse>.from(data.map((x) => AreaResponse.fromMap(x)));
//           areaNames.value = da;
//
//           // tables.value = TablesResponse.fromJson(data[d]['tables']);
//           // }
//         }
//       }
//     }
//     if (showLoading) {
//       isLoadingTables.value = false;
//     }
//   }
//
//   getTablesDetail({bool showLoading = true, String floorId = ''}) async {
//     //tables = TablesResponse().obs;
//     notifyChildrens();
//     if (showLoading) {
//       isLoadingTables.value = true;
//     }
//     var response = await BaseClient().getWithAuth(
//       Strings.tablesUrl + floorId,
//     );
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse != null) {
//           print("waqas");
//           print(decodedResponse);
//           // var data = decodedResponse['data'];
//           // print("Floor name: ");
//           // // print(data[0]['name'].toString());
//           // // log(data['tables'].toString());
//           //
//           // for (int d = 0; d < data.length; d++) {
//           //   // for (int i = 0; i < d!.length; i++) {
//           //   // print(data != null ? data[d]['name'].toString() : "aa");
//           //   var da = List<AreaResponse>.from(
//           //       data.map((x) => AreaResponse.fromMap(x)));
//           //   areaNames.value = da;
//           //   print("check:");
//           //   print(da[0].floorId);
//           //   // tables.value = TablesResponse.fromJson(data[d]['tables']);
//           //   // }
//           // }
//
//           // log(data.toString());
//
//           print("hellllll");
//
//           tables.value = TablesResponse.fromJson(response.body);
//           update();
//
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     if (showLoading) {
//       isLoadingTables.value = false;
//     }
//   }
//   // Stream<Product> productsStream() async* {
//   //   while (true) {
//   //     await Future.delayed(Duration(milliseconds: 500));
//   //     Product someProduct = getProductFromAPI();
//   //     yield someProduct;
//   //   }
//   // }
//
//   checkPaymentStatusBullsEye({required String orderId}) async {
//     var response = await BaseClient()
//         .getWithAuth(Strings.checkBullsEyePaymentStatusUrl + orderId);
//     if (response != null) {
//       try {
//         // print(response.body);
//
//         var decodedResponse = jsonDecode(response.body);
//         // log(decodedResponse['order'].toString());
//         if (decodedResponse['status']) {
//           var tableName = decodedResponse['table_id'];
//           var orderListData = decodedResponse['order'];
//           var invoiceId = orderListData['inv_id'];
//           var paymentMethod = orderListData['payment_method'];
//           var billTotal = orderListData['total'];
//           var bill
//           SubTotal = orderListData['subtotal'];
//           var billTax = orderListData['tax'];
//           var billDiscount = orderListData['discount'];
//           var totalItems = orderListData['item'];
//           var paymentStatus = orderListData['payment_status'];
//           var orderTypeStatus = orderListData['order_type_status'];
//           var orderCreatedAt = orderListData['created_at'];
//
//           // print(invoiceId);
//           // print(paymentMethod);
//           // print(billTotal);
//           // print(billSubTotal);
//           // print(billTax);
//           // print(billDiscount);
//           // print(totalItems);
//
//           print(decodedResponse['order']['ordermeta']);
//           if (decodedResponse['order']['ordermeta'] != null) {
//             orderMeta = [];
//             decodedResponse['order']['ordermeta'].forEach((v) {
//               orderMeta.add(new OrderMeta.fromMap(v));
//             });
//           }
//           // print("lisssstttttssss");
//
//           testPrint(
//             orderMeta,
//             invoiceId,
//             paymentMethod,
//             billTotal,
//             billSubTotal,
//             billTax,
//             billDiscount,
//             totalItems,
//             paymentStatus,
//             orderTypeStatus,
//             orderCreatedAt,
//             tableName,
//           );
//           return true;
//         } else {
//           // showToast(
//           //     "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//   }
//
//   Future<dynamic> placeOrder(
//       String tableId, String orderType, String platform) async {
//     log("Table Id: $tableId");
//     log(orderType);
//     var response = await BaseClient().postWithAuth(Strings.placeOrderUrl,
//         {'table_id': tableId, 'order_type': orderType, 'platform': platform});
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           print("yesssss2");
//           // getFloorsDetail();
//           getTablesDetail();
//           print("daniyal${decodedResponse['order']}");
//           SQOrder? mySOrder;
//           Order? myOrder;
//           print("Goodplatform${platform}");
//
//           if (platform == "SQUARE") {
//             print("happy${mySOrder}");
//
//             mySOrder = SQOrder.fromMap(decodedResponse['order']);
//             print("asdadsa${mySOrder}");
//           } else {
//             myOrder = Order.fromMap(decodedResponse['order']);
//             print("qqqqqqq${myOrder}");
//           }
//           // print(decodedResponse['order']);
//           // myOrder.tax = decodedResponse['order']['tax'];
//           // myOrder.subtotal = decodedResponse['order']['subtotal'];
//           // myOrder.discount = decodedResponse['order']['discount'];
//           print("yesssss");
//           return {
//             "orderId": "${decodedResponse['order_id']}",
//             "price": "${decodedResponse['order_price']}",
//             "order": platform == "SQUARE" ? mySOrder : myOrder,
//           };
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//   }
//
//   cancelOrder(String orderId) async {
//     isCancelingOrder.value = true;
//     var response =
//         await BaseClient().getWithAuth(Strings.cancelOrderUrl + orderId);
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           // Order Cancelled Goto Tables Page
//           getTablesDetail();
//           Get.offAllNamed(PageRoutes.splashPage);
//         } else {
//           print("okaayyyyy");
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Cannot cancel Order because payment was already paid                                                                                                  "}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isCancelingOrder.value = false;
//   }
//
//   completeOrder({required String orderId, bool gotoTables = false}) async {
//     isCompletingOrder.value = true;
//     log("Order Id - $orderId");
//     var response =
//         await BaseClient().getWithAuth(Strings.completeOrderUrl + orderId);
//     if (response != null) {
//       print("orderidds"+orderId);
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           // Order Cancelled Goto Tables Page
//           getTablesDetail();
//           if (gotoTables) {
//             Get.offAllNamed(PageRoutes.splashPage);
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isCompletingOrder.value = false;
//   }
//
//   getModifiers({required item_id, required store_id}) async {
//     isLoadingSquareCategories.value = true;
//     var response = await BaseClient().postWithAuth(Strings.modifiersUrl, {
//       'item_id': item_id,
//       'store_id': store_id,
//     });
//     if (response != null) {
//       try {
//         var jsonData = jsonDecode(response.body);
//         print("wooooww");
//
//         if (jsonData != null) {
//           print("wooooww");
//           print(jsonData);
//           pref = await SharedPreferences.getInstance();
//           // platform = jsonData['platform_configured'].toString();
//           // print(platform);
//           // pref.setString('platform_configured', platform);
//           Modifiers.value = Modifier.fromJson(jsonData);
//         } else {
//           showToast(
//               "${jsonData['message'] ?? jsonData['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isLoadingSquareCategories.value = false;
//   }
//
//   getSquareCategoriesDetail() async {
//     isLoadingSquareCategories.value = true;
//     var response = await BaseClient().getWithAuth(Strings.categoriesUrl);
//     if (response != null) {
//       try {
//         var jsonData = jsonDecode(response.body);
//         print("wooooww");
//
//         if (jsonData != null) {
//           print("wooooww");
//           print(jsonData);
//           pref = await SharedPreferences.getInstance();
//
//           vendor_id = jsonData['vendor_id'].toString();
//           pref.setString('vendor_id', vendor_id);
//           print("wweewwee${vendor_id}");
//           platform = jsonData['platform_configured'].toString();
//           print("dddddddddddd${platform}");
//           pref.setString('platform_configured', platform);
//           var platform2;
//           platform2 = pref.getString('platform_configured');
//           print("12344545425${platform2}");
//
//           scategories.value = SquareData.fromJson(jsonData);
//         } else {
//           showToast(
//               "${jsonData['message'] ?? jsonData['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isLoadingSquareCategories.value = false;
//   }
//
//   getCategoriesDetail() async {
//     isLoadingCategories.value = true;
//     var response = await BaseClient().getWithAuth(Strings.categoriesUrl);
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         pref = await SharedPreferences.getInstance();
//         vendor_id = decodedResponse['vendor_id'].toString();
//         pref.setString('vendor_id', vendor_id);
//         print("wweewwee${vendor_id}");
//         platform = decodedResponse['platform_configured'].toString();
//         print("dddddddddddd${platform}");
//         pref.setString('platform_configured', platform);
//         var platform2;
//         platform2 = pref.getString('platform_configured');
//         print("12344545425${platform2}");
//
//         if (decodedResponse['status']) {
//           print("errorishere${decodedResponse['status']}");
//           categories.value = CategoriesResponse.fromJson(response.body);
//           print("woooowwwooooww");
//         } else {
//           print("errorishere");
//
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         print("errorishere");
//
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isLoadingCategories.value = false;
//   }
//
//   removeItemFromOrder(int orderItemId) async {
//     isUpdatingOrder.value = true;
//
//     var response = await BaseClient().getWithAuth(
//         Strings.removeItemFromOrderUrl + "${orderItemId.toString()}");
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           await getTablesDetail();
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isUpdatingOrder.value = false;
//   }
//
//   qtyIncrementOrderItem(int orderItemId) async {
//     //  isUpdatingOrder.value = true;
//
//     var response = await BaseClient().getWithAuth(
//         Strings.qtyIncrementOrderItemUrl + "${orderItemId.toString()}");
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           await getTablesDetail();
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     //  isUpdatingOrder.value = false;
//   }
//
//   qtyDecrementOrderItem(int orderItemId) async {
//     //isUpdatingOrder.value = true;
//
//     var response = await BaseClient().getWithAuth(
//         Strings.qtyDecrementOrderItemUrl + "${orderItemId.toString()}");
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           await getTablesDetail();
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     //  isUpdatingOrder.value = false;
//   }
//
//   getSquareCart(
//     String tableId,
//   ) async {
//     isLoadingCart.value = true;
//     print("qqqqqqq");
//     var response = await BaseClient().getWithAuth(Strings.squarecartUrl);
//     if (response != null) {
//       print("aa gaya");
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           scart.value = SCart.fromJson(response.body);
//
//           // print("hello ${response}");
//         } else {
//           scart.value = SCart();
//           // showToast("${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isLoadingCart.value = false;
//   }
//
//   getCart(
//     String tableId,
//   ) async {
//     isLoadingCart.value = true;
//     print("qqqqqqq");
//     var response = await BaseClient().getWithAuth(Strings.cartUrl + tableId);
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           cart.value = CartResponse.fromJson(response.body);
//
//           // print("hello ${response}");
//         } else {
//           cart.value = CartResponse();
//           // showToast("${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isLoadingCart.value = false;
//   }
//
//   searchItems(String text) async {
//     isSearchingItems.value = true;
//
//     var response = await BaseClient().getWithAuth(Strings.searchUrl + text);
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           var data = List<Product>.from(
//               decodedResponse["data"].map((x) => Product.fromMap(x)));
//
//           searchResult.value = data;
//         } else {
//           // showToast("${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isSearchingItems.value = false;
//   }
//
//   SquareaddToCart({
//     required List<ModifierElement> modifiers,
//     required String image,
//     product_currency,
//     required String vendor_id,
//     required int tax_value,
//     required int qty,
//     product_price,
//     product_name,
//     product_id,
//   }) async {
//     var response = await BaseClient().postWithAuth(Strings.squareaddToCartUrl, {
//       "qty": qty.toString(),
//       "product_id": product_id.toString(),
//       "product_name": product_name,
//       "product_price": product_price,
//       "tax_value": tax_value,
//       "vendor_id": vendor_id,
//       "product_currency": product_currency,
//       "image": image,
//       "modifiers": modifiers,
//     });
//     if (response != null) {
//       print("response received after add to cart!");
//       print(jsonDecode(response.body));
//       try {
//         var decodedResponse = jsonDecode(response.body);
//
//         // log(decodedResponse);
//         if (decodedResponse['status']) {
//           try {
//             if (decodedResponse['cart'] != null) {
//               scart.value = SCart.fromJson(decodedResponse['cart']);
//             }
//             return true;
//           } catch (e) {
//             parseErrorOccurred(
//                 "Assigning Value to Cart Variable 1${e.toString()}");
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isUpdatingCart.value = false;
//   }
//
//   addToCart(String tableId,
//       {required String productId,
//       required String qty,
//       required String vendorId,
//       String? variationId,
//       List<int>? extrasIds}) async {
//     log("Extra Ids $extrasIds");
//     // isUpdatingCart.value = true;
//     var response = await BaseClient().postWithAuth(Strings.addToCartUrl, {
//       'table_id': tableId,
//       'vendor_id': vendorId,
//       'product_id': productId,
//       'qty': qty,
//       'variation_id': variationId,
//       'extras': extrasIds ?? '',
//     });
//     if (response != null) {
//       print("response received after add to cart! my body");
//       print(jsonDecode(response.body));
//       try {
//         var decodedResponse = jsonDecode(response.body);
//
//         // log(decodedResponse);
//         if (decodedResponse['status']) {
//           try {
//             print("jguysdw ${decodedResponse['cart']}");
//
//             if (decodedResponse['cart'] != null) {
//               cart.value = CartResponse.fromMap(decodedResponse['cart']);
//             }
//             return true;
//           } catch (e) {
//             parseErrorOccurred(
//                 "Assigning Value to Cart Variable 2${e.toString()}");
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//
//     isUpdatingCart.value = false;
//   }
//
//   addToOrder({required int? orderId, required String platform}) async {
//     // isUpdatingOrder.value = true;
//     var response = await BaseClient().postWithAuth(
//         Strings.addToOrderUrl, {'order_id': orderId, 'platform': platform});
//     if (response != null) {
//       print("after add TO ORDER:::");
//       print(jsonDecode(response.body));
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           await getTablesDetail();
//           isUpdatingOrder.value = false;
//           return true;
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isUpdatingOrder.value = false;
//   }
//
//   SqremoveCartItem({required int cartItemId, required String tableId}) async {
//     isUpdatingCart.value = true;
//     var response =
//         await BaseClient().postWithAuth(Strings.SQdeleteCartItemUrl, {
//       'cart_item_id': cartItemId,
//       // 'table_id': tableId,
//     });
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           try {
//             if (decodedResponse['cart']['status']) {
//               print("remove::");
//               scart.value = SCart.fromJson(decodedResponse['cart']);
//             } else {
//               scart.value = SCart();
//             }
//           } catch (e) {
//             parseErrorOccurred(
//                 "Assigning Value to Cart Variable 3${e.toString()}");
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isUpdatingCart.value = false;
//   }
//
//   removeCartItem({required int cartItemId, required String tableId}) async {
//     isUpdatingCart.value = true;
//     var response = await BaseClient().postWithAuth(Strings.deleteCartItemUrl, {
//       'cart_id': cartItemId,
//       'table_id': tableId,
//     });
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           try {
//             if (decodedResponse['cart']['status']) {
//               print("remove::");
//               cart.value = CartResponse.fromMap(decodedResponse['cart']);
//             } else {
//               cart.value = CartResponse();
//             }
//           } catch (e) {
//             parseErrorOccurred(
//                 "Assigning Value to Cart Variable 4 ${e.toString()}");
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isUpdatingCart.value = false;
//   }
//
//   payWithBullsEye({String? orderId, int? completeOrder}) async {
//     isMakingPayment.value = true;
//     var response =
//         await BaseClient().getWithAuth(Strings.bullsEyeTokenUrl + "$orderId");
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         // print("paywithbullseye:");
//
//         if (decodedResponse['status']) {
//           // log(decodedResponse.toString());
//           Get.toNamed(PageRoutes.qrPage, arguments: [
//             orderId,
//             decodedResponse['bullseye_code'],
//             completeOrder
//           ]);
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isMakingPayment.value = false;
//   }
//
//   // function pay for cash and card
//   payAtCounter(
//       {String? orderId,
//       int? completeOrder,
//       String? change,
//       String? cashPaid}) async {
//     isMakingPayment.value = true;
//     await Future.delayed(Duration(seconds: 5));
//     var response =
//         await BaseClient().getWithAuth(Strings.payAtCounterUrl + "$orderId/0");
//     if (response != null) {
//       try {
//         var decodedResponse = await jsonDecode(response.body);
//         // print(decodedResponse);
//         // orderPaid = decodedResponse;
//         if (decodedResponse['status']) {
//           // var orders = decodedResponse['order']['ordermeta'];
//
//           // print(decodedResponse['order']);
//
//           // log(decodedResponse);
//
//           var orderListData = decodedResponse['order'];
//           var invoiceId = orderListData['inv_id'];
//           var paymentMethod = orderListData['payment_method'];
//           var billTotal = orderListData['total'];
//           var billSubTotal = orderListData['subtotal'];
//           var billTax = orderListData['tax'];
//           var billDiscount = orderListData['discount'];
//           var totalItems = orderListData['item'];
//           var paymentStatus = orderListData['payment_status'];
//           var orderTypeStatus = orderListData['order_type_status'];
//           var orderCreatedAt = orderListData['created_at'];
//           var tableName = orderListData['table_id'];
//           print("rung"+paymentStatus);
//           print(invoiceId);
//           print(paymentMethod);
//           print(billTotal);
//           print(billSubTotal);
//           print(billTax);
//           print(billDiscount);
//           print(totalItems);
//
//           print(decodedResponse['order']['ordermeta']);
//           if (decodedResponse['order']['ordermeta'] != null) {
//             orderMeta = [];
//             decodedResponse['order']['ordermeta'].forEach((v) {
//               orderMeta.add(new OrderMeta.fromMap(v));
//             });
//           }
//           print("lisssstttttssss");
//
//           testPrint(
//               orderMeta,
//               invoiceId,
//               paymentMethod,
//               billTotal,
//               billSubTotal,
//               billTax,
//               billDiscount,
//               totalItems,
//               paymentStatus,
//               orderTypeStatus,
//               orderCreatedAt,
//               tableName,
//               change: change,
//               cashPaid: cashPaid);
//
//           isMakingPayment.value = false;
//           return true;
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isMakingPayment.value = false;
//   }
//
//   testPrint(
//       List<OrderMeta> orderMeta,
//       invoiceId,
//       paymentMethod,
//       billTotal,
//       billSubTotal,
//       billTax,
//       billDiscount,
//       totalItems,
//       paymentStatus,
//       orderTypeStatus,
//       orderCreatedAt,
//       tableName,
//       {change,
//       cashPaid}) async {
//     // for (var a in orderMeta) {
//     //   print(a.products!.title);
//     //   print(a.createdAt);
//     // }
//
//     bluetooth.isConnected.then((isConnected) async {
//       int extraPrice = 0;
//       int variantPrices = 0;
//       if (isConnected!) {
//         try {
//           DateTime now = DateTime.now();
//
//           await bluetooth.printCustom(
//               DateFormat('kk:mm:ss , EEE d MMM').format(now), 0, 1);
//           // await bluetooth.printNewLine();
//           await bluetooth.printCustom("MEALSMASH", 2, 1);
//           await bluetooth.printNewLine();
//           // await bluetooth.printCustom("\n",0, 0);
//           bluetooth.printLeftRight("Invoice: $invoiceId", '', 1);
//           // bluetooth.printLeftRight("Date: $orderCreatedAt       ", "", 1);
//
//           // , "  Type: ${invoiceData.orderTypeStatus}", 0)
//
//           await bluetooth.printCustom(
//               "Payment Method: ${paymentMethod == 'cod' ? "Pay at Counter" : 'Bullseye'}",
//               0,
//               0);
//           await bluetooth.printCustom(
//               "Payment Status: Paid",
//               // "Payment Status: ${paymentStatus == 1 ? "Paid" : "Not Paid"}",
//               0,
//               0);
//           await bluetooth.printCustom(
//               "Order-Type: $orderTypeStatus",
//               // "Payment Status: ${paymentStatus == 1 ? "Paid" : "Not Paid"}",
//               0,
//               0);
//           await bluetooth.printCustom(
//               "Table Name: $tableName",
//               // "Payment Status: ${paymentStatus == 1 ? "Paid" : "Not Paid"}",
//               0,
//               0);
//           // await bluetooth.printLeftRight("Order-Type: ", "$orderTypeStatus", 0);
//           // await bluetooth.printCustom("Payment Method: ${invoiceData.paymentMethod == 'cod' ? "cash": 'Bullseye' } \nPayment Status: ${invoiceData.paymentStatus == '1'? "Paid" : "Not Paid"}\n",0, 0);
//           await bluetooth.printNewLine();
//           await bluetooth.printCustom("Sale Receipt", 1, 1);
//           await bluetooth.printNewLine();
//           await bluetooth.printCustom(
//               "-------------------------------------", 0, 1);
//           await bluetooth.printLeftRight(
//               "Items".toUpperCase(), "Total".toUpperCase(), 0);
//           await bluetooth.printCustom(
//               "-------------------------------------", 0, 1);
//           // int p;
//           for (var i = 0; i < orderMeta.length; i++) {
//             // p = ;
//
//             if (orderMeta[i].products!.title!.length == 13) {
//               bluetooth.printLeftRight(
//                   "${orderMeta[i].products!.title}\t\t\t         ",
//                   "           \t\t\t\t\$ ${orderMeta[i].total.toString()}",
//                   0);
//             } else if (orderMeta[i].products!.title!.length < 14) {
//               bluetooth.printLeftRight(
//                   "${orderMeta[i].products!.title}\t\t\t\t           ",
//                   "           \t\t\t\t\$ ${orderMeta[i].total.toString()}",
//                   0);
//             } else if ((orderMeta[i].products!.title)!.length < 19) {
//               bluetooth.printLeftRight(
//                   "${orderMeta[i].products!.title}\t\t\t\t         ",
//                   "        \t\t\t\t\$${orderMeta[i].total.toString()}",
//                   0);
//             } else if ((orderMeta[i].products!.title)!.length > 19) {
//               bluetooth.printLeftRight("${orderMeta[i].products!.title}",
//                   "\$${orderMeta[i].total.toString()}", 0);
//             }
//
//             if (orderMeta[i].variantName != null) {
//               bluetooth.printCustom("(${orderMeta[i].variantName})", 0, 0);
//             }
//             if (orderMeta[i].orderItemExtras!.isNotEmpty) {
//               for (var o = 0; o < orderMeta[i].orderItemExtras!.length; o++) {
//                 orderMeta[i].orderItemExtras![o].extraPrice != null
//                     ? extraPrice = extraPrice +
//                         int.parse(orderMeta[i].orderItemExtras![o].extraPrice!)
//                     : extraPrice = extraPrice;
//                 bluetooth.printCustom(
//                     "+ ${orderMeta[i].orderItemExtras![o].extraName}",
//                     0,
//                     // "+\$ ${orderMeta[i].orderItemExtras![o].extraPrice}",
//                     0);
//
//                 // bluetooth.printLeftRight("+ ${invoiceData.orderMeta[i].orderItemExtras[o].extraName}       ", "        +\$ ${invoiceData.orderMeta[i].orderItemExtras[o].extraPrice}",0);
//               }
//             }
//             await bluetooth.printCustom(
//                 "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice} "
//                 "x ${orderMeta[i].qty.toString()}",
//                 // "\$ ${orderMeta[i].products!.price!.price.toString()} x ${orderMeta[i].qty.toString()}",
//                 0,
//                 0);
//             await bluetooth.printNewLine();
//             extraPrice = 0;
//           }
//
//           // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
//           // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
//           // await flutterUsbPrinter.printText("\n");
//           await bluetooth.printCustom(
//               "-------------------------------------", 0, 1);
//           bluetooth.printLeftRight("Sub Total", "\$ $billSubTotal", 1);
//           // await flutterUsbPrinter.printText("\n");
//           bluetooth.printLeftRight("Discount", "\$ 0 $billDiscount", 1);
//           // await flutterUsbPrinter.printText("\n");
//           bluetooth.printLeftRight("Tax", "\$ $billTax", 1);
//           // await flutterUsbPrinter.printText("\n");
//           // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
//           await bluetooth.printCustom(
//               "-------------------------------------", 0, 1);
//           bluetooth.printLeftRight("Net Paid", "\$ $billTotal", 1);
//           await bluetooth.printCustom(
//               "-------------------------------------", 0, 1);
//           await bluetooth.printLeftRight("Cash Received", "\$ $cashPaid", 1);
//
//           await bluetooth.printLeftRight("Change", "\$ $change", 1);
//           await bluetooth.printNewLine();
//         } on PlatformException {
//           String response = 'Failed to get platform.';
//
//           Fluttertoast.showToast(
//               msg: response,
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//               fontSize: 16.0);
//
//           print(response);
//         }
//       } else {
//         _print() async {
//           try {
//             DateTime now = DateTime.now();
//
//             flutterUsbPrinter.printText(
//                 DateFormat('kk:mm:ss , EEE d MMM').format(now) + "\n");
//             await flutterUsbPrinter.printText("\n");
//             await flutterUsbPrinter
//                 .printText("                   MEALSMASH                 \n");
//             await flutterUsbPrinter.printText("\n");
//             // await flutterUsbPrinter.printText("Date: ${invoiceData.date.split(',').first}   \t     Time: ${invoiceData.time}\n");
//             await flutterUsbPrinter.printText("Invoice# : $invoiceId     \n");
//             await flutterUsbPrinter.printText("Payment Status: Paid \n");
//             await flutterUsbPrinter.printText(
//                 "Payment Method : ${paymentMethod == 'cod' ? "Pay at Counter" : 'Bullseye'}  \n");
//             await flutterUsbPrinter
//                 .printText("Order-Type: $orderTypeStatus \n");
//             await flutterUsbPrinter.printText("Table Name: $tableName \n");
//             // await flutterUsbPrinter.printText("Payment Method: ${invoiceData.paymentMethod == 'cod' ? "cash": 'Bullseye' } \nPayment Status: ${invoiceData.paymentStatus == '1'? "Paid" : "Not Paid"}\n");
//             await flutterUsbPrinter.printText("\n");
//             await flutterUsbPrinter
//                 .printText("                 Sale Receipt                \n");
//             await flutterUsbPrinter.printText("\n");
//             await flutterUsbPrinter
//                 .printText("---------------------------------------------\n");
//             flutterUsbPrinter
//                 .printText("ITEMS                                  TOTAL\n");
//             await flutterUsbPrinter
//                 .printText("---------------------------------------------\n");
//             await flutterUsbPrinter.printText("\n");
//             for (var i = 0; i < orderMeta.length; i++) {
//               int titleLength = orderMeta[i].products!.title!.length;
//               await flutterUsbPrinter.printText(
//                   "${orderMeta[i].products!.title} ${orderMeta[i].products!.title!.length < 9 ? "\t\t\t" : "\t\t"}   \$ ${orderMeta[i].total.toString()} \n");
//
//               if (orderMeta[i].variantName != null) {
//                 await flutterUsbPrinter
//                     .printText("(${orderMeta[i].variantName})\n");
//               }
//
//               if (orderMeta[i].orderItemExtras!.isNotEmpty) {
//                 for (var o = 0; o < orderMeta[i].orderItemExtras!.length; o++) {
//                   orderMeta[i].orderItemExtras![o].extraPrice != null
//                       ? extraPrice = extraPrice +
//                           int.parse(
//                               orderMeta[i].orderItemExtras![o].extraPrice!)
//                       : extraPrice = extraPrice;
//                   await flutterUsbPrinter.printText(
//                       "+ ${orderMeta[i].orderItemExtras![o].extraName}" +
//                           "${orderMeta[i].orderItemExtras![o].extraName!.length > 8 ? " \t\t\t  " : " \t\t\t  "}" +
//                           "\n");
//                 }
//               }
//
//               await flutterUsbPrinter.printText(
//                   "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice}"
//                   // "\$ ${orderMeta[i].products!.price!.price.toString()}"
//                   " x ${orderMeta[i].qty.toString()} \n");
//               // flutterUsbPrinter.printText("\n");
//               await flutterUsbPrinter.printText("\n");
//               extraPrice = 0;
//             }
//
//             // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
//             // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
//             // await flutterUsbPrinter.printText("\n");
//             await flutterUsbPrinter
//                 .printText("---------------------------------------------\n");
//             await flutterUsbPrinter.printText(
//                 "Sub Total                             \$ $billSubTotal\n");
//             // await flutterUsbPrinter.printText("\n");
//             await flutterUsbPrinter.printText(
//                 "Discount                              \$ 0$billDiscount\n");
//             // await flutterUsbPrinter.printText("\n");
//             await flutterUsbPrinter.printText(
//                 "Tax                                   \$ $billTax\n");
//
//             // await flutterUsbPrinter.printText("\n");
//             await flutterUsbPrinter
//                 .printText("---------------------------------------------\n");
//             await flutterUsbPrinter.printText(
//                 "Net Paid                              \$ $billTotal\n");
//             await flutterUsbPrinter
//                 .printText("---------------------------------------------\n");
//             await flutterUsbPrinter.printText(
//                 "Cash Received:                        \$ $cashPaid\n");
//             await flutterUsbPrinter.printText(
//                 "Change                                \$ $change\n");
//           } on PlatformException {
//             String response = 'Failed to get platform version.';
//             Fluttertoast.showToast(
//                 msg: response,
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: Colors.red,
//                 textColor: Colors.white,
//                 fontSize: 16.0);
//             print(response);
//           }
//         }
//
//         returned
//             ? _print()
//             : Fluttertoast.showToast(
//                 msg: "Invoice printer not connected",
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: Colors.red,
//                 textColor: Colors.white,
//                 fontSize: 16.0);
//       }
//     });
//   }
//
//   updateSquareCartItemQty(
//       {required int cartItemId,
//       required int productId,
//       required int qty,
//       required String tableId}) async {
//     var response =
//         await BaseClient().postWithAuth(Strings.updateSquareCartItemQtyUrl, {
//       'cart_item_id': cartItemId,
//       // 'product_id': productId,
//       'qty': qty,
//       // 'table_id': tableId,
//     });
//     if (response != null) {
//       try {
//         print("123");
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           print("1234");
//
//           try {
//             print("1234");
//
//             if (decodedResponse['cart']['total'] != null) {
//               SCart c = SCart.fromJson(decodedResponse['cart']);
//               print("12345");
//
//               // get updated item
//               if (c.cartData != null) {
//                 var d =
//                     c.cartData!.where((element) => element.id == cartItemId);
//
//                 if (scart.value.cartData != null) {
//                   print("111");
//                   for (int i = 0; i < scart.value.cartData!.length; i++) {
//                     if (scart.value.cartData![i].id == cartItemId) {
//                       print("jkasjkasdrdfsjk${scart.value.cartData![i]}");
//                       scart.value.cartData![i] = d.first;
//                       scart.value.total = c.total;
//                       scart.value.tax = c.tax;
//                       scart.value.subtotal = c.subtotal;
//                       scart.value.discount = c.discount;
//                       update();
//                       break;
//                     }
//                   }
//                 }
//               }
//
//               update();
//               // cart.value = CartResponse.fromMap(decodedResponse['cart']);
//             } else {
//               scart.value = SCart();
//               print("123456");
//             }
//           } catch (e) {
//             parseErrorOccurred("12345678 ${e.toString()}");
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//   }
//
//   updateCartItemQty(
//       {required int cartItemId,
//       required int productId,
//       required int qty,
//       required String tableId}) async {
//     var response =
//         await BaseClient().postWithAuth(Strings.updateCartItemQtyUrl, {
//       'cart_id': cartItemId,
//       'product_id': productId,
//       'qty': qty,
//       'table_id': tableId,
//     });
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           try {
//             if (decodedResponse['cart']['status']) {
//               CartResponse c = CartResponse.fromMap(decodedResponse['cart']);
//               // get updated item
//               if (c.cartData != null) {
//                 var d =
//                     c.cartData!.where((element) => element.id == cartItemId);
//
//                 if (cart.value.cartData != null) {
//                   for (int i = 0; i < cart.value.cartData!.length; i++) {
//                     if (cart.value.cartData![i].id == cartItemId) {
//                       cart.value.cartData![i] = d.first;
//                       cart.value.total = c.total;
//                       cart.value.tax = c.tax;
//                       cart.value.subtotal = c.subtotal;
//                       cart.value.discount = c.discount;
//                       update();
//                       break;
//                     }
//                   }
//                 }
//               }
//
//               // cart.value = CartResponse.fromMap(decodedResponse['cart']);
//             } else {
//               cart.value = CartResponse();
//             }
//           } catch (e) {
//             parseErrorOccurred(
//                 "Assigning Value to Cart Variable 5${e.toString()}");
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//   }
//
// // updateCartItemQty(
// //     {required int cartItemId,
// //     required int productId,
// //     required int qty}) async {
// //   isUpdatingCart.value = true;
// //   var response =
// //       await BaseClient().postWithAuth(Strings.updateCartItemQtyUrl, {
// //     'cart_id': cartItemId,
// //     'product_id': productId,
// //     'qty': qty,
// //   });
// //   if (response != null) {
// //     try {
// //       var decodedResponse = jsonDecode(response.body);
// //       if (decodedResponse['status']) {
// //         try {
// //           if (decodedResponse['cart']['status']) {
// //             CartResponse updatedCart =
// //                 CartResponse.fromMap(decodedResponse['cart']);
// //
// //             if (cart.value.cartData != null) {
// //               for (int i = 0; i < cart.value.cartData!.length; i++) {
// //                 CartItem element = cart.value.cartData![i];
// //                 if (element.id == cartItemId) {
// //                   // Item Found in Cart Data
// //                   var d = updatedCart.cartData!
// //                       .where((element) => element.id == cartItemId);
// //                   if (d.length > 0) {
// //                     cart.value.cartData![i] = d.first;
// //                     cart.value.total = updatedCart.total;
// //                     cart.value.coupon = updatedCart.coupon;
// //                     cart.value.discount = updatedCart.discount;
// //                     cart.value.storeName = updatedCart.storeName;
// //                     cart.value.subtotal = updatedCart.subtotal;
// //                     cart.value.tax = updatedCart.tax;
// //                     break;
// //                   }
// //                 }
// //               }
// //             }
// //           }
// //           // else {
// //           //   cart.value = CartResponse();
// //           // }
// //         } catch (e) {
// //           parseErrorOccurred(
// //               "Assigning Value to Cart Variable ${e.toString()}");
// //         }
// //       } else {
// //         showToast(
// //             "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
// //       }
// //     } catch (e) {
// //       parseErrorOccurred(e.toString());
// //     }
// //   }
// //   isUpdatingCart.value = false;
// // }
//   login({required String email, required String password}) async {
//     var response = await BaseClient().post(
//       Strings.loginUrl,
//       '{"email":"${email.toLowerCase()}","password":"$password"}',
//     );
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           var value =
//               await saveCredentials(LoginResponse.fromJson(response.body));
//           if (value != null) {
//             getTablesDetail();
//             Get.offAllNamed(PageRoutes.tableSelectionPage);
//
//             getCategoriesDetail();
//             getSquareCategoriesDetail();
//             // getModifiers(item_id:item_id, store_id:store_id);
//             // getCart();
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//   }
//
//   void logOut() {
//     isLoginBtnClicked.value = false;
//     dispose();
//   }
//
//   void parseErrorOccurred(String string) {
//     log("Data Parsing Error Occurred: $string");
//     // showToast("Data Parsing Error Occurred: $string");
//   }
//
//   saveOrder({required String orderId}) async {
//     isSavingOrder.value = true;
//     var response = await BaseClient().getWithAuth(
//       Strings.saveOrderUrl + "$orderId",
//     );
//     if (response != null) {
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           Get.offAllNamed(PageRoutes.splashPage);
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isSavingOrder.value = false;
//   }
//
//   applyDiscount({
//     required String orderId,
//     required String value,
//     required String type,
//   }) async {
//     isApplyingDiscount.value = true;
//     var response = await BaseClient().postWithAuth(Strings.applyDiscountUrl, {
//       "amount": "$value",
//       "type": "$type",
//       "order_id": "$orderId",
//     });
//     if (response != null) {
//       print("after applying discount get response:::");
//       print(jsonDecode(response.body));
//       try {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['status']) {
//           try {
//             Order updatedOrder = Order.fromMap(decodedResponse['order']);
//             return updatedOrder;
//           } catch (e) {
//             e.printError();
//             parseErrorOccurred(e.toString());
//           }
//         } else {
//           showToast(
//               "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//         }
//       } catch (e) {
//         parseErrorOccurred(e.toString());
//       }
//     }
//     isApplyingDiscount.value = false;
//   }
// }
import 'dart:async';
import 'dart:io';

import 'dart:convert';
import 'dart:developer';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Mealsmash_Waiter/helper/app_config.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/model/Scart.dart';
import 'package:Mealsmash_Waiter/model/Sorder.dart';
import 'package:Mealsmash_Waiter/model/area_response.dart';
import 'package:Mealsmash_Waiter/model/cart_response.dart';
import 'package:Mealsmash_Waiter/model/categories_response.dart';
import 'package:Mealsmash_Waiter/model/login_response.dart';
import 'package:Mealsmash_Waiter/model/modifiers.dart';
import 'package:Mealsmash_Waiter/model/order.dart';
import 'package:Mealsmash_Waiter/model/squarecategories.dart';
import 'package:Mealsmash_Waiter/model/tables_response.dart';
import 'package:image/image.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/pastorders.dart';
import 'service/base_client.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class CommonController extends GetxController {
  var isDarkTheme = false.obs;
  var selectedLanguage = "en".obs;
  final localStorage = GetStorage(Strings.keyDbName);
  var isLoginBtnClicked = false.obs;
  var isLoadingPastOrders = false.obs;
  var isLoadingPastOrdersFirstTime = true.obs;

  var restaurant = LoginResponse().obs;
  var tables = TablesResponse().obs;
  var areaNames = <AreaResponse>[].obs;
  var categories = CategoriesResponse().obs;
  var scategories = SquareData().obs;
  var cart = CartResponse().obs;
  var scart = SCart().obs;
  var searchResult = <Product>[].obs;
  var isLoadingTables = false.obs;
  var isPlacingOrder = false.obs;
  var isLoadingCategories = false.obs;
  var isLoadingSquareCategories = false.obs;
  var isUpdatingOrder = false.obs;
  var isLoadingCart = false.obs;
  var isMakingPayment = false.obs;
  var isDrawerTypeCart = 0.obs;
  var isCancelingOrder = false.obs;
  var isSavingOrder = false.obs;
  var isApplyingDiscount = false.obs;
  var isDiscountBtnClicked = false.obs;
  var isCompletingOrder = false.obs;
  var isSearchingItems = false.obs;
  var isVariationItemClicked = false.obs;
  var isUpdatingCart = false.obs;
  var isDoingCartIncrementDecrement = false.obs;
  var selectedProduct = Product().obs;
  var selectedSquareProduct = SquareProduct().obs;
  var Modifiers = Modifier().obs;
  var type = "".obs;

  var selectedCategoryName = "".obs;
  var selectedCategoryIndex = 0.obs;
  var sqselectedCategoryIndex = 0.obs;
  var noOfOptions = 0.obs;
  var selectedOptions = <int, String>{}.obs;
  var selectedVariation = <int, String>{}.obs;
  var allExtras = <Extra>[].obs;
  var selectedExtras = Map<int, Extra>().obs;
  var allModifiers = <Modifier>[].obs;
  var selectedModifier = Map<int, Modifier>().obs;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  String orderId = '0';
  var printerVendorId;
  var printerProductId;
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;
  bool returned = true;
  var pref;
  var platform;
  String vendor_id = "";
  List<OrderMeta> orderMeta = <OrderMeta>[];
  var pastOrders = <PastOrder>[].obs;

  // List<Ordermeta> orderMetaa = <Ordermeta>[];
  var name;
  String? previousClickedCartItem;
  int? previousClickedCartItemIndex;

  Generator? generator;
  CapabilityProfile? profile;

  // QRCorrection? cor;
  List<int> printTxt = [];
  var Restaurantname;

  // String? printTxt;

  @override
  void onInit() {
    super.onInit();
    Configure();
    getThemeFromStorage();
    getSelectedLanguage();
  }

  Configure() async {
    pref = await SharedPreferences.getInstance();
    Restaurantname = pref.getString('name');
    print("Restaurantname${Restaurantname}");
  }

  Future<bool> isFirstTime() async {
    var res = await localStorage.read(Strings.keyIsFirstTime);
    if (res != null) {
      return !res;
    }
    return true;
  }

  Future<void> setNotFirstTime() async {
    await localStorage.write(Strings.keyIsFirstTime, true);
  }

  Future<void> getSelectedLanguage() async {
    var res = await localStorage.read(Strings.keySelectedLanguage);
    if (res != null) {
      selectedLanguage.value = res;
      Get.updateLocale(Locale(selectedLanguage.value));
      return;
    }
    selectedLanguage.value = "en";
    Get.updateLocale(Locale(selectedLanguage.value));
  }

  Future<void> setSelectedLanguage({required String languageCode}) async {
    await localStorage.write(Strings.keySelectedLanguage, languageCode);
    selectedLanguage.value = languageCode;
    Get.updateLocale(Locale(selectedLanguage.value));
  }

  Future<void> getThemeFromStorage() async {
    var res = await localStorage.read(Strings.keyIsDarkTheme);
    if (res != null) {
      isDarkTheme.value = res;
      return;
    }
    isDarkTheme.value = false;
  }

  Future<void> setDarkTheme({required bool enableDarkTheme}) async {
    await localStorage.write(Strings.keyIsDarkTheme, enableDarkTheme);
    isDarkTheme.value = enableDarkTheme;
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: BasicColors.primaryColor,
        textColor: BasicColors.white,
        fontSize: 18.0);
  }

  Future<bool> isLogin() async {
    var res = await localStorage.read(Strings.keyUser);
    if (res != null) {
      restaurant.value = LoginResponse.fromJson(res);
      if (restaurant.value.token == null) {
        print("heeyyyyy1");
        return false;
      } else {
        print("heeyyyyy2");

        return true;
      }
    }
    restaurant.value = LoginResponse();
    return false;
  }

  Future<bool> logOutUser() async {
    await localStorage.remove(Strings.keyUser);
    await Get.offAllNamed(PageRoutes.loginPage);
    return true;
  }

  Future<bool> saveCredentials(LoginResponse loginResponse) async {
    await localStorage.write(Strings.keyUser, loginResponse.toJson());
    return await isLogin();
  }



  getPastOrders({bool showLoading = false}) async {
    if (showLoading) {
      isLoadingPastOrders.value = true;
    }
    if (isLoadingPastOrdersFirstTime.value) {
      isLoadingPastOrders.value = true;
      isLoadingPastOrdersFirstTime.value = false;
    }

    var response = await BaseClient().getWithAuth(Strings.pastOrdersUrl, i: 40);
    print("Past_Orders");
    print("Past_Orders${Strings.pastOrdersUrl}");
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        print("Past_Orders${response.body}");
        if (decodedResponse['status']) {
          // Save Orders Details in Variable
          var orders = List<PastOrder>.from(
              decodedResponse['data'].map((x) => PastOrder.fromMap(x)));

// log(orders.toString());
          pastOrders.assignAll(orders);
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        log(e.toString());
        parseErrorOccurred(e.toString());
      }
    }
    // if(showLoading){
    isLoadingPastOrders.value = false;
    // }
  }



  getFloorsDetail({bool showLoading = true}) async {
    areaNames = <AreaResponse>[].obs;
    if (showLoading) {
      isLoadingTables.value = true;
    }

    var response = await BaseClient().getWithAuth(Strings.floorsUrl);
    if (response != null) {
      var decodedResponse = jsonDecode(response.body);
      // log(decodedResponse.toString());
      if (decodedResponse['status']) {
        var data = decodedResponse['data'];

        print("Floor name:  ");
        // print(data[0]['name'].toString());
        // log(data['tables'].toString());

        for (int d = 0; d < data.length; d++) {
          // for (int i = 0; i < d!.length; i++) {
          // print(data != null ? data[d]['name'].toString() : "aa");
          var da =
              List<AreaResponse>.from(data.map((x) => AreaResponse.fromMap(x)));
          areaNames.value = da;

          // tables.value = TablesResponse.fromJson(data[d]['tables']);
          // }
        }
      }
    }
    if (showLoading) {
      isLoadingTables.value = false;
    }
  }

  getTablesDetail({bool showLoading = true, String floorId = ''}) async {
    // tables = TablesResponse().obs;
    notifyChildrens();
    if (showLoading) {
      isLoadingTables.value = true;
    }

    var response = await BaseClient()
        .getWithAuth(Strings.tablesUrl + floorId, istableapi: true);
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null) {
          // print("wooooww");
          // print(decodedResponse);
          // var data = decodedResponse['data'];
          // print("Floor name: ");
          // // print(data[0]['name'].toString());
          // // log(data['tables'].toString());
          //
          // for (int d = 0; d < data.length; d++) {
          //   // for (int i = 0; i < d!.length; i++) {
          //   // print(data != null ? data[d]['name'].toString() : "aa");
          //   var da = List<AreaResponse>.from(
          //       data.map((x) => AreaResponse.fromMap(x)));
          //   areaNames.value = da;
          //   print("check:");
          //   print(da[0].floorId);
          //   // tables.value = TablesResponse.fromJson(data[d]['tables']);
          //   // }
          // }

          // log(data.toString());

          // print("hellllll");

          tables.value = TablesResponse.fromJson(response.body);
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    if (showLoading) {
      isLoadingTables.value = false;
    }
  }

  //   ReceiptPaymentBullsEye(String? token) async {
  //     pref = await SharedPreferences.getInstance();
  //
  //
  //    var response= pref.getString('order');
  //
  //   if (response != null) {
  //     try {
  //       // print(response.body);
  //
  //       var decodedResponse = jsonDecode(response);
  //       // log(decodedResponse['order'].toString());
  //       if (decodedResponse['status']) {
  //         var tableName = decodedResponse['table_name'];
  //         var orderListData = decodedResponse['order'];
  //         var invoiceId = orderListData['inv_id'];
  //         var paymentMethod = "Bullseye";
  //         // var paymentMethod = orderListData['payment_method'];
  //         var billTotal = orderListData['total'];
  //         var billSubTotal = orderListData['subtotal'];
  //         var billTax = orderListData['tax'];
  //         var billDiscount = orderListData['discount'];
  //         var totalItems = orderListData['item'];
  //         var paymentStatus = orderListData['payment_status'];
  //         var orderTypeStatus = orderListData['order_type_status'];
  //         var orderCreatedAt = orderListData['created_at'];
  //
  //         // print(invoiceId);
  //         // print(paymentMethod);
  //         // print(billTotal);
  //         // print(billSubTotal);
  //         // print(billTax);
  //         // print(billDiscount);
  //         // print(totalItems);
  //
  //         print(decodedResponse['order']['ordermeta']);
  //         if (decodedResponse['order']['ordermeta'] != null) {
  //           orderMeta = [];
  //           decodedResponse['order']['ordermeta'].forEach((v) {
  //             orderMeta.add(new OrderMeta.fromMap(v));
  //           });
  //         }
  //         print("TABLESSSS${tableName}");
  //
  //         testPrint(
  //           orderMeta,
  //           invoiceId,
  //           paymentMethod,
  //           billTotal,
  //           billSubTotal,
  //           billTax,
  //           billDiscount,
  //           totalItems,
  //           paymentStatus,
  //           orderTypeStatus,
  //           orderCreatedAt,
  //           tableName,
  //           token
  //         );
  //         return true;
  //       } else {
  //         // showToast(
  //         //     "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
  //       }
  //     } catch (e) {
  //       parseErrorOccurred(e.toString());
  //     }
  //   }
  // }

  checkPaymentStatusBullsEye(String? token,
      {required String orderId, bool fromReceipt = false}) async {
    var response = await BaseClient()
        .getWithAuth(Strings.checkBullsEyePaymentStatusUrl + orderId);
    print("jhjhjhjhjh2");

    try {
      print("jhjhjhjhjh");

      var decodedResponse = jsonDecode(response.body);
      // log(decodedResponse['order'].toString());
      if (decodedResponse['status']) {
        var orderListData = decodedResponse['order'];
        var invoiceId = orderListData['inv_id'];
        var paymentMethod = orderListData['payment_method'];
        var billTotal = orderListData['total'];
        var billSubTotal = orderListData['subtotal'];
        var billTax = orderListData['tax'];
        var billDiscount = orderListData['discount'];
        var totalItems = orderListData['item'];
        var paymentStatus = orderListData['payment_status'].toString();
        var orderTypeStatus = orderListData['order_type_status'];
        var orderCreatedAt = orderListData['created_at'];
        var tableName = orderListData['table_name'];



        // print(invoiceId);
        // print(paymentMethod);
        // print(billTotal);
        // print(billSubTotal);
        // print(billTax);
        // print(billDiscount);
        // print(totalItems);

        print(decodedResponse['order']['ordermeta']);
        if (decodedResponse['order']['ordermeta'] != null) {
          orderMeta = [];
          decodedResponse['order']['ordermeta'].forEach((v) {
            orderMeta.add(new OrderMeta.fromMap(v));
          });
        }

        testPrint(
            orderMeta,
            invoiceId,
            paymentMethod,
            billTotal,
            billSubTotal,
            billTax,
            billDiscount,
            totalItems,
            paymentStatus,
            orderTypeStatus,
            orderCreatedAt,
            tableName,
            "","");
        return true;
      }
      else {

        if(fromReceipt) {

          try {

            var decodedResponse = jsonDecode(response.body);
            print("helloooo${decodedResponse}");

            // log(decodedResponse['order'].toString());
            var orderListData = decodedResponse['order'];
            print("dsfjd${orderListData}");
            var invoiceId = orderListData['inv_id'];
            var paymentMethod = orderListData['payment_method'];
            var billTotal = orderListData['total'];
            var billSubTotal = orderListData['subtotal'];
            var billTax = orderListData['tax'];
            var billDiscount = orderListData['discount'];
            var totalItems = orderListData['item'];
            var paymentStatus = orderListData['payment_status'].toString();
            var orderTypeStatus = orderListData['order_type_status'];
            var orderCreatedAt = orderListData['created_at'];
            var tableName = orderListData['table_name'];



            // print(paymentMethod);
            // print(billTotal);
            // print(billSubTotal);
            // print(billTax);
            // print(billDiscount);
            // print(totalItems);
            print("lisssstttttssss");

            print(decodedResponse['order']['ordermeta']);

            if (decodedResponse['order']['ordermeta'] != null) {
              orderMeta = [];
              decodedResponse['order']['ordermeta'].forEach((v) {
                orderMeta.add(new OrderMeta.fromMap(v));
              });

              print("lisssstttttssss");

              testPrint(
                  orderMeta,
                  invoiceId,
                  paymentMethod,
                  billTotal,
                  billSubTotal,
                  billTax,
                  billDiscount,
                  totalItems,
                  paymentStatus,
                  orderTypeStatus,
                  orderCreatedAt,
                  tableName,
                  token,"");
              return null;
            }
          } catch (e) {
            return false;
          }
        }else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> placeOrder(
      String tableId, String orderType, String platform) async {
    log("Table Id: $tableId");
    log(orderType);
    var response = await BaseClient().postWithAuth(
        Strings.placeOrderUrl,
        platform.isEmpty
            ? {
                'table_id': tableId,
                'order_type': orderType,
                'platform': "MEALSMASH"
              }
            : {
                'table_id': tableId,
                'order_type': orderType,
                'platform': platform
              });
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          print("yesssss2");
          // getFloorsDetail();
          getTablesDetail();
          print("daniyal${decodedResponse['order']}");
          pref = await SharedPreferences.getInstance();

          var order = response.body;
          pref.setString('order', order);

          SQOrder? mySOrder;
          Order? myOrder;
          print("Goodplatform${platform}");

          if (platform == "SQUARE") {
            print("happy${mySOrder}");

            mySOrder = SQOrder.fromMap(decodedResponse['order']);
            print("asdadsa${mySOrder}");
          } else {
            myOrder = Order.fromMap(decodedResponse['order']);
            print("qqqqqqq${myOrder.orderMeta}");
          }
          // print(decodedResponse['order']);
          // myOrder.tax = decodedResponse['order']['tax'];
          // myOrder.subtotal = decodedResponse['order']['subtotal'];
          // myOrder.discount = decodedResponse['order']['discount'];
          print("yesssss");
          return {
            "orderId": "${decodedResponse['order_id']}",
            "price": "${decodedResponse['order_price']}",
            "order": platform == "SQUARE" ? mySOrder : myOrder,

          };
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
  }

  cancelOrder(String orderId) async {
    isCancelingOrder.value = true;
    var response =
        await BaseClient().getWithAuth(Strings.cancelOrderUrl + orderId);
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          // Order Cancelled Goto Tables Page
          getTablesDetail();
          Get.offAllNamed(PageRoutes.splashPage);
        } else {
          print("okaayyyyy");
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Cannot cancel Order because payment was already paid "}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isCancelingOrder.value = false;
  }

  completeOrder({required String orderId, bool gotoTables = false}) async {
    isCompletingOrder.value = true;
    type.value = "1";
    log("Order Id - $orderId");
    var response =
        await BaseClient().getWithAuth(Strings.completeOrderUrl + orderId);
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          // Order Cancelled Goto Tables Page
          getTablesDetail();
          if (gotoTables) {
            Get.offAllNamed(PageRoutes.splashPage);
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isCompletingOrder.value = false;
    print("yuy");
    print(response);
  }

  getModifiers({required item_id, required store_id}) async {
    isLoadingSquareCategories.value = true;
    var response = await BaseClient().postWithAuth(Strings.modifiersUrl, {
      'item_id': item_id,
      'store_id': store_id,
    });
    if (response != null) {
      try {
        var jsonData = jsonDecode(response.body);
        // print("wooooww");

        if (jsonData != null) {
          // print("wooooww");
          print(jsonData);
          pref = await SharedPreferences.getInstance();
          // platform = jsonData['platform_configured'].toString();
          // print(platform);
          // pref.setString('platform_configured', platform);
          Modifiers.value = Modifier.fromJson(jsonData);
        } else {
          showToast(
              "${jsonData['message'] ?? jsonData['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    isLoadingSquareCategories.value = false;
  }

  getSquareCategoriesDetail() async {
    isLoadingSquareCategories.value = true;
    var response = await BaseClient().getWithAuth(Strings.categoriesUrl);
    if (response != null) {
      try {
        var jsonData = jsonDecode(response.body);
        print("wooooww");

        if (jsonData != null) {
          // print("wooooww");
          // print(jsonData);
          pref = await SharedPreferences.getInstance();

          vendor_id = jsonData['vendor_id'].toString();
          pref.setString('vendor_id', vendor_id);
          print("wweewwee${vendor_id}");
          platform = jsonData['platform_configured'].toString();
          print("dddddddddddd${platform}");
          pref.setString('platform_configured', platform);
          var platform2;
          platform2 = pref.getString('platform_configured');
          print("12344545425${platform2}");

          scategories.value = SquareData.fromJson(jsonData);
        } else {
          showToast(
              "${jsonData['message'] ?? jsonData['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    isLoadingSquareCategories.value = false;
  }

  getCategoriesDetail() async {
    isLoadingCategories.value = true;
    var response = await BaseClient().getWithAuth(Strings.categoriesUrl);
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        pref = await SharedPreferences.getInstance();
        vendor_id = decodedResponse['vendor_id'].toString();
        pref.setString('vendor_id', vendor_id);
        print("wweewwee${vendor_id}");
        platform = decodedResponse['platform_configured'].toString();
        print("dddddddddddd${platform}");
        pref.setString('platform_configured', platform);
        var platform2;
        platform2 = pref.getString('platform_configured');
        print("12344545425${platform2}");

        if (decodedResponse['status']) {
          print("errorishere${decodedResponse['status']}");
          categories.value = CategoriesResponse.fromJson(response.body);
          print("woooowwwooooww");
        } else {
          print("errorishere");

          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        print("errorishere");

        parseErrorOccurred(e.toString());
      }
    }

    isLoadingCategories.value = false;
  }

  removeItemFromOrder(int orderItemId) async {
    isUpdatingOrder.value = true;

    var response = await BaseClient().getWithAuth(
        Strings.removeItemFromOrderUrl + "${orderItemId.toString()}");
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          await getTablesDetail();
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    isUpdatingOrder.value = false;
  }

  qtyIncrementOrderItem(int orderItemId) async {
    //  isUpdatingOrder.value = true;

    var response = await BaseClient().getWithAuth(
        Strings.qtyIncrementOrderItemUrl + "${orderItemId.toString()}");
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          await getTablesDetail();
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    //  isUpdatingOrder.value = false;
  }

  qtyDecrementOrderItem(int orderItemId) async {
    //isUpdatingOrder.value = true;

    var response = await BaseClient().getWithAuth(
        Strings.qtyDecrementOrderItemUrl + "${orderItemId.toString()}");
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          await getTablesDetail();
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    //  isUpdatingOrder.value = false;
  }

  getSquareCart(
    String tableId,
  ) async {
    isLoadingCart.value = true;
    print("qqqqqqq");
    var response = await BaseClient().getWithAuth(Strings.squarecartUrl);
    if (response != null) {
      // try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          scart.value = SCart.fromJson(response.body);

          // print("hello ${response}");
        } else {
          scart.value = SCart();
          // showToast("${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      // } catch (e) {
      //   // parseErrorOccurred(e.toString());
      // }
    }

    isLoadingCart.value = false;
  }

  getCart(
    String tableId,
  ) async {
    isLoadingCart.value = true;
    print("qqqqqqq");
    var response = await BaseClient().getWithAuth(Strings.cartUrl + tableId);
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          cart.value = CartResponse.fromJson(response.body.toString());

          print("hello ${decodedResponse['status']}");
        } else {
          cart.value = CartResponse();
          // showToast("${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    isLoadingCart.value = false;
  }

  searchItems(String text) async {
    isSearchingItems.value = true;

    var response = await BaseClient().getWithAuth(Strings.searchUrl + text);
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          var data = List<Product>.from(
              decodedResponse["data"].map((x) => Product.fromMap(x)));

          searchResult.value = data;
        } else {
          // showToast("${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    isSearchingItems.value = false;
  }

  SquareaddToCart({
    required List<ModifierElement> modifiers,
    required String image,
    product_currency,
    required String vendor_id,
    required int tax_value,
    required int qty,
    product_price,
    product_name,
    product_id,
  }) async {
    var response = await BaseClient().postWithAuth(Strings.squareaddToCartUrl, {
      "qty": qty.toString(),
      "product_id": product_id.toString(),
      "product_name": product_name,
      "product_price": product_price,
      "tax_value": tax_value,
      "vendor_id": vendor_id,
      "product_currency": product_currency,
      "image": image,
      "modifiers": modifiers,
    });
    if (response != null) {
      print("response received after add to cart!");
      print(jsonDecode(response.body));
      try {
        var decodedResponse = jsonDecode(response.body);

        // log(decodedResponse);
        if (decodedResponse['status']) {
          try {
            if (decodedResponse['cart'] != null) {
              scart.value = SCart.fromJson(decodedResponse['cart']);
            }
            return true;
          } catch (e) {
            parseErrorOccurred(
                "Assigning Value to Cart Variable 1${e.toString()}");
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    isUpdatingCart.value = false;
  }

  addToCart(String tableId,
      {required String productId,
      required String qty,
      required String vendorId,
      String? variationId,
      List<int>? extrasIds}) async {
    log("Extra Ids $extrasIds");
    // isUpdatingCart.value = true;
    var response = await BaseClient().postWithAuth(Strings.addToCartUrl, {
      'table_id': tableId,
      'vendor_id': vendorId,
      'product_id': productId,
      'qty': qty,
      'variation_id': variationId,
      'extras': extrasIds ?? '',
    });
    if (response != null) {
      print("response received after add to cart! my body");
      print(jsonDecode(response.body));
      try {
        var decodedResponse = jsonDecode(response.body);

        // log(decodedResponse);
        if (decodedResponse['status']) {
          try {
            print("jguysdw ${decodedResponse['cart']}");

            if (decodedResponse['cart'] != null) {
              cart.value = CartResponse.fromMap(decodedResponse['cart']);
            }
            return true;
          } catch (e) {
            parseErrorOccurred(
                "Assigning Value to Cart Variable 2${e.toString()}");
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }

    isUpdatingCart.value = false;
  }

  addToOrder({required int? orderId, required String platform}) async {
    // isUpdatingOrder.value = true;
    var response = await BaseClient().postWithAuth(
        Strings.addToOrderUrl, {'order_id': orderId, 'platform': platform});
    if (response != null) {
      print("after add TO ORDER:::");
      print(jsonDecode(response.body));
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          await getTablesDetail();
          isUpdatingOrder.value = false;
          return true;
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isUpdatingOrder.value = false;
  }

  SqremoveCartItem({required int cartItemId, required String tableId}) async {
    isUpdatingCart.value = true;
    var response =
        await BaseClient().postWithAuth(Strings.SQdeleteCartItemUrl, {
      'cart_item_id': cartItemId,
      // 'table_id': tableId,
    });
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          try {
            if (decodedResponse['cart']['status']) {
              print("remove::");
              scart.value = SCart.fromJson(decodedResponse['cart']);
            } else {
              scart.value = SCart();
            }
          } catch (e) {
            parseErrorOccurred(
                "Assigning Value to Cart Variable 3${e.toString()}");
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isUpdatingCart.value = false;
  }

  removeCartItem({required int cartItemId, required String tableId}) async {
    isUpdatingCart.value = true;
    var response = await BaseClient().postWithAuth(Strings.deleteCartItemUrl, {
      'cart_id': cartItemId,
      'table_id': tableId,
    });
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          try {
            if (decodedResponse['cart']['status']) {
              print("remove::");
              cart.value = CartResponse.fromMap(decodedResponse['cart']);
              return true;
            } else {
              cart.value = CartResponse();
            }
          } catch (e) {
            parseErrorOccurred(
                "Assigning Value to Cart Variable 4 ${e.toString()}");
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isUpdatingCart.value = false;
  }

  payWithBullsEye({String? orderId, int? completeOrder}) async {
    isMakingPayment.value = true;
    var response =
        await BaseClient().getWithAuth(Strings.bullsEyeTokenUrl + "$orderId");
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        // print("paywithbullseye:");

        if (decodedResponse['status']) {
          // log(decodedResponse.toString());
          Get.toNamed(PageRoutes.qrPage, arguments: [
            orderId,
            decodedResponse['bullseye_code'],
            completeOrder
          ]);
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isMakingPayment.value = false;
  }

  // function pay for cash and card
  payAtCounter(
      {String? orderId,
      int? completeOrder,
      String? change,
      String? cashPaid,  String? type, }) async {
    isMakingPayment.value = true;
    await Future.delayed(Duration(seconds: 5));
    var response;


      // try {
        response = await BaseClient()
            .getWithAuth(Strings.payAtCounterUrl + "$orderId/0");
        print("va1234");
      // }
      // catch (va) {
      //   print("va12345678");
      //   print(va.toString());
      // }
      if (response != null) {
        print("cashcounterrrrr in if");
        try {
          var decodedResponse = await jsonDecode(response.body);
          print("datataaaaaa${jsonDecode(response.body)}");
          print("statusssssss${decodedResponse['status']}");
          // print(decodedResponse);
          // orderPaid = decodedResponse;
          if (decodedResponse['status']) {
            // var orders = decodedResponse['order']['ordermeta'];

            // print(decodedResponse['order']);

            // log(decodedResponse);

            var orderListData = decodedResponse['order'];
            var invoiceId = orderListData['inv_id'];
            var paymentMethod = orderListData['payment_method'];
            var billTotal = orderListData['total'];
            var billSubTotal = orderListData['subtotal'];
            var billTax = orderListData['tax'];
            var billDiscount = orderListData['discount'];
            var totalItems = orderListData['item'];
            var paymentStatus = orderListData['payment_status'];
            var orderTypeStatus = orderListData['order_type_status'];
            var orderCreatedAt = orderListData['created_at'];
            var tableName = orderListData['table_name'];

            print(invoiceId);
            print("PaymentMethod$paymentMethod");
            print("PaymentStatus$paymentStatus");
            print(billTotal);
            print(billSubTotal);
            print(billTax);
            print(billDiscount);
            print(totalItems);

            print(decodedResponse['order']['ordermeta']);
            if (decodedResponse['order']['ordermeta'] != null) {
              orderMeta = [];
              decodedResponse['order']['ordermeta'].forEach((v) {
                orderMeta.add(new OrderMeta.fromMap(v));
              });
            }
            print("lisssstttttssss");

            testPrint(
              orderMeta,
              invoiceId,
              paymentMethod,
              billTotal,
              billSubTotal,
              billTax,
              billDiscount,
              totalItems,
              paymentStatus,
              orderTypeStatus,
              orderCreatedAt,
              tableName,
              "",
              type,
              change: change,
              cashPaid: cashPaid,
            );

            isMakingPayment.value = false;
            return true;
          } else {

            var orderListData = decodedResponse['order'];
            var invoiceId = orderListData['inv_id'];
            var paymentMethod = orderListData['payment_method'];
            var billTotal = orderListData['total'];
            var billSubTotal = orderListData['subtotal'];
            var billTax = orderListData['tax'];
            var billDiscount = orderListData['discount'];
            var totalItems = orderListData['item'];
            var paymentStatus = orderListData['payment_status'];
            var orderTypeStatus = orderListData['order_type_status'];
            var orderCreatedAt = orderListData['created_at'];
            var tableName = orderListData['table_name'];

            print(invoiceId);
            print("PaymentMethod$paymentMethod");
            print("PaymentStatus$paymentStatus");
            print(billTotal);
            print(billSubTotal);
            print(billTax);
            print(billDiscount);
            print(totalItems);

            print(decodedResponse['order']['ordermeta']);
            if (decodedResponse['order']['ordermeta'] != null) {
              orderMeta = [];
              decodedResponse['order']['ordermeta'].forEach((v) {
                orderMeta.add(new OrderMeta.fromMap(v));
              });
            }
            print("lisssstttttssss");

            testPrint(
              orderMeta,
              invoiceId,
              paymentMethod,
              billTotal,
              billSubTotal,
              billTax,
              billDiscount,
              totalItems,
              paymentStatus,
              orderTypeStatus,
              orderCreatedAt,
              tableName,
              "",
              type,
              change: change,
              cashPaid: cashPaid,
            );
            print("cashcounterrrrr in else");

            showToast(
                "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
          }
        } catch (e) {
          print("cashcounterrrrr in catch");

          parseErrorOccurred(e.toString());
        }
      }
      print("datataaaaaa222${(response.body)}");
      isMakingPayment.value = false;





  }

  testPrint(
      List<OrderMeta> orderMeta,
      invoiceId,
      paymentMethod,
      billTotal,
      billSubTotal,
      billTax,
      billDiscount,
      totalItems,
      paymentStatus,
      orderTypeStatus,
      orderCreatedAt,
      tableName,
      token,  type,
      {change,
      cashPaid}) async {
    pref = await SharedPreferences.getInstance();
    var paper = pref.getString('paper');
    print("selectedpaper${paper}");

    if (paper == '80mm')
    {
      print("80mm Printing here");

      profile = await CapabilityProfile.load(name: 'XP-N160I');

      generator = Generator(PaperSize.mm80, profile!);
      printTxt += generator?.setGlobalCodeTable('CP1252') ?? [];
      const double qrSize = 300;

      final uiImg = await QrPainter(
        data: token,
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(qrSize);
      final dir = await getTemporaryDirectory();
      final pathName = '${dir.path}/qr_tmp.png';
      final qrFile = File(pathName);
      final imgFile = await qrFile.writeAsBytes(uiImg!.buffer.asUint8List());
      final img = decodeImage(imgFile.readAsBytesSync());
      // cor = QRCorrection.L;
      // for (var a in orderMeta) {
      //   print(a.products!.title);
      //   print(a.createdAt);
      // }

      bluetooth.isConnected.then((isConnected) async {
        double extraPrice = 0;
        double variantPrices = 0;
        if (isConnected!) {
          try {
            DateTime now = DateTime.now();

            await bluetooth.printCustom(
                DateFormat('kk:mm:ss , EEE d MMM').format(now), 0, 1);
            // await bluetooth.printNewLine();
            await bluetooth.printCustom("MEALSMASH", 2, 1);
            await bluetooth.printNewLine();
            // await bluetooth.printCustom("\n",0, 0);
            bluetooth.printLeftRight("Invoice: $invoiceId", '', 1);
            // bluetooth.printLeftRight("Date: $orderCreatedAt       ", "", 1);

            // , "  Type: ${invoiceData.orderTypeStatus}", 0)

            await bluetooth.printCustom("Payment Method: $paymentMethod", 0, 0);
            await bluetooth.printCustom(
                "Payment Status: ${paymentStatus == '0' ? "Pending" : 'Paid'}",
                0,
                0);
            await bluetooth.printCustom(
                "Order-Type: $orderTypeStatus",
                // "Payment Status: ${paymentStatus == 1 ? "Paid" : "Not Paid"}",
                0,
                0);
            await bluetooth.printCustom(
                "Table Name: $tableName",
                // "Payment Status: ${paymentStatus == 1 ? "Paid" : "Not Paid"}",
                0,
                0);
            // await bluetooth.printLeftRight("Order-Type: ", "$orderTypeStatus", 0);
            // await bluetooth.printCustom("Payment Method: ${invoiceData.paymentMethod == 'cod' ? "cash": 'Bullseye' } \nPayment Status: ${invoiceData.paymentStatus == '1'? "Paid" : "Not Paid"}\n",0, 0);
            await bluetooth.printNewLine();
            await bluetooth.printCustom("Sale Receipt", 1, 1);
            await bluetooth.printNewLine();
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            await bluetooth.printLeftRight(
                "Items".toUpperCase(), "Total".toUpperCase(), 0);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            // int p;
            for (var i = 0; i < orderMeta.length; i++) {
              // p = ;

              // if (orderMeta[i].products!.title!.length == 13) {
              //   bluetooth.printLeftRight(
              //       "${orderMeta[i].products!.title}\t\t\t         ",
              //       "           \t\t\t\t\$ ${orderMeta[i].total.toString()}",
              //       0);
              // } else if (orderMeta[i].products!.title!.length < 14) {
              //   bluetooth.printLeftRight(
              //       "${orderMeta[i].products!.title}\t\t\t\t           ",
              //       "           \t\t\t\t\$ ${orderMeta[i].total.toString()}",
              //       0);
              // } else if ((orderMeta[i].products!.title)!.length < 19) {
              //   bluetooth.printLeftRight(
              //       "${orderMeta[i].products!.title}\t\t\t\t         ",
              //       "        \t\t\t\t\$${orderMeta[i].total.toString()}",
              //       0);
              // }
              // else if ((orderMeta[i].products!.title)!.length > 19) {
              bluetooth.printLeftRight("${orderMeta[i].products!.title}",
                  "\$ ${orderMeta[i].total.toString()}", 0);
              // }

              if (orderMeta[i].variantName != null) {
                bluetooth.printLeftRight("(${orderMeta[i].variantName})",
                    "+\$ ${orderMeta[i].variantPrice}", 0);
              }
              bluetooth.printLeftRight(
                  "\$ ${orderMeta[i].products!.price!.price
                      .toString()} x ${orderMeta[i].qty.toString()}",
                  "",
                  0);

              if (orderMeta[i].orderItemExtras!.isNotEmpty) {
                for (var o = 0; o < orderMeta[i].orderItemExtras!.length; o++) {
                  bluetooth.printLeftRight(
                      "+ ${orderMeta[i].orderItemExtras![o].extraName}",
                      "+\$ ${orderMeta[i].orderItemExtras![o].extraPrice}",
                      0);

                  // orderMeta[i].orderItemExtras![o].extraPrice != null
                  //     ? extraPrice = extraPrice +
                  //     int.parse(orderMeta[i].orderItemExtras![o].extraPrice!)
                  //     : extraPrice = extraPrice;
                  // bluetooth.printLeftRight(
                  //     "+ ${orderMeta[i].orderItemExtras![o].extraName}",
                  //     " \t\t +\$ ${orderMeta[i].orderItemExtras![o].extraPrice}",
                  //     0);
                  // "+\$ ${orderMeta[i].orderItemExtras![o].extraPrice}",
                  // 0);

                  // bluetooth.printLeftRight("+ ${invoiceData.orderMeta[i].orderItemExtras[o].extraName}       ", "        +\$ ${invoiceData.orderMeta[i].orderItemExtras[o].extraPrice}",0);
                }
              }
              // await bluetooth.printCustom(
              //     "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice} "
              //         "x ${orderMeta[i].qty.toString()}",
              //     // "\$ ${orderMeta[i].products!.price!.price.toString()} x ${orderMeta[i].qty.toString()}",
              //     0,
              //     0);
              await bluetooth.printNewLine();
              extraPrice = 0;
            }

            // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
            // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
            // await flutterUsbPrinter.printText("\n");
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            bluetooth.printLeftRight("Sub Total", "\$ $billSubTotal", 1);
            // await flutterUsbPrinter.printText("\n");
            bluetooth.printLeftRight("Discount", "\$ 0.$billDiscount", 1);
            // await flutterUsbPrinter.printText("\n");
            bluetooth.printLeftRight("Tax", "\$ $billTax", 1);
            // await flutterUsbPrinter.printText("\n");
            // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            bluetooth.printLeftRight(
                "${paymentStatus == '0' ? "Net Payable" : 'Net Paid'} ",
                "\$ $billTotal", 1);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            if (cashPaid != null && cashPaid != "") {
              await bluetooth.printLeftRight(
                  "Cash Received", "\$ $cashPaid", 1);
            }

            if (change != null && change != "") {
              await bluetooth.printLeftRight("Change", "\$ $change", 1);
            }
            await bluetooth.printNewLine();
            if (token != null && token != "") {
              await bluetooth.printCustom("Scan to pay", 1, 1);
              await bluetooth.printCustom("Via", 1, 1);
              await bluetooth.printCustom("Bullseye", 1, 1);
              await bluetooth.printNewLine();
              await bluetooth.printImage(img.toString());
            }
          } on PlatformException {
            String response = 'Failed to get platform.';

            Fluttertoast.showToast(
                msg: response,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 18.0);

            print(response);
          }
        } else {
          _print() async {
            try {
              DateTime now = DateTime.now();
              printTxt += generator!.text(
                  DateFormat('kk:mm:ss , EEE d MMM').format(now),
                  styles: PosStyles(align: PosAlign.center));
              printTxt+=generator!.text("");
              printTxt += generator!.text("${pref.getString('name')}\n",
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
                  text: "Invoice# : $invoiceId     ",
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

              // printTxt += generator!.text("Invoice# : $invoiceId     ",
              //     styles: PosStyles(align: PosAlign.left));

              printTxt += generator!.row([
                PosColumn(
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "Payment Status: ${paymentStatus == '0'
                      ? "Pending"
                      : 'Paid'} ",
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

              // printTxt += generator!.text(
              //     "Payment Status: ${paymentStatus == '0' ? "Pending" : 'Paid'} ",
              //     styles: PosStyles(align: PosAlign.left));

              printTxt += generator!.row([
                PosColumn(
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "Payment Method: ${paymentMethod == 'cod'
                      ? "${type}"
                      : 'Bullseye' }  ",
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

              // printTxt += generator!.text("Payment Method : ${paymentMethod}  ",
              //     styles: PosStyles(align: PosAlign.left));

              printTxt += generator!.row([
                PosColumn(
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "Order-Type: $orderTypeStatus ",
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

              // printTxt += generator!.text("Order-Type: $orderTypeStatus ",
              //     styles: PosStyles(align: PosAlign.left));
              if (tableName != null && tableName != "") {
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "Table Name: $tableName \n",
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
              }

              // if (tableName != null && tableName != "") {
              //   printTxt += generator!.text("Table Name: $tableName \n",
              //       styles: PosStyles(align: PosAlign.left));
              // }

              if (tableName == null && tableName == "") {
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "\n",
                    width: 10,
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

              // if (tableName == null && tableName == "") {
              //   printTxt += generator!.text("\n");
              // }

              printTxt += generator!.text("Sale Receipt",
                  styles: PosStyles(
                      height: PosTextSize.size2,
                      width: PosTextSize.size2,
                      align: PosAlign.center,
                      bold: true));
              // printTxt+=generator!.text("\n");
              printTxt += generator!.row([
                PosColumn(
                  text: '              ',
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
                  text: '             ',
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
                  text: 'TOTAL',
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
              // printTxt +=
              //     generator!.text("----------------------------------------");
              // printTxt+=generator!.text("\n");

              for (var i = 0; i < orderMeta.length; i++) {
                int titleLength = orderMeta[i].products!.title!.length;

                printTxt += generator!.row([
                  PosColumn(
                    text: '        ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "${orderMeta[i].products!.title}",
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
                    text: '\$ ${orderMeta[i].products!.price!.price
                        .toString()}',
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
                // printTxt+=generator!.text("${orderMeta[i].products!.title} ",styles: PosStyles(align: PosAlign.left)) +
                //
                // generator!.text( " \$ ${orderMeta[i].products!.price!.price.toString()} \n",styles: PosStyles(align: PosAlign.right));
                if (orderMeta[i].variantName != null) {
                  printTxt += generator!.row([
                    PosColumn(
                      text: '          ',
                      width: 1,
                      styles: PosStyles(
                        align: PosAlign.left,
                      ),
                    ),
                    PosColumn(
                      text: "(${orderMeta[i].variantName.toString()})",
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
                      text: '+\$ ${orderMeta[i].variantPrice}',
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
                  // printTxt+=generator!.text("(${orderMeta[i].variantName.toString()}) \t\t +\$ ${orderMeta[i].variantPrice} \n");
                }


                if (orderMeta[i].orderItemExtras!.isNotEmpty) {
                  for (var o = 0; o <
                      orderMeta[i].orderItemExtras!.length; o++) {
                    orderMeta[i].orderItemExtras![o].extraPrice != null
                        ? extraPrice = extraPrice +
                        double.parse(
                            orderMeta[i].orderItemExtras![o].extraPrice!)
                        : extraPrice = extraPrice;

                    printTxt += generator!.row([
                      PosColumn(
                        text: '          ',
                        width: 1,
                        styles: PosStyles(
                          align: PosAlign.left,
                        ),
                      ),
                      PosColumn(
                        text: "+${orderMeta[i].orderItemExtras![o].extraName!}",
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
                        '+\$ ${orderMeta[i].orderItemExtras![o].extraPrice}',
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
                    // printTxt+=generator!.text("+${orderMeta[i].orderItemExtras![o].extraName!} \t\t +\$ ${orderMeta[i].orderItemExtras![o].extraPrice} \n");

                  }
                }

                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "\$ ${(orderMeta[i].variantPrice != null ? double.parse(
                        orderMeta[i].variantPrice!) : variantPrices) +
                        (orderMeta[i].products!.total != null ? double.parse(
                            orderMeta[i].products!.total!) : 0) + extraPrice}"
                    // "\$ ${orderMeta[i].products!.price!.price.toString()}"
                        " x ${orderMeta[i].qty.toString()}",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "       ",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: '',
                    width: 2,
                    styles: PosStyles(
                      align: PosAlign.right,
                    ),
                  ),
                  PosColumn(
                    text: "          ",
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                ]);

                // printTxt += generator!.text(
                //     "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice}"
                //     // "\$ ${orderMeta[i].products!.price!.price.toString()}"
                //     " x ${orderMeta[i].qty.toString()}");
                // printTxt+=generator!.text("\n");
                extraPrice = 0;
              }
              // printTxt+=generator!.text("\n");
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
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "SubTotal",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "       ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: '\$ $billSubTotal',
                  width: 2,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                PosColumn(
                  text: "          ",
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
                  text: "Discount",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "       ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: '\$ 0.$billDiscount',
                  width: 2,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                PosColumn(
                  text: "          ",
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
                  text: "Tax",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "       ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: '\$ $billTax',
                  width: 2,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                PosColumn(
                  text: "          ",
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
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "${paymentStatus == '0' ? "Net Payable" : 'Net Paid'} ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "       ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: '\$ $billTotal',
                  width: 2,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                PosColumn(
                  text: "          ",
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

              if (cashPaid != null && cashPaid != "") {
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "Cash Received",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "       ",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: '\$ $cashPaid',
                    width: 2,
                    styles: PosStyles(
                      align: PosAlign.right,
                    ),
                  ),
                  PosColumn(
                    text: "          ",
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                ]);
              }

              if (change != null && change != "")
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "Change",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "       ",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: '\$ $change',
                    width: 2,
                    styles: PosStyles(
                      align: PosAlign.right,
                    ),
                  ),
                  PosColumn(
                    text: "          \n",
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                ]);
              if (token != null && token != "") {
                printTxt += generator!.text("\n");
                printTxt += generator!.text("Scan to pay",
                    styles: PosStyles(
                      height: PosTextSize.size1,
                      width: PosTextSize.size1,
                      align: PosAlign.center,
                      bold: true,
                    ));
                printTxt += generator!.text("");

                printTxt += generator!.text("Via",
                    styles: PosStyles(
                      height: PosTextSize.size1,
                      width: PosTextSize.size1,
                      align: PosAlign.center,
                      bold: true,
                    ));
                printTxt += generator!.text("");

                printTxt += generator!.text("Bullseye\n",
                    styles: PosStyles(
                      height: PosTextSize.size2,
                      width: PosTextSize.size2,
                      align: PosAlign.center,
                      bold: true,
                    ));

                printTxt += generator!.qrcode(token.toString(), size: QRSize.Size6);
              }
              await AppConfig.printerSetupState
                  ?.printReceiveTest(printTxt, generator);
              printTxt.clear();


            } on PlatformException {
              String response = 'Failed to get platform version.';
              print("Failed to get platform version");
              Fluttertoast.showToast(
                  msg: response,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              print(response);
            }
          }

          returned
              ? await _print()
              : Fluttertoast.showToast(
              msg: "Invoice printer not connected",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }

    else
    {
      print("58mm Printing here");
      profile = await CapabilityProfile.load(name: 'XP-N160I');

      generator = Generator(PaperSize.mm58, profile!);
      printTxt += generator?.setGlobalCodeTable('CP1252') ?? [];
      const double qrSize = 300;

      final uiImg = await QrPainter(
        data: token,
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(qrSize);
      final dir = await getTemporaryDirectory();
      final pathName = '${dir.path}/qr_tmp.png';
      final qrFile = File(pathName);
      final imgFile = await qrFile.writeAsBytes(uiImg!.buffer.asUint8List());
      final img = decodeImage(imgFile.readAsBytesSync());
      // cor = QRCorrection.L;
      // for (var a in orderMeta) {
      //   print(a.products!.title);
      //   print(a.createdAt);
      // }

      bluetooth.isConnected.then((isConnected) async {
        double extraPrice = 0;
        double variantPrices = 0;
        if (isConnected!) {
          try {
            DateTime now = DateTime.now();

            await bluetooth.printCustom(
                DateFormat('kk:mm:ss , EEE d MMM').format(now), 0, 1);
            // await bluetooth.printNewLine();
            await bluetooth.printCustom("MEALSMASH", 2, 1);
            await bluetooth.printNewLine();
            // await bluetooth.printCustom("\n",0, 0);
            bluetooth.printLeftRight("Invoice: $invoiceId", '', 1);
            // bluetooth.printLeftRight("Date: $orderCreatedAt       ", "", 1);

            // , "  Type: ${invoiceData.orderTypeStatus}", 0)

            await bluetooth.printCustom("Payment Method: $paymentMethod", 0, 0);
            await bluetooth.printCustom(
                "Payment Status: ${paymentStatus == '0' ? "Pending" : 'Paid'}",
                0,
                0);
            await bluetooth.printCustom(
                "Order-Type: $orderTypeStatus",
                // "Payment Status: ${paymentStatus == 1 ? "Paid" : "Not Paid"}",
                0,
                0);
            await bluetooth.printCustom(
                "Table Name: $tableName",
                // "Payment Status: ${paymentStatus == 1 ? "Paid" : "Not Paid"}",
                0,
                0);
            // await bluetooth.printLeftRight("Order-Type: ", "$orderTypeStatus", 0);
            // await bluetooth.printCustom("Payment Method: ${invoiceData.paymentMethod == 'cod' ? "cash": 'Bullseye' } \nPayment Status: ${invoiceData.paymentStatus == '1'? "Paid" : "Not Paid"}\n",0, 0);
            await bluetooth.printNewLine();
            await bluetooth.printCustom("Sale Receipt", 1, 1);
            await bluetooth.printNewLine();
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            await bluetooth.printLeftRight(
                "Items".toUpperCase(), "Total".toUpperCase(), 0);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            // int p;
            for (var i = 0; i < orderMeta.length; i++) {
              // p = ;

              // if (orderMeta[i].products!.title!.length == 13) {
              //   bluetooth.printLeftRight(
              //       "${orderMeta[i].products!.title}\t\t\t         ",
              //       "           \t\t\t\t\$ ${orderMeta[i].total.toString()}",
              //       0);
              // } else if (orderMeta[i].products!.title!.length < 14) {
              //   bluetooth.printLeftRight(
              //       "${orderMeta[i].products!.title}\t\t\t\t           ",
              //       "           \t\t\t\t\$ ${orderMeta[i].total.toString()}",
              //       0);
              // } else if ((orderMeta[i].products!.title)!.length < 19) {
              //   bluetooth.printLeftRight(
              //       "${orderMeta[i].products!.title}\t\t\t\t         ",
              //       "        \t\t\t\t\$${orderMeta[i].total.toString()}",
              //       0);
              // }
              // else if ((orderMeta[i].products!.title)!.length > 19) {
              bluetooth.printLeftRight("${orderMeta[i].products!.title}",
                  "\$ ${orderMeta[i].total.toString()}", 0);
              // }

              if (orderMeta[i].variantName != null) {
                bluetooth.printLeftRight("(${orderMeta[i].variantName})",
                    "+\$ ${orderMeta[i].variantPrice}", 0);
              }
              bluetooth.printLeftRight(
                  "\$ ${orderMeta[i].products!.price!.price
                      .toString()} x ${orderMeta[i].qty.toString()}",
                  "",
                  0);

              if (orderMeta[i].orderItemExtras!.isNotEmpty) {
                for (var o = 0; o < orderMeta[i].orderItemExtras!.length; o++) {
                  bluetooth.printLeftRight(
                      "+ ${orderMeta[i].orderItemExtras![o].extraName}",
                      "+\$ ${orderMeta[i].orderItemExtras![o].extraPrice}",
                      0);

                  // orderMeta[i].orderItemExtras![o].extraPrice != null
                  //     ? extraPrice = extraPrice +
                  //     int.parse(orderMeta[i].orderItemExtras![o].extraPrice!)
                  //     : extraPrice = extraPrice;
                  // bluetooth.printLeftRight(
                  //     "+ ${orderMeta[i].orderItemExtras![o].extraName}",
                  //     " \t\t +\$ ${orderMeta[i].orderItemExtras![o].extraPrice}",
                  //     0);
                  // "+\$ ${orderMeta[i].orderItemExtras![o].extraPrice}",
                  // 0);

                  // bluetooth.printLeftRight("+ ${invoiceData.orderMeta[i].orderItemExtras[o].extraName}       ", "        +\$ ${invoiceData.orderMeta[i].orderItemExtras[o].extraPrice}",0);
                }
              }
              // await bluetooth.printCustom(
              //     "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice} "
              //         "x ${orderMeta[i].qty.toString()}",
              //     // "\$ ${orderMeta[i].products!.price!.price.toString()} x ${orderMeta[i].qty.toString()}",
              //     0,
              //     0);
              await bluetooth.printNewLine();
              extraPrice = 0;
            }

            // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
            // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
            // await flutterUsbPrinter.printText("\n");
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            bluetooth.printLeftRight("Sub Total", "\$ $billSubTotal", 1);
            // await flutterUsbPrinter.printText("\n");
            bluetooth.printLeftRight("Discount", "\$ 0.$billDiscount", 1);
            // await flutterUsbPrinter.printText("\n");
            bluetooth.printLeftRight("Tax", "\$ $billTax", 1);
            // await flutterUsbPrinter.printText("\n");
            // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            bluetooth.printLeftRight(
                "${paymentStatus == '0' ? "Net Payable" : 'Net Paid'} ",
                "\$ $billTotal", 1);
            await bluetooth.printCustom(
                "-------------------------------------", 0, 1);
            if (cashPaid != null && cashPaid != "") {
              await bluetooth.printLeftRight(
                  "Cash Received", "\$ $cashPaid", 1);
            }

            if (change != null && change != "") {
              await bluetooth.printLeftRight("Change", "\$ $change", 1);
            }
            await bluetooth.printNewLine();
            if (token != null && token != "") {
              await bluetooth.printCustom("Scan to pay", 1, 1);
              await bluetooth.printCustom("Via", 1, 1);
              await bluetooth.printCustom("Bullseye", 1, 1);
              await bluetooth.printNewLine();
              await bluetooth.printImage(img.toString());
            }
          } on PlatformException {
            String response = 'Failed to get platform.';

            Fluttertoast.showToast(
                msg: response,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 18.0);

            print(response);
          }
        } else {
          _print() async {
            try {
              DateTime now = DateTime.now();
              printTxt += generator!.text(
                  DateFormat('kk:mm:ss , EEE d MMM').format(now),
                  styles: PosStyles(align: PosAlign.center));
              printTxt+=generator!.text("");
              printTxt += generator!.text("${pref.getString('name')}\n",
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
                  text: "Invoice# : $invoiceId     ",
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

              // printTxt += generator!.text("Invoice# : $invoiceId     ",
              //     styles: PosStyles(align: PosAlign.left));

              printTxt += generator!.row([
                PosColumn(
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "Payment Status: ${paymentStatus == '0'
                      ? "Pending"
                      : 'Paid'} ",
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

              // printTxt += generator!.text(
              //     "Payment Status: ${paymentStatus == '0' ? "Pending" : 'Paid'} ",
              //     styles: PosStyles(align: PosAlign.left));

              printTxt += generator!.row([
                PosColumn(
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "Payment Method: ${paymentMethod == 'cod'
                      ? "${type}"
                      : 'Bullseye' }  ",
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

              // printTxt += generator!.text("Payment Method : ${paymentMethod}  ",
              //     styles: PosStyles(align: PosAlign.left));

              printTxt += generator!.row([
                PosColumn(
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "Order-Type: $orderTypeStatus ",
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

              // printTxt += generator!.text("Order-Type: $orderTypeStatus ",
              //     styles: PosStyles(align: PosAlign.left));
              if (tableName != null && tableName != "") {
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "Table Name: $tableName \n",
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
              }

              // if (tableName != null && tableName != "") {
              //   printTxt += generator!.text("Table Name: $tableName \n",
              //       styles: PosStyles(align: PosAlign.left));
              // }

              if (tableName == null && tableName == "") {
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "\n",
                    width: 10,
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

              // if (tableName == null && tableName == "") {
              //   printTxt += generator!.text("\n");
              // }

              printTxt += generator!.text("Sale Receipt",
                  styles: PosStyles(
                      height: PosTextSize.size2,
                      width: PosTextSize.size2,
                      align: PosAlign.center,
                      bold: true));
              // printTxt+=generator!.text("\n");
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
                  text: ' TOTAL',
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
                  // styles: PosStyles(
                  //   align: PosAlign.left,
                  // ),
                ),
                PosColumn(
                  text: "----------------------------------------------------------------------",
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
              // printTxt +=
              //     generator!.text("----------------------------------------");
              // printTxt+=generator!.text("\n");

              for (var i = 0; i < orderMeta.length; i++) {
                int titleLength = orderMeta[i].products!.title!.length;

                printTxt += generator!.row([
                  PosColumn(
                    text: '        ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "${orderMeta[i].products!.title}               ",
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
                    text: ' \$ ${orderMeta[i].products!.price!.price.toString()}',
                    width: 3,
                    styles: PosStyles(
                      align: PosAlign.right,
                    ),
                  ),

                ]);
                // printTxt+=generator!.text("${orderMeta[i].products!.title} ",styles: PosStyles(align: PosAlign.left)) +
                //
                // generator!.text( " \$ ${orderMeta[i].products!.price!.price.toString()} \n",styles: PosStyles(align: PosAlign.right));
                if (orderMeta[i].variantName != null) {
                  printTxt += generator!.row([
                    PosColumn(
                      text: '            ',
                      width: 1,
                      styles: PosStyles(
                        align: PosAlign.left,
                      ),
                    ),
                    PosColumn(
                      text: "(${orderMeta[i].variantName.toString()})         ",
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
                      text: ' +\$ ${orderMeta[i].variantPrice}',
                      width: 3,
                      styles: PosStyles(
                        align: PosAlign.right,
                      ),
                    ),
                  ]);
                  // printTxt+=generator!.text("(${orderMeta[i].variantName.toString()}) \t\t +\$ ${orderMeta[i].variantPrice} \n");
                }
                if (orderMeta[i].orderItemExtras!.isNotEmpty) {
                  for (var o = 0; o <
                      orderMeta[i].orderItemExtras!.length; o++) {
                    orderMeta[i].orderItemExtras![o].extraPrice != null
                        ? extraPrice = extraPrice +
                        double.parse(
                            orderMeta[i].orderItemExtras![o].extraPrice!.toString())
                        : extraPrice = extraPrice;

                    printTxt += generator!.row([
                      PosColumn(
                        text: '              ',
                        width: 1,
                        styles: PosStyles(
                          align: PosAlign.left,
                        ),
                      ),
                      PosColumn(
                        text: "+${orderMeta[i].orderItemExtras![o].extraName!}          ",
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
                        ' +\$ ${orderMeta[i].orderItemExtras![o].extraPrice}',
                        width: 3,
                        styles: PosStyles(
                          align: PosAlign.right,
                        ),
                      ),
                    ]);
                    // printTxt+=generator!.text("+${orderMeta[i].orderItemExtras![o].extraName!} \t\t +\$ ${orderMeta[i].orderItemExtras![o].extraPrice} \n");

                  }
                }

                printTxt += generator!.row([
                  PosColumn(
                    text: '             ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "\$ ${(orderMeta[i].variantPrice != null ? double.parse(
                        orderMeta[i].variantPrice!.toString()) : variantPrices) +
                        (orderMeta[i].products!.total != null ? double.parse(
                            orderMeta[i].products!.total!.toString()) : 0) + extraPrice}"
                    // "\$ ${orderMeta[i].products!.price!.price.toString()}"
                        " x ${orderMeta[i].qty.toString()}         ",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "             ",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: '          ',
                    width: 2,
                    styles: PosStyles(
                      align: PosAlign.right,
                    ),
                  ),
                  PosColumn(
                    text: "          ",
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                ]);

                // printTxt += generator!.text(
                //     "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice}"
                //     // "\$ ${orderMeta[i].products!.price!.price.toString()}"
                //     " x ${orderMeta[i].qty.toString()}");
                // printTxt+=generator!.text("\n");
                extraPrice = 0;
              }
              // printTxt+=generator!.text("\n");
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
                  text: '            ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "Subtotal         ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "             ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: ' \$ $billSubTotal',
                  width: 3,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                // PosColumn(
                //   text: "          ",
                //   width: 1,
                //   styles: PosStyles(
                //     align: PosAlign.left,
                //   ),
                // ),
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
                  text: "Discount       ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "               ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: ' \$ 0.$billDiscount',
                  width: 3,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                // PosColumn(
                //   text: "          ",
                //   width: 1,
                //   styles: PosStyles(
                //     align: PosAlign.left,
                //   ),
                // ),
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
                  text: "Tax              " ,
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "                ",
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: ' \$ $billTax',
                  width: 3,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                // PosColumn(
                //   text: "          ",
                //   width: 1,
                //   styles: PosStyles(
                //     align: PosAlign.left,
                //   ),
                // ),
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
                  text: '          ',
                  width: 1,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "${paymentStatus == '0' ? "Net Payable   " : 'Net Paid      '} ",
                  width: 5,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: "           ",
                  width: 3,
                  styles: PosStyles(
                    align: PosAlign.left,
                  ),
                ),
                PosColumn(
                  text: ' \$ $billTotal',
                  width: 3,
                  styles: PosStyles(
                    align: PosAlign.right,
                  ),
                ),
                // PosColumn(
                //   text: "          ",
                //   width: 1,
                //   styles: PosStyles(
                //     align: PosAlign.left,
                //   ),
                // ),
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

              if (cashPaid != null && cashPaid != "") {
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "Cash Received    ",
                    width: 5,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "                ",
                    width: 3,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: ' \$ $cashPaid',
                    width: 3,
                    styles: PosStyles(
                      align: PosAlign.right,
                    ),
                  ),
                  // PosColumn(
                  //   text: "          ",
                  //   width: 1,
                  //   styles: PosStyles(
                  //     align: PosAlign.left,
                  //   ),
                  // ),
                ]);
              }

              if (change != null && change != "")
                printTxt += generator!.row([
                  PosColumn(
                    text: '          ',
                    width: 1,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "Change       ",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: "             ",
                    width: 4,
                    styles: PosStyles(
                      align: PosAlign.left,
                    ),
                  ),
                  PosColumn(
                    text: ' \$ $change',
                    width: 3,
                    styles: PosStyles(
                      align: PosAlign.right,
                    ),
                  ),
                  // PosColumn(
                  //   text: "          \n",
                  //   width: 1,
                  //   styles: PosStyles(
                  //     align: PosAlign.left,
                  //   ),
                  // ),
                ]);
              if (token != null && token != "") {
                printTxt += generator!.text("\n");
                printTxt += generator!.text("Scan to pay",
                    styles: PosStyles(
                      height: PosTextSize.size1,
                      width: PosTextSize.size1,
                      align: PosAlign.center,
                      bold: true,
                    ));
                printTxt += generator!.text("");
                printTxt += generator!.text("Via",
                    styles: PosStyles(
                      height: PosTextSize.size1,
                      width: PosTextSize.size1,
                      align: PosAlign.center,
                      bold: true,
                    ));
                printTxt += generator!.text("");
                printTxt += generator!.text("Bullseye\n",
                    styles: PosStyles(
                      height: PosTextSize.size2,
                      width: PosTextSize.size2,
                      align: PosAlign.center,
                      bold: true,
                    ));

                printTxt += generator!.qrcode(token.toString(), size: QRSize.Size6);
              }
              await AppConfig.printerSetupState
                  ?.printReceiveTest(printTxt, generator);
              printTxt.clear();


            } on PlatformException {
              String response = 'Failed to get platform version.';
              print("Failed to get platform version");
              Fluttertoast.showToast(
                  msg: response,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              print(response);
            }
          }

          returned
              ? await _print()
              : Fluttertoast.showToast(
              msg: "Invoice printer not connected",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }
  updateSquareCartItemQty(
      {required int cartItemId,
      required int productId,
      required double qty,
      required String tableId}) async {
    var response =
        await BaseClient().postWithAuth(Strings.updateSquareCartItemQtyUrl, {
      'cart_item_id': cartItemId,
      // 'product_id': productId,
      'qty': qty,
      // 'table_id': tableId,
    });
    if (response != null) {
      try {
        print("123");
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          print("1234");

          try {
            print("1234");

            if (decodedResponse['cart']['total'] != null) {
              SCart c = SCart.fromJson(decodedResponse['cart']);
              print("12345");

              // get updated item
              if (c.cartData != null) {
                var d =
                    c.cartData!.where((element) => element.id == cartItemId);

                if (scart.value.cartData != null) {
                  print("111");
                  for (int i = 0; i < scart.value.cartData!.length; i++) {
                    if (scart.value.cartData![i].id == cartItemId) {
                      print("jkasjkasdrdfsjk${scart.value.cartData![i]}");
                      scart.value.cartData![i] = d.first;
                      scart.value.total = c.total;
                      scart.value.tax = c.tax;
                      scart.value.subtotal = c.subtotal;
                      scart.value.discount = c.discount;
                      update();
                      break;
                    }
                  }
                }
              }

              update();
              // cart.value = CartResponse.fromMap(decodedResponse['cart']);
            } else {
              scart.value = SCart();
              print("123456");
            }
          } catch (e) {
            parseErrorOccurred("12345678 ${e.toString()}");
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
  }

  updateCartItemQty(
      {required int cartItemId,
      required int productId,
      required double qty,
      required String tableId}) async {
    var response =
        await BaseClient().postWithAuth(Strings.updateCartItemQtyUrl, {
      'cart_id': cartItemId,
      'product_id': productId,
      'qty': qty,
      'table_id': tableId,
    });
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          try {
            if (decodedResponse['cart']['status']) {
              CartResponse c = CartResponse.fromMap(decodedResponse['cart']);
              // get updated item
              if (c.cartData != null) {
                var d =
                    c.cartData!.where((element) => element.id == cartItemId);

                if (cart.value.cartData != null) {
                  for (int i = 0; i < cart.value.cartData!.length; i++) {
                    if (cart.value.cartData![i].id == cartItemId) {
                      cart.value.cartData![i] = d.first;
                      cart.value.total = c.total;
                      cart.value.tax = c.tax;
                      cart.value.subtotal = c.subtotal;
                      cart.value.discount = c.discount;
                      update();
                      break;
                    }
                  }
                }
              }

              // cart.value = CartResponse.fromMap(decodedResponse['cart']);
            } else {
              cart.value = CartResponse();
            }
          } catch (e) {
            parseErrorOccurred(
                "Assigning Value to Cart Variable 5${e.toString()}");
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
  }

// updateCartItemQty(
//     {required int cartItemId,
//     required int productId,
//     required int qty}) async {
//   isUpdatingCart.value = true;
//   var response =
//       await BaseClient().postWithAuth(Strings.updateCartItemQtyUrl, {
//     'cart_id': cartItemId,
//     'product_id': productId,
//     'qty': qty,
//   });
//   if (response != null) {
//     try {
//       var decodedResponse = jsonDecode(response.body);
//       if (decodedResponse['status']) {
//         try {
//           if (decodedResponse['cart']['status']) {
//             CartResponse updatedCart =
//                 CartResponse.fromMap(decodedResponse['cart']);
//
//             if (cart.value.cartData != null) {
//               for (int i = 0; i < cart.value.cartData!.length; i++) {
//                 CartItem element = cart.value.cartData![i];
//                 if (element.id == cartItemId) {
//                   // Item Found in Cart Data
//                   var d = updatedCart.cartData!
//                       .where((element) => element.id == cartItemId);
//                   if (d.length > 0) {
//                     cart.value.cartData![i] = d.first;
//                     cart.value.total = updatedCart.total;
//                     cart.value.coupon = updatedCart.coupon;
//                     cart.value.discount = updatedCart.discount;
//                     cart.value.storeName = updatedCart.storeName;
//                     cart.value.subtotal = updatedCart.subtotal;
//                     cart.value.tax = updatedCart.tax;
//                     break;
//                   }
//                 }
//               }
//             }
//           }
//           // else {
//           //   cart.value = CartResponse();
//           // }
//         } catch (e) {
//           parseErrorOccurred(
//               "Assigning Value to Cart Variable ${e.toString()}");
//         }
//       } else {
//         showToast(
//             "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
//       }
//     } catch (e) {
//       parseErrorOccurred(e.toString());
//     }
//   }
//   isUpdatingCart.value = false;
// }
  login({required String email, required String password}) async {
    var response = await BaseClient().post(
      Strings.loginUrl,
      '{"email":"${email.toLowerCase()}","password":"$password"}',
    );
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          var value =
              await saveCredentials(LoginResponse.fromJson(response.body));
          pref = await SharedPreferences.getInstance();
          var name = decodedResponse['data']['name'];
          pref.setString('name', name);
          print("name${name}");
          // var name = LoginResponse.fromJson(['data']);
          if (value != null) {
            getTablesDetail();
            Get.offAllNamed(PageRoutes.tableSelectionPage);

            getCategoriesDetail();
            getSquareCategoriesDetail();
            // getModifiers(item_id:item_id, store_id:store_id);
            // getCart();
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
  }

  void logOut() {
    isLoginBtnClicked.value = false;
    dispose();
  }

  void parseErrorOccurred(String string) {
    log("Data Parsing Error Occurred: $string");
    // showToast("Data Parsing Error Occurred: $string");
  }

  saveOrder({required String orderId}) async {
    isSavingOrder.value = true;
    var response = await BaseClient().getWithAuth(
      Strings.saveOrderUrl + "$orderId",
    );
    if (response != null) {
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          Get.offAllNamed(PageRoutes.splashPage);
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isSavingOrder.value = false;
  }

  applyDiscount({
    required String orderId,
    required String value,
    required String type,
  }) async {
    isApplyingDiscount.value = true;
    var response = await BaseClient().postWithAuth(Strings.applyDiscountUrl, {
      "amount": "$value",
      "type": "$type",
      "order_id": "$orderId",
    });
    if (response != null) {
      print("after applying discount get response:::");
      print(jsonDecode(response.body));
      try {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status']) {
          try {
            Order updatedOrder = Order.fromMap(decodedResponse['order']);
            return updatedOrder;
          } catch (e) {
            e.printError();
            parseErrorOccurred(e.toString());
          }
        } else {
          showToast(
              "${decodedResponse['message'] ?? decodedResponse['errors'] ?? "Error Occurred"}");
        }
      } catch (e) {
        parseErrorOccurred(e.toString());
      }
    }
    isApplyingDiscount.value = false;
  }
}
