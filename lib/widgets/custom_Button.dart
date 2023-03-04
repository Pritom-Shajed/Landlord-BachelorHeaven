import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:flutter/material.dart';

Widget customButton({required String text,
  required VoidCallback onTap,
  double width = double.maxFinite,
  Alignment alignment = Alignment.center,
  Color color = bgColor}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: alignment,
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 1,
          color: Colors.black45,
        )
      ], color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: poppinsTextStyle(color: whiteColor, fontWeight: FontWeight.w500),
      ),
    ),
  );
}