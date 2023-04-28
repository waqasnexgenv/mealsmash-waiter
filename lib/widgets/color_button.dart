import 'package:flutter/material.dart';
import 'package:hungerz_ordering/helper/colors.dart';

class ColorButton extends StatelessWidget {
  final String title;

  ColorButton(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        color: BasicColors.primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
          child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18),
      )),
    );
  }
}
