import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';

class CustomButton extends StatelessWidget {
  final Widget? title;
  final Icon? leading;
  final Function onTap;
  final EdgeInsets? padding;
  final Color? bgColor;
  final EdgeInsets? margin;
  final double? borderRadius;

  CustomButton(
      {Key? key,
      this.title,
      this.leading,
      required this.onTap,
      this.padding,
      this.bgColor,
      this.margin,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(borderRadius != null ? borderRadius! : 50),
          color: bgColor == null ? BasicColors.primaryColor : bgColor,
        ),
        margin: margin == null ? EdgeInsets.symmetric() : margin,
        padding: padding ?? EdgeInsets.symmetric(vertical: 4.sp, horizontal: 6.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading == null ?
            SizedBox.shrink() : leading!,
            title ?? title!,
          ],
        ),
      ),
    );
  }
}
