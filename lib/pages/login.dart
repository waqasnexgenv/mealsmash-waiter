import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/controllers/common_controller.dart';
import 'package:Mealsmash_Waiter/widgets/safe_area_helper.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';
import 'package:Mealsmash_Waiter/helper/strings.dart';
import 'package:Mealsmash_Waiter/widgets/entry_field.dart';

class LoginPage extends StatelessWidget {
  final CommonController controller = Get.find<CommonController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Login
    return SafeAreaHelper(
      child: Scaffold(
        backgroundColor: BasicColors.getWhiteBlackColor(),
        body: FadedSlideAnimation(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: FadedSlideAnimation(
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                controller.setDarkTheme(
                                    enableDarkTheme:
                                        !controller.isDarkTheme.value);
                              },
                              child: Image.asset(
                                "assets/logo.png",
                                width: 300.w,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 30),
                            child: Text(
                              "enterRegisteredEmail".tr.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: BasicColors.getBlackWhiteColor(),
                                  fontWeight: FontWeight.bold,),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: BasicColors.primaryColor,

                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text("emailAddress".tr.toUpperCase(),
                                    style: TextStyle(
                                        color:
                                            BasicColors.getBlackWhiteColor(),fontSize: 18.sp,fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20.sp),
                            child: EntryField(
                              controller: emailController,
                              hint: Strings.sampleEmailHint,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: BasicColors.primaryColor,

                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text("password".tr.toUpperCase(),
                                    style: TextStyle(
                                        color:
                                            BasicColors.getBlackWhiteColor(),fontSize: 18.sp,fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: EntryField(
                              controller: passwordController,
                              hint: Strings.samplePasswordHint,

                              keyboardType: TextInputType.emailAddress,
                              obscure: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    beginOffset: Offset(0.0, 0.3),
                    endOffset: Offset(0, 0),
                    slideCurve: Curves.linearToEaseOut,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (controller.isLoginBtnClicked.value) {
                    controller.isLoginBtnClicked.value = false;
                  } else {
                    if (emailController.text.length < 1) {
                      controller.showToast("pleaseEnterEmail".tr);
                      return;
                    }

                    if (!GetUtils.isEmail(
                        emailController.text.toUpperCase().trim())) {
                      controller.showToast("pleaseEnterValidEmail".tr);
                      return;
                    }

                    if (passwordController.text.length < 1) {
                      controller.showToast("pleaseEnterValidPassword".tr);
                      return;
                    }

                    controller.isLoginBtnClicked.value = true;

                    await controller.login(
                        email: emailController.text.toUpperCase().trim(),
                        password: passwordController.text);

                    controller.isLoginBtnClicked.value = false;
                  }
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 50.h,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.sp)),
                      color: BasicColors.primaryColor),
                  child: Obx(() => controller.isLoginBtnClicked.value
                      ? kLoadingWidget(loaderColor: BasicColors.white,size: 30.sp)
                      : Center(
                          child: Text(
                            'login'.tr,
                            style: TextStyle(
                                fontSize: 22.sp, color: BasicColors.white),
                          ),
                        )),
                ),
              )
            ],
          ),
          beginOffset: Offset(0.0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }
}
