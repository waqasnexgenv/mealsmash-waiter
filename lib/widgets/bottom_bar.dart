import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomBar extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color? color;
  final Color? textColor;

  BottomBar(
      {required this.onTap, required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        child: Center(
          child: Text(text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 26.0.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  )),
        ),
        color: color ?? Theme.of(context).primaryColor,
        height: 70.0.h,
      ),
    );
  }
}
