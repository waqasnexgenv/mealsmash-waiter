import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungerz_ordering/helper/colors.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscure;
  final bool readOnly;
  final bool enabled;
  final InputBorder? border;
  final bool backgroundColorGet;

  EntryField({
    this.hint = "",
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.enabled = false,
    this.readOnly = false,
    this.obscure = false,
    this.border,
    this.controller,
    this.backgroundColorGet = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscure,
      cursorColor: BasicColors.primaryColor,
      keyboardType: keyboardType,
      // style: TextStyle(color: BasicColors.blueGrey),

      style:
          TextStyle(color: BasicColors.getBlackWhiteColor(backgroundColorGet),fontSize: 18.sp),
      onChanged: onChanged,
      decoration: InputDecoration(
          enabledBorder: border ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: BasicColors.primaryColor),
              ),
          disabledBorder: border ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: BasicColors.primaryColor),
              ),
          focusedBorder: border ??
              UnderlineInputBorder(
                borderSide: BorderSide(color: BasicColors.primaryColor),
              ),
          // labelText: 'Password',
          hintText: hint,
          errorText: errorText,
          hintStyle:
              TextStyle(color: BasicColors.secondaryColor, fontSize: 18.sp)),
    );
  }
}
