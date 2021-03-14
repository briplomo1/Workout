import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

final buttonsText = GoogleFonts.ptSansCaption(
  fontSize: 20.0,
  color: Colors.white,
);

TextStyle menuText(Color color, double fontSize) {
  return GoogleFonts.ptSansCaption(
    fontSize: fontSize,
    color: color,
    letterSpacing: 1.0,
  );
}
