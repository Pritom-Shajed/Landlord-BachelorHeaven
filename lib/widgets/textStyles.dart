import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle poppinsTextStyle({
  Color? color,
  double? size,
  FontWeight? fontWeight,
  double? letterSpacing,
}) =>
    GoogleFonts.poppins(
        textStyle: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
        ));

TextStyle satisfyTextStyle({
  Color? color,
  double? size,
  FontWeight? fontWeight,
  double? letterSpacing,
}) =>
    GoogleFonts.greatVibes(
        textStyle: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
        ));