import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hungerz_ordering/pages/SPayNowPage.dart';
import 'package:hungerz_ordering/pages/login.dart';
import 'package:hungerz_ordering/helper/colors.dart';
import 'package:hungerz_ordering/helper/strings.dart';
import 'package:hungerz_ordering/pages/order_placed.dart';
import 'package:hungerz_ordering/pages/pastorders.dart';
import 'package:hungerz_ordering/pages/pay_now_page.dart';
import 'package:hungerz_ordering/pages/payment_success_page.dart';
import 'package:hungerz_ordering/pages/printer_setup.dart';
import 'package:hungerz_ordering/pages/qr_screen.dart';
import 'package:hungerz_ordering/pages/search_result_page.dart';
import 'controllers/controller_binding.dart';
import 'helper/const.dart';
import 'locale/app_translation.dart';
import 'pages/items_page.dart';
import 'pages/settings_page.dart';
import 'pages/splash.dart';
import 'helper/routes.dart';
import 'pages/table_selection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init(Strings.keyDbName);
  runApp(ScreenUtilInit(
    // designSize:  Size(480, 800),
    designSize:  Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (BuildContext context, Widget? child) {
      return  GetMaterialApp(
        title: Strings.appName,
        translations: AppTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en'),
        theme: ThemeData(
          fontFamily: 'ProductSans',
          scaffoldBackgroundColor: BasicColors.white,
          backgroundColor: BasicColors.white,
          primaryColor: BasicColors.primaryColor,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: BasicColors.primaryColor,
            selectionHandleColor: BasicColors.primaryColor,
          ),
          unselectedWidgetColor: BasicColors.secondaryColor,
          appBarTheme: AppBarTheme(
            color: BasicColors.transparentColor,
            elevation: 0.0,
          ),
        ),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        initialRoute: PageRoutes.splashPage,
        initialBinding: ControllersBinding(),
        getPages: [
          GetPage(name: PageRoutes.splashPage, page: () => SplashPage()),
          GetPage(name: PageRoutes.settingPage, page: () => SettingsPage()),
          GetPage(name: PageRoutes.loginPage, page: () => LoginPage()),
          GetPage(name: PageRoutes.orderPlacedPage, page: () => OrderPlaced()),
          GetPage(name: PageRoutes.itemsPage, page: () => ItemsPage()),
          GetPage(name: PageRoutes.pastOrdersPage, page: () => PastOrdersPage()),

          GetPage(name: PageRoutes.qrPage, page: () => QrPage()),
          GetPage(name: PageRoutes.printerSetupPage, page: () => PrinterSetup()),
          GetPage(
              name: PageRoutes.paymentSuccessPage,
              page: () => PaymentSuccessPage()),
          GetPage(
              name: PageRoutes.searchResultPage, page: () => SearchResultPage()),
          GetPage(name: PageRoutes.payNowPage, page: () => PayNowPage()),
          GetPage(name: PageRoutes.SquarepayNowPage, page: () => SPayNowPage()),
          GetPage(
              name: PageRoutes.tableSelectionPage,
              page: () => TableSelectionPage()),
        ],
      );
    },

  ),
  );
  configLoading();
}
