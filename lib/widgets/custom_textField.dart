import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:flutter/material.dart';

Widget customTextField({required TextEditingController controller,
  required String hintText,
  required IconData icon,
  IconData? suffixIcon,
  VoidCallback? suffixIconTap,
  int? maxLines,
  bool obscureText = false,
  TextInputType inputType = TextInputType.text}) {
  return Card(
    elevation: 1,
    child: TextField(
      maxLines: maxLines,
      keyboardType: inputType,
      obscureText: obscureText,
      cursorColor: blackColor,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: InkWell(onTap: suffixIconTap, child: Icon(suffixIcon, color: greyColor,)),
        hintText: hintText,
        prefixIcon: Icon(icon),
        prefixIconColor: blackColor,
        border: InputBorder.none,
      ),
    ),
  );
}