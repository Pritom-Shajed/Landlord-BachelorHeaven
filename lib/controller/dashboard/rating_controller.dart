import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingController extends GetxController{
  RxInt rating = 0.obs;
  Widget ratingTotal({required Color textColor, required double iconSize, required double textSize}){
    int i = 0;
    return Row(
      children: [
        for(i; i < rating.value; i++)
          Icon(
            Icons.star,
            color: amberColor,
            size: iconSize,
          ),
        Text(
          i.toString(),
          style: poppinsTextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              size: textSize),
        ),
      ],
    );
  }

  void ratingChange({required int ratingActual}){
    rating.value = ratingActual;
  }
}
