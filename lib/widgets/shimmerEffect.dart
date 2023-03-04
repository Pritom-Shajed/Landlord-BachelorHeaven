import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:flutter/material.dart';

Widget ShimmerEffect({required double height, required double width}) {
  return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: blackColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16)));
}