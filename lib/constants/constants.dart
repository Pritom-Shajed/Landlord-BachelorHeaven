import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Current Date
String currentDate = DateFormat.yMMMd().format(DateTime.now());

//Colors
const Color bgColor = Color(0xff363637);
const Color greenColor = Color(0xff107869);
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

enum Selected { flat, room, seat }
