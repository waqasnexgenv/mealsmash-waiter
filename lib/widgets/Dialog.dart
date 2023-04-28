import 'package:flutter/material.dart';
import 'package:hungerz_ordering/helper/colors.dart';

class CustomDialog extends StatelessWidget {
  final Widget? title;
  final Function onTapYes;
  final Function onTapNo;
  final Widget? content;

  CustomDialog(
      {Key? key,
        this.title,
        required this.onTapYes,required this.onTapNo,required this.content,});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,

      actions: <Widget>[
        TextButton(
    onPressed: onTapYes(),

          child: const Text('No',style: TextStyle(
            color:Colors.green,
          ),),
        ),

        // widget.kitchenstatus=="Received"?
        TextButton(
          onPressed: onTapYes(),
          child: const Text('Yes', style: TextStyle(
            color:Colors.red,
          ),),
        )
        // :Container(),



      ],

    );
  }
}
