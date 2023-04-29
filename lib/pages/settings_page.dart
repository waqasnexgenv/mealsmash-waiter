import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/helper/routes.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/pages/printer_setup.dart';
import 'package:Mealsmash_Waiter/widgets/my_back_button.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';
import 'package:Mealsmash_Waiter/widgets/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final CommonController controller = Get.find<CommonController>();

  bool sliderValue = false;
  String? selectedLocal;
  int counter = 0;
  var pref;
  var tokenn;
  var btDevice;
  var printerVendorId;
  var printerProductId;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool returned = false;

  @override
  void initState() {
    if (controller.selectedLanguage.value == 'en') {
      selectedLocal = 'English';
    } else if (controller.selectedLanguage.value == 'fr') {
      selectedLocal = 'Français';
    } else if (controller.selectedLanguage.value == 'pt') {
      selectedLocal = 'Português';
    } else if (controller.selectedLanguage.value == 'es') {
      selectedLocal = 'Español';
    } else if (controller.selectedLanguage.value == 'de') {
      selectedLocal = 'Deutsch';
    } else if (controller.selectedLanguage.value == 'it') {
      selectedLocal = 'Italiano';
    }else if (controller.selectedLanguage.value == 'ar'){
      selectedLocal = 'Arabic';
    }else if (controller.selectedLanguage.value == 'ind'){
      selectedLocal = 'Indonesian';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> language = [
      'English',
      'Français',
      'Português',
      'Deutsch',
      'Español',
      'Italiano',
      'Arabic',
      'Indonesian'
    ];
    bool isFirstTime = false;
    var params = Get.arguments;
    if (params != null) {
      if (params.length > 0) {
        isFirstTime = params[0];
      }
    }
    return SafeAreaHelper(
        child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // axis Axis.vertical;
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5,8,5,0),
              child: Row(
                children: [
                  isFirstTime ? Container() : MyBackButton(),
                  Padding(
                    padding: EdgeInsets.only(left: isFirstTime ? 20 : 0),
                    child: Text('setting'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: BasicColors.getBlackWhiteColor())),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            isFirstTime
                ? Container()
                : InkWell(
              onTap: (){

                showDialog(

                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Stack(
                            clipBehavior: Clip.none,
                            //overflow: Overflow.visible,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height* 0.3.h,
                                width: MediaQuery.of(context).size.width* 0.6.w,
                                // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.48: MediaQuery.of(context).size.height*0.26,
                                // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.96:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.45: MediaQuery.of(context).size.height*0.45,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      // SizedBox(
                                      //   height: MediaQuery.of(context).size.height*0.01,
                                      // ),
                                      Text(
                                        // waqas
                                        "Logout".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.sp,
                                            color: BasicColors.black),
                                      ),
                                      SizedBox(   height: MediaQuery.of(context).size.height*0.01.h,),
                                      Text(
                                        "Do you really want to logout?".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22.sp, color: BasicColors.black),
                                      ),
                                      Spacer(),
                                      // SizedBox(
                                      //   height: MediaQuery.of(context).size.height*0.02,
                                      // ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            // width: MediaQuery.of(context).size.width * 0.1.w,
                                            // height: MediaQuery.of(context).size.height * 0.13.h,
                                            width: MediaQuery.of(context).size.width * 0.14.w,
                                            height: MediaQuery.of(context).size.height * 0.06.h,
                                            decoration: BoxDecoration(
                                              color: BasicColors.primaryColor,
                                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
                                            ),
                                            child: TextButton(
                                              child: Text("no".tr,
                                                  style: TextStyle(
                                                      color: BasicColors.white,fontSize: 22.sp)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                // Get.back();
                                                // Get.offAllNamed(PageRoutes.splashPage);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width*0.02.w,
                                          ),
                                          Container(
                                            // width: MediaQuery
                                            //     .of(context)
                                            //     .size
                                            //     .width * 0.1.w,
                                            // height: MediaQuery
                                            //     .of(context)
                                            //     .size
                                            //     .height * 0.13.h,
                                            width: MediaQuery.of(context).size.width * 0.16.w,
                                            height: MediaQuery.of(context).size.height * 0.06.h,
                                            decoration: BoxDecoration(
                                              color: BasicColors.primaryColor,
                                              borderRadius: BorderRadius.circular(
                                                  MediaQuery.of(context).size.width *
                                                      0.03.w),
                                            ),
                                            child: TextButton(
                                              child: Text("yes".tr,
                                                  style: TextStyle(
                                                      color: BasicColors.white,fontSize: 22.sp)),
                                              onPressed: () async {
                                                Get.back();
                                                controller.logOutUser();
                                                // await controller.completeOrder(
                                                //     orderId: orderId as String,
                                                //     gotoTables: true
                                                // );
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
                                  top: -15.w,
                                  // MediaQuery.of(context).size.width * -0.07.w,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    radius: 15.sp,
                                    // MediaQuery.of(context).size.width * 0.1.w,
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 15.sp,
                                      // MediaQuery.of(context).size.width * 0.1.w,
                                    ),
                                  )),
                            ],
                          ));
                    });

                ///thk krna hy essy
    // showDialog(
    // context: context,
    // builder: (BuildContext context) {
    //   return
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 260),
    //       child: Dialog(
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(4.0)),
    //           child: Stack(
    //             clipBehavior: Clip.none,
    //             // overflow: Overflow.visible,
    //             alignment: Alignment.topCenter,
    //             children: [
    //               Container(
    //                 height: MediaQuery.of(context).size.height* 0.3.h,
    //                 width: MediaQuery.of(context).size.width* 0.6.w,
    //                 // height: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.7:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.height*0.38: MediaQuery.of(context).size.height*0.25,
    //                 // width: MediaQuery.of(context).size.width < 950?MediaQuery.of(context).size.height*0.56:  MediaQuery.of(context).size.width < 1200?MediaQuery.of(context).size.width*0.4: MediaQuery.of(context).size.width*0.39,
    //                 child: Padding(
    //                   // padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
    //                   padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
    //                   child: Column(
    //                     children: [
    //                       Spacer(),
    //                       // SizedBox(
    //                       //   height: MediaQuery.of(context).size.height*0.01,
    //                       // ),
    //                       Text(
    //                         "Logout".tr,
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 22.sp,
    //                             color: BasicColors.black),
    //                       ),
    //                       SizedBox(height: MediaQuery
    //                           .of(context)
    //                           .size
    //                           .height * 0.01.h,),
    //                       Text(
    //                         "Do you really want to logout?",
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                             fontSize: 22.sp, color: BasicColors.black),
    //                       ),
    //                       Spacer(),
    //                       // SizedBox(
    //                       //   height: MediaQuery.of(context).size.height*0.02,
    //                       // ),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         children: [
    //                           Container(
    //                             // width: MediaQuery
    //                             //     .of(context)
    //                             //     .size
    //                             //     .width * 0.1.w,
    //                             // height: MediaQuery
    //                             //     .of(context)
    //                             //     .size
    //                             //     .height * 0.13.h,
    //                             width: MediaQuery.of(context).size.width * 0.14.w,
    //                             height: MediaQuery.of(context).size.height * 0.05.h,
    //                             decoration: BoxDecoration(
    //                               color: BasicColors.primaryColor,
    //                               borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
    //                               // BorderRadius.circular(MediaQuery.of(context).size.width * 0.03.w),
    //                             ),
    //                             child: TextButton(
    //                               child: Text("no".tr,
    //                                   style: TextStyle(
    //                                       color: BasicColors.white,
    //                                       fontSize: 22.sp)),
    //                               onPressed: () {
    //                                 Navigator.pop(context);
    //                               },
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: MediaQuery
    //                                 .of(context)
    //                                 .size
    //                                 .width * 0.02.w,
    //                           ),
    //                           Container(
    //                             width: MediaQuery
    //                                 .of(context)
    //                                 .size
    //                                 .width * 0.1.w,
    //                             height: MediaQuery
    //                                 .of(context)
    //                                 .size
    //                                 .height * 0.13.h,
    //                             decoration: BoxDecoration(
    //                               color: BasicColors.primaryColor,
    //                               borderRadius: BorderRadius.circular(
    //                                   MediaQuery
    //                                       .of(context)
    //                                       .size
    //                                       .width *
    //                                       0.03.w),
    //                             ),
    //                             child: TextButton(
    //                               child: Text("yes".tr,
    //                                   style: TextStyle(
    //                                       color: BasicColors.white,
    //                                       fontSize: 22.sp)),
    //                               onPressed: () async {
    //                                 Get.back();
    //                                 controller.logOutUser();
    //                               },
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Positioned(
    //                   top: MediaQuery.of(context).size.width * -0.05.w,
    //                   child: CircleAvatar(
    //                     backgroundColor: Colors.redAccent,
    //                     radius: MediaQuery.of(context).size.width * 0.03.w,
    //                     child: Icon(
    //                       Icons.info_outline,
    //                       color: Colors.white,
    //                       size: MediaQuery.of(context).size.width * 0.03.w,
    //                     ),
    //                   )),
    //               // Positioned(
    //               //     top: MediaQuery.of(context).size.width * -0.03.w,
    //               //     child: CircleAvatar(
    //               //       backgroundColor:
    //               //       Colors.redAccent,
    //               //       radius:
    //               //       MediaQuery.of(context).size.width * 0.03.w,
    //               //       child: Icon(
    //               //         Icons.info_outline,
    //               //         color: Colors.white,
    //               //         size:
    //               //         MediaQuery.of(context).size.width * 0.03.w,
    //               //       ),
    //               //     )),
    //
    //             ],
    //           )),
    //     );
    // });
                // showDialog(
                //     context: context,
                //     barrierDismissible: true,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: Text("Logout"),
                //         content: Text("Do you really want to logout?"),
                //
                //         actions: <Widget>[
                //           TextButton(
                //             onPressed: () async {
                //
                //
                //               // homeProvider.Poststatus(token ,widget.id,"", "1"  );
                //               // await Future.delayed(Duration(seconds: 2));
                //
                //               // homeProvider.GetOrders(showLoading: true, token: token);
                //               // homeProvider.GetPastOrders(showLoading: true, token: token);
                //
                //               Navigator.pop(context);
                //               // Navigator.push(
                //               //     context,
                //               //     MaterialPageRoute(
                //               //         builder: (context) => OrderItemAccount(0
                //               //         )));
                //             },
                //             child: const Text('No',style: TextStyle(
                //               color:Colors.green,
                //             ),),
                //           ),
                //
                //           // widget.kitchenstatus=="Received"?
                //           TextButton(
                //             onPressed: () async {
                //               controller.logOutUser();
                //
                //             },
                //             child: const Text('Yes', style: TextStyle(
                //               color:Colors.red,
                //             ),),
                //           )
                //           // :Container(),
                //
                //
                //
                //         ],
                //
                //       );
                //     });




              },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text('logoutt'.tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: BasicColors.getBlackWhiteColor())),
                        ),
                        LogoutButton(),
                      ],
                    ),
                ),
            isFirstTime
                  ? Container():   Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color:BasicColors.dividerColor ,),
            ),
            isFirstTime
                ? Container()
                : InkWell(
              onTap: (){
                Get.to(() => PrinterSetup());
              },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.sp,
                          ),
                          child: Text('printsetupp'.tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: BasicColors.getBlackWhiteColor())),
                        ),
                        MyPrintButton(),
                      ],
                    ),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color:BasicColors.dividerColor ,),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5.h,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: ListTile(
                      title: Text(
                        'darkMode'.tr,
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: BasicColors.getBlackWhiteColor(),
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Switch(
                        value: controller.isDarkTheme.value,
                        activeColor: BasicColors.primaryColor,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value == true) {
                                controller.setDarkTheme(enableDarkTheme: true);
                              } else if (value == false) {
                                controller.setDarkTheme(enableDarkTheme: false);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.0.sp),
                    child: Divider(color:BasicColors.dividerColor ,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.sp),
                    child: Text('selectLanguage'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: BasicColors.getBlackWhiteColor())),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: language.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        value: language[index],
                        groupValue: selectedLocal,
                        activeColor: BasicColors.primaryColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Text(
                            language[index],
                            style: TextStyle(
                                color: BasicColors.getBlackWhiteColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp),
                          ),
                        ),
                        onChanged: (dynamic value) {
                          setState(() {
                            selectedLocal = value;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 102.h,
                  ),
                ],
                physics: BouncingScrollPhysics(),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomBar(
              text: 'submit'.tr,

              onTap: () {
                if (selectedLocal == 'English') {
                  controller.setSelectedLanguage(languageCode: "en");
                } else if (selectedLocal == 'Français') {
                  controller.setSelectedLanguage(languageCode: "fr");
                } else if (selectedLocal == 'Português') {
                  controller.setSelectedLanguage(languageCode: "pt");
                } else if (selectedLocal == 'Deutsch') {
                  controller.setSelectedLanguage(languageCode: "de");
                } else if (selectedLocal == 'Español') {
                  controller.setSelectedLanguage(languageCode: "es");
                } else if (selectedLocal == 'Italiano') {
                  controller.setSelectedLanguage(languageCode: "it");
                }else if (selectedLocal == 'Arabic') {
                  controller.setSelectedLanguage(languageCode: "ar");
                }else if (selectedLocal == 'Indonesian') {
                  controller.setSelectedLanguage(languageCode: "ind");
                }

                if (isFirstTime) {
                  Get.offAllNamed(PageRoutes.loginPage);
                } else {
                  Get.back();
                }
              }),
        ),
      ],
    ));
  }

  getShared() async {
    pref = await SharedPreferences.getInstance();
    tokenn = pref.getString('vendorToken');
    btDevice = pref.getString('btDevice');
    printerVendorId = pref.getString('printerVendorId');
    printerProductId = pref.getString('printerProductId');

    if (printerVendorId != null) {
      returned = (await flutterUsbPrinter.connect(
          int.parse(printerVendorId), int.parse(printerProductId)))!;
    }
  }
}
