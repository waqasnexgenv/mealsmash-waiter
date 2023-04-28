import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hungerz_ordering/controllers/common_controller.dart';
import 'package:hungerz_ordering/helper/colors.dart';
import 'package:hungerz_ordering/helper/strings.dart';
import 'package:hungerz_ordering/model/tables_response.dart';
import 'package:hungerz_ordering/pages/cart_info.dart';
import 'package:hungerz_ordering/widgets/build_items.dart';

import 'item_info.dart';

class SearchResultPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CommonController controller = Get.find<CommonController>();
  int? tableId;
  String? platform;
  String? ordertype;
  MyTable table = MyTable();

  SearchResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var params = Get.arguments;
    if (params != null) {
      if (params.length > 0) {
        tableId = params[0];
        ordertype= params[1];
        platform= params[2];
      }
    }
    return Obx(() {
      var tables = controller.tables.value.data
          ?.where((element) => element.id == tableId);
      if (tables != null) {
        if (tables.length > 0) {
          table = tables.first;
        }
      }

      return Scaffold(
        backgroundColor: BasicColors.getWhiteBlackColor(),
        key: _scaffoldKey,
        endDrawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 550),
          child: Obx(
            () => controller.isDrawerTypeCart.value == 1
                ? CartInfo(
                    controller: controller,
                    table: table,
                     orderType: ordertype,
                     platform: platform,
                  )
                : controller.isDrawerTypeCart.value == 2
                    ? showItemInfo()
                    : Container(),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "searchResult".tr,
            style: TextStyle(color: BasicColors.getBlackWhiteColor(),fontSize: 25.sp),
          ),
          actions: [Container()],
        ),
        body: Obx(() => controller.isSearchingItems.value
            ? kLoadingWidget()
            : Container(
                color: controller.isDarkTheme.value
                    ? BasicColors.secondaryBlackColor
                    : BasicColors.secondSecondaryColor,
                child: controller.searchResult.length < 1
                    ? Center(
                        child: Text(
                          "noResultFound".tr,
                          style: TextStyle(
                              color: BasicColors.getBlackWhiteColor()),
                        ),
                      )
                    : BuildItems.build(
                        controller.searchResult, controller, _scaffoldKey),
              )),
      );
    });
  }

  showItemInfo() {
    return ItemInfoPage(
      catName: controller.selectedCategoryName.value,
      scaffoldKey: _scaffoldKey,
      table: table,
      platform: 'platform',
    );
  }
}
