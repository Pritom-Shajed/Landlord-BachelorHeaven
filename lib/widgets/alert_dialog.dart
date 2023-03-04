import 'package:flutter/material.dart';

alertDialog({required BuildContext context,required String title, required VoidCallback onTapYes, required VoidCallback onTapNo}){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      alignment: Alignment.center,
      title: Text(title),
      actions: [
        TextButton(onPressed: onTapYes, child: Text('Yes')),
        TextButton(onPressed: onTapNo, child: Text('No')),
      ],
    );
  });

}