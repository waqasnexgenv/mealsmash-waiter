import 'dart:async';
import 'dart:developer';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/model/Sorder.dart';
import 'package:Mealsmash_Waiter/model/area_response.dart';
import 'package:Mealsmash_Waiter/model/order.dart';
import 'package:Mealsmash_Waiter/model/tables_response.dart';
import 'package:Mealsmash_Waiter/pages/splash.dart';
import 'package:Mealsmash_Waiter/widgets/custom_circular_button.dart';
import 'package:Mealsmash_Waiter/widgets/logo_widget.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? globalUserId;

class TableSelectionPage extends StatefulWidget {
  TableSelectionPage({Key? key}) : super(key: key);

  @override
  State<TableSelectionPage> createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  final CommonController controller = Get.find<CommonController>();
  Timer? _timer;
  int secToWait = 3;
  int _start = 3;
  int looper = 0;

  AreaResponse? dropDownValue;

  String isIdValue = '';
  var pref;
  var platform;

  Configure() async {
    // pref = await SharedPreferences.getInstance();
    // platform = pref.getString('platform_configured');
    //
    // print("dasdasdasdas${platform}");
    await controller.getCategoriesDetail();
    await controller.getSquareCategoriesDetail();
    print("dasdasdasdas${platform}");
    pref = await SharedPreferences.getInstance();
    platform = pref.getString('platform_configured');
    globalUserId = pref.getString('vendor_id');
    print("ffffff${globalUserId}");
  }

  Channel? channel;

  PusherClient pusher = PusherClient(
    "2dafb9a1def702b25c10",
    PusherOptions(
      cluster: 'ap2',
      // if local on android use 10.0.2.2
      // host: 'localhost',
      // encrypted: false,
      // auth: PusherAuth(
      //   'http://example.com/broadcasting/auth',
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //   },
      // ),
    ),
    enableLogging: true,
  );

  @override
  void initState() {
    super.initState();

    Configure();
    controller.getFloorsDetail(showLoading: false);

    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
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

            await controller.getTablesDetail(
              showLoading: false,
              floorId: isIdValue,
            );
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
    // print("datatatatataatat${controller.tables.value.data}");
    // print("asdasasdasd ${pusher.getSocketId()}");
    pusher.onConnectionStateChange((state) {
      log("previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher.onConnectionError((error) {
      log("error: ${error?.message}");
    });

    // channel = pusher.subscribe(widget.videoCallWebSocketChannel??'None');
    // channel.bind('wahoox-new-video-meeting', (event) async{
    //   log("Video Call Data ${event?.data}");
    //
    //   String url = jsonDecode(event?.data??'none')['video_link'];
    //
    //
    //   // bool _gotCameraPemissions = await _getCameraPemissions();
    //   // bool _gotMicPemissions = await _getMicPemissions();
    //
    //   // print("URLLL ${API.base}create_metting/${widget.customerId}");
    //   // if(_gotCameraPemissions && _gotMicPemissions) {
    //   //
    //   //   meetingURL = url;
    //   //   // Future.delayed(Duration(seconds: 1),(){
    //   //   //
    //   //   setState(() {
    //   //
    //   //   });
    //   //   // });
    //   //   // Navigator.push(
    //   //   //   context,
    //   //   //   MaterialPageRoute(
    //   //   //     builder: (context) => PaymentPage(url: url,
    //   //   //     ),
    //   //   //   ),
    //   //   // );
    //   //
    //   // }
    // }
    // );
    // print("useriddd${globalUserId}");

    channel = pusher.subscribe("loginEvent$globalUserId");
    channel?.bind('login_event', (event) {
      log("event Data ${event?.data}");
      // clearSquareCartApiCall();
      // clearCartApiCall();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashPage()),
          (Route<dynamic> route) => false);
      // context
      //     .read(offerChatProvider.notifier)
      //     .OfferConversation(widget.customerId, update: true);
    });
    // print("stoppp${platform}");

    return SafeAreaHelper(
      child: Obx(
        () => (controller.isLoadingTables.value ||
                controller.isCompletingOrder.value)
            ? kLoadingWidget()
            : Scaffold(
                backgroundColor: BasicColors.getWhiteBlackColor(),
                appBar: AppBar(
                  // toolbarHeight:MediaQuery.of(context).size.height*0.16.h,
                  // MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.16:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.1: MediaQuery.of(context).size.height*0.06,

          automaticallyImplyLeading: false,
                  title: LogoWidgetmo(),
                  actions: [
                    Container(
                      // color: Colors.green,
                      // height: 40.h,
                      // width: MediaQuery.of(context).size.width*0.2.w,
width: 60.w,
          // height: 100.h,
          margin: EdgeInsets.all(4.0.sp),
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
                      // decoration: BoxDecoration(
                      //   color: BasicColors.primaryColor,
                      //   borderRadius: BorderRadius.circular(5.0),
                      // ),
                      child: DropdownButton2(

                        isExpanded: true,
                        // elevation: 0,

                        underline: Container(),

                        // borderRadius: BorderRadius.circular(5.0),
                        hint: dropDownValue == null
                            ?
                        controller.areaNames.isEmpty?Text(
                         "No Area",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color:
                            Theme.of(context).scaffoldBackgroundColor,
                          ),
                        )
                            :Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 8.0.sp),
                              child: Text(
                          controller.areaNames.value.first.areaName
                                .toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color:
                                        Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                            )
                            :
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0.sp),
                          child: Text(
                                  dropDownValue!.areaName.toString(),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color:
                                        Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                        ),

                        // Down Arrow Icon
                        icon:  Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.yellow,
                          size: 15.sp,
                        ),

                        dropdownWidth:  MediaQuery.of(context).size.width*0.2.w,
                        // buttonPadding:
                        //
                        //     EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        buttonDecoration: BoxDecoration(
                          color: BasicColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.0.sp),
                        ),
                        dropdownDecoration:BoxDecoration(
                          color: BasicColors.primaryColor,
                        ) ,
                        // dropdownPadding: EdgeInsets.only(right: 10),

                        // Array list of items
                        items: controller.areaNames.map((AreaResponse items) {
                          return DropdownMenuItem<AreaResponse>(

                            value: items,
                            child: Text(
                              items.areaName.toString(),
                              style: TextStyle(fontSize: 11.sp),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (dynamic newValue) {
                          setState(() {
                            dropDownValue = newValue!;
                            isIdValue = dropDownValue!.floorId.toString();
                            // controller.getTablesDetail(
                            //     showLoading: false,
                            //     floorId: dropDownValue!.floorId.toString());
                          });
                        },

                      ),
                    ),

                    GestureDetector(
                      onTap: () async {
                        controller.getPastOrders();
                        await Get.toNamed(PageRoutes.pastOrdersPage);
                        // print("platforrrm${platform}");
                        // controller.type.value="take_away";
                        // // if (platform != null) {
                        // await Get.toNamed(PageRoutes.itemsPage,
                        //     arguments: [0, 'take_away', platform]);
                        // }
                      },
                      child: Container(
                        // height: 100.h,
                        width: 60.w,
                        margin: EdgeInsets.all(4.0.sp),
                        decoration: BoxDecoration(
                          color: BasicColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.0.sp),


                        ),
                        child:
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 4.0.sp),
                              child: Text("Orders", style: TextStyle(fontSize: 11.sp),),
                            ),
                            Image.asset(
                              "assets/orderHistory.png",
                              width: 16.0.w,
                              // height: 30.0.h,
                              color: BasicColors.white,
                            ),
                            // Text("Orders", style: TextStyle(fontSize: 18.sp),),
                          ],
                        ),
                        // width: MediaQuery.of(context).size.width*0.22.w,
                      ),
                    ),
                    // SizedBox(
                    //   width: 18.w,
                    // ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     print("platforrrm${platform}");
                    //     controller.type.value="take_away";
                    //     // if (platform != null) {
                    //     await Get.toNamed(PageRoutes.itemsPage,
                    //         arguments: [0, 'take_away', platform]);
                    //     // }
                    //   },
                    //   child: Container(
                    //     // margin: EdgeInsets.all(8.0),
                    //     // height: 100.h,
                    //     width: 70.w,
                    //     decoration: BoxDecoration(
                    //       color: BasicColors.primaryColor,
                    //       borderRadius: BorderRadius.circular(5.0),
                    //     ),
                    //     // width: MediaQuery.of(context).size.width*0.22.w,
                    //     child: Row(
                    //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text("Take Away", style: TextStyle(fontSize: 11.sp),),
                    //         Image.asset(
                    //           "assets/take_away.png",
                    //            width: 30.0.w,
                    //           // height: 30.0.h,
                    //           color: BasicColors.white,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        controller.getPastOrders();
                        await Get.toNamed(PageRoutes.pastOrdersPage);
                        // print("platforrrm${platform}");
                        // controller.type.value="take_away";
                        // // if (platform != null) {
                        // await Get.toNamed(PageRoutes.itemsPage,
                        //     arguments: [0, 'take_away', platform]);
                        // }
                      },
                      child: Container(
                        // height: 100.h,
                        width: 62.w,
                        margin: EdgeInsets.all(4.0.sp),
                        decoration: BoxDecoration(
                          color: BasicColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.0.sp),


                        ),
                        child:
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 6.0.sp),
                              child: Text("Take Away", style: TextStyle(fontSize: 8.sp),),
                            ),
                            Image.asset(
                              "assets/take_away.png",
                              width: 10.0.w,
                              // height: 30.0.h,
                              color: BasicColors.white,
                            ),
                            // Text("Orders", style: TextStyle(fontSize: 18.sp),),
                          ],
                        ),
                        // width: MediaQuery.of(context).size.width*0.22.w,
                      ),
                    ),
                    // CustomButton(
                    //   title: Text("Take Away"),
                    //   onTap: () async {
                    //     await Get.toNamed(PageRoutes.itemsPage,
                    //         arguments: [0, 'take_away']);
                    //   },
                    //   padding: EdgeInsets.all(8.0),
                    //   borderRadius: 30.0,
                    //   bgColor: BasicColors.primaryColor,
                    //   margin: EdgeInsets.all(8.0),
                    // ),

                    // SizedBox(
                    //   width: 8.w,
                    // ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 16.sp,
                        color: BasicColors.getBlackWhiteColor(),
                      ),
                      onPressed: () {
                        Get.toNamed(PageRoutes.settingPage);
                      },
                    ),
                    // SizedBox(
                    //   width: 18.w,
                    // ),
                  ],
                ),
                body: Container(
                  color: controller.isDarkTheme.value
                      ? BasicColors.secondaryBlackColor
                      : BasicColors.secondSecondaryColor,
                  child: controller.tables.value.data == null
                      ? Center(
                          child: Text("noTablesFound".tr),
                        )
                      : Obx(
                         () {
                          return
                            controller.isLoadingCart.value==true?
                            kLoadingWidget(
                                loaderColor:Colors.red,
                                size: 25.sp)
                                :
                            GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              itemCount: controller.tables.value.data!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      ),
                              itemBuilder: (context, index) {
                                var tables = controller.tables.value.data;
                                MyTable table = tables![index];
                                return


                                  GestureDetector(
                                  onTap: () async {
                                    print("abc          ${platform}");

                                    if (platform != null) {
                                      stopTimer();
                                      print("abc        ${platform}");
                                      if (platform!="MEALSMASH"){
                                      controller.getSquareCart(table.id.toString());}
                                      else {
                                        startTimer();
                                       await controller.getCart(table.id.toString());
                                      }
                                      // await Get.toNamed(PageRoutes.itemsPage,
                                      //     arguments: [
                                      //       table.id,
                                      //       'dine_in',
                                      //       platform
                                      //     ]);

                                      await Get.toNamed(PageRoutes.itemsPage,
                                          arguments: [
                                            table.id,
                                            'dine_in',
                                            platform
                                          ]);
                                      startTimer();
                                    }

                                    // if (table.ongoingOrder == null) {
                                    //   stopTimer();
                                    //   await Get.toNamed(PageRoutes.itemsPage,
                                    //       arguments: [table.id]);
                                    //   startTimer();
                                    // } else if (isAllServed(table.ongoingOrder)) {
                                    //   stopTimer();
                                    //   await Get.toNamed(PageRoutes.itemsPage,
                                    //       arguments: [table.id]);
                                    //   startTimer();
                                    // }
                                  },
                                  child: FadedScaleAnimation(
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 14.w),
                                      // height: MediaQuery.of(context).size.height*3,
                                      decoration: BoxDecoration(
                                          color: table.ongoingOrder == null &&
                                                  table.ongoing_order_square == null
                                              ? BasicColors.white
                                              : getOrderColor(table.ongoingOrder,
                                                  table.ongoing_order_square),
                                          borderRadius: BorderRadius.circular(8.sp)),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${table.name}",
                                                    softWrap: true, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: table.ongoingOrder ==
                                                                    null &&
                                                                table.ongoing_order_square ==
                                                                    null
                                                            ? BasicColors.black
                                                            : BasicColors.white,
                                                        fontSize: 16.sp,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                // Spacer(),
                                                Expanded(
                                                  child: table.ongoingOrder == null &&
                                                          table.ongoing_order_square ==
                                                              null
                                                      ? SizedBox.shrink()
                                                      : Text(
                                                          "${(table.ongoingOrder == null ? table.ongoing_order_square!.createdAt!.toLocal().format('h:i A') : table.ongoingOrder!.createdAt!.toLocal().format('h:i A'))}",
                                                          style: TextStyle(
                                                            fontSize: 18.sp,
                                                            color: table.ongoingOrder ==
                                                                        null &&
                                                                    table.ongoing_order_square ==
                                                                        null
                                                                ? BasicColors.black
                                                                : BasicColors.white,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          textAlign: TextAlign.end,

                                                        ),
                                                )
                                              ],
                                            ),
                                            Spacer(),

                                            AspectRatio(
                                              aspectRatio: 2.5,
                                              child: Container(
                                                // height: MediaQuery.of(context).size.height,
                                                // width: MediaQuery.of(context).size.width,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset('assets/table-white.png', fit: BoxFit.fitHeight,

                                                      color: table.ongoingOrder ==
                                                          null &&
                                                          table.ongoing_order_square ==
                                                              null
                                                          ? BasicColors.primaryColor
                                                          : BasicColors.white,),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            Spacer(),
                                            // ListTile(
                                            //   onTap: (){},
                                            //   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                            //   title: Text('Table 1'), trailing: Text('1:33'),),
                                            Text(
                                              table.ongoingOrder == null &&
                                                      table.ongoing_order_square ==
                                                          null
                                                  ? "noOrder".tr
                                                  : "${getServedItems(table.ongoingOrder, table.ongoing_order_square)}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: table.ongoingOrder == null &&
                                                        table.ongoing_order_square ==
                                                            null
                                                    ? BasicColors.black
                                                    : BasicColors.white,fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    durationInMilliseconds: 200,
                                  ),
                                );
                              });
                        }
                      ),
                ),
              ),
      ),
    );
  }

  int SQgetServedCount(SQOrder? ongoing_order_square) {
    int served = 0;

    ongoing_order_square!.orderMeta!.forEach((element) {
      if (element.kStatus == 3) {
        served++;
      }
    });

    return served;
  }

  int getServedCount(Order? ongoingOrder) {
    int served = 0;

    ongoingOrder!.orderMeta!.forEach((element) {
      if (element.kStatus == 3) {
        served++;
      }
    });

    return served;
  }

  bool SqisAllServed(SQOrder? ongoing_order_square) {
    int total = ongoing_order_square!.orderMeta!.length;
    int served = SQgetServedCount(ongoing_order_square);
    return (total == served) ? true : false;
  }

  // bool isAllServed(Order? ongoingOrder) {
  //   int total = ongoingOrder!.orderMeta!.length;
  //   int served = getServedCount(ongoingOrder);
  //   return (total == served) ? true : false;
  // }

  // String SqgetServedItems(SQOrder? ongoing_order_square) {
  //   int total = ongoing_order_square!.orderMeta!.length;
  //   int served = SQgetServedCount(ongoing_order_square);
  //
  //   return "served".tr +
  //       " ${served.toString()}/${total.toString()} " +
  //       "items".tr;
  // }

  String getServedItems(Order? ongoingOrder, SQOrder? ongoing_order_square) {
    int total;
    int served;
    if (ongoingOrder == null) {
      total = ongoing_order_square!.orderMeta!.length;
      served = SQgetServedCount(ongoing_order_square);
    } else {
      total = ongoingOrder.orderMeta!.length;
      served = getServedCount(ongoingOrder);
    }

    return "served".tr +
        " ${served.toString()}/${total.toString()} " +
        "items".tr;
  }

  // Color SqgetOrderColor(SQOrder? ongoing_order_square) {
  //   int total = ongoing_order_square!.orderMeta!.length;
  //   int served = SQgetServedCount(ongoing_order_square);
  //
  //   return (total == served)
  //       ? BasicColors.completedOrderColor
  //       : BasicColors.orderInProgressColor;
  // }

  Color getOrderColor(Order? ongoingOrder, SQOrder? ongoing_order_square) {
    int total;
    int served;
    if (ongoingOrder == null) {
      total = ongoing_order_square!.orderMeta!.length;
      served = SQgetServedCount(ongoing_order_square);
    } else {
      total = ongoingOrder.orderMeta!.length;
      served = getServedCount(ongoingOrder);
    }

    return (total == served)
        ? BasicColors.completedOrderColor
        : BasicColors.orderInProgressColor;
  }
}
//
// class TableSelection extends StatefulWidget {
//   @override
//   _TableSelectionState createState() => _TableSelectionState();
// }
//
// class TableDetail {
//   Color color;
//   String time;
//   String? items;
//
//   TableDetail(this.color, this.time, this.items);
// }
//
// class _TableSelectionState extends State<TableSelection> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: GestureDetector(
//           onDoubleTap: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => LoginUi()));
//           },
//           child: FadedScaleAnimation(
//             RichText(
//                 text: TextSpan(children: <TextSpan>[
//               TextSpan(
//                   text: 'HUNGERZ',
//                   style: theme.of(context)
//                       .textTheme
//                       .subtitle1!
//                       .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold)),
//               TextSpan(
//                   text: 'eMENU',
//                   style: theme.of(context).textTheme.subtitle1!.copyWith(
//                       color: theme.of(context).primaryColor,
//                       letterSpacing: 1,
//                       fontWeight: FontWeight.bold)),
//             ])),
//             durationInMilliseconds: 400,
//           ),
//         ),
//         actions: [],
//       ),
//       body: Container(
//         color: theme.of(context).backgroundColor,
//         child: GridView.builder(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//             itemCount: ordersList.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 1.5),
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () => Navigator.pushNamed(context, PageRoutes.homePage),
//                 child: FadedScaleAnimation(
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//                     height: 80,
//                     decoration: BoxDecoration(
//                         color: ordersList[index].color,
//                         borderRadius: BorderRadius.circular(8)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               locale.table! + ' ' + '${index + 1}',
//                               style: theme.of(context)
//                                   .textTheme
//                                   .subtitle1!
//                                   .copyWith(
//                                       color: ordersList[index].color ==
//                                               theme.of(context)
//                                                   .scaffoldBackgroundColor
//                                           ? blackColor
//                                           : theme.of(context)
//                                               .scaffoldBackgroundColor,
//                                       fontSize: 17),
//                             ),
//                             // Spacer(),
//                             Expanded(
//                               child: Text(
//                                 ordersList[index].time,
//                                 style: theme.of(context)
//                                     .textTheme
//                                     .bodyText2!
//                                     .copyWith(
//                                         fontSize: 17,
//                                         color: ordersList[index].color ==
//                                                 theme.of(context)
//                                                     .scaffoldBackgroundColor
//                                             ? blackColor
//                                             : theme.of(context)
//                                                 .scaffoldBackgroundColor),
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.end,
//                               ),
//                             )
//                           ],
//                         ),
//                         Spacer(),
//                         // ListTile(
//                         //   onTap: (){},
//                         //   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
//                         //   title: Text('Table 1'), trailing: Text('1:33'),),
//                         Text(
//                           ordersList[index].items!,
//                           style: theme.of(context).textTheme.subtitle1!.copyWith(
//                               fontSize: 15,
//                               color: ordersList[index].color ==
//                                       theme.of(context).scaffoldBackgroundColor
//                                   ? Color(0xff777777)
//                                   : theme.of(context).scaffoldBackgroundColor),
//                         )
//                       ],
//                     ),
//                   ),
//                   durationInMilliseconds: 200,
//                 ),
//               );
//             }),
//       ),
//     );
//
//
//   }
// }
