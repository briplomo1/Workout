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

BoxDecoration getFormBoxDecor(BuildContext context) => BoxDecoration(
    gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 34, 34, 34),
          Color.fromARGB(255, 54, 54, 54),
          Color.fromARGB(255, 54, 54, 54),
          Color.fromARGB(255, 34, 34, 34),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, .3, .4, 1.0]),
    color: Color.fromARGB(255, 54, 54, 54),
    border: Border.all(color: Colors.transparent, width: 3.0),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.grey[500]!,
        offset: const Offset(0, -4),
        blurRadius: 8.0,
      ),
      BoxShadow(
        color: Color.fromARGB(255, 0, 0, 0),
        offset: const Offset(7.0, 12.0),
        blurRadius: 8.0,
      ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(20.0)));

InputDecoration getFieldDecoration(String text, BuildContext context) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(
      color: Colors.grey[400],
      fontSize: 15.0,
      letterSpacing: 1.0,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.grey[700],
    ),
    enabledBorder: OutlineInputBorder(
      //borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
  );
}

InputDecoration getNumberFieldDecoration(String text, BuildContext context) {
  return InputDecoration(
    fillColor: Colors.grey[700],
    filled: true,
    labelText: text,
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.transparent,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
  );
}

TextStyle getFormTextStyle() => TextStyle(color: Colors.white);
