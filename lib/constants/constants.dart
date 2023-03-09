import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Current Date
String currentDate = DateFormat.yMMMd().format(DateTime.now());

//Colors
const Color bgColor = Color(0xff363637);
final Color shadowColor = Color(0xFFAFAFAF).withOpacity(0.2);
final Color greenColor = Colors.green.shade700;
const Color deepBrown = Color(0xff5C4033);
const Color indigoColor = Colors.indigo;
const Color blackColor = Colors.black;
const Color blueColor = Colors.blue;
const Color whiteColor = Colors.white;
const Color greyColor = Colors.grey;
const Color redColor = Colors.red;
const Color amberColor = Colors.amber;
Color lightGreyColor = Colors.grey.shade300;

//Vertical Space
const verticalSpace = SizedBox(
  height: 15,
);
const verticalSpaceSmall = SizedBox(
  height: 15,
);

const horizontalSpace = SizedBox(
  width: 10,
);

const LoadingIndicatorWhite = CircularProgressIndicator(color: whiteColor,);

enum Selected { flat, room, seat }

enum Booking { confirm, pending, cancel }
