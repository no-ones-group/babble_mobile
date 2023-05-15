import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RootConstants {
  // old
  static double get headerHeight => 60;

  static double get footerHeight => 70;

  double get sidebarWidth => 70;

  double get extendedSidebarWidth =>
      isPlatformMobile ? Get.size.width - sidebarWidth : 300;
  static bool get isPlatformMobile => !kIsWeb;

  static bool get spaceVisible => !isPlatformMobile;

  double get spaceWidth => Get.size.width - sidebarWidth - extendedSidebarWidth;

  // new
  static Color get userMessageColor => Colors.blue;

  static Color get notUserMessageColor => Colors.red;

  static TextStyle get textStyleHeader => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get textStyleSubHeader => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get textStyleContent => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      );
}

mixin CollectionFields {
  String get Spaces => 'spaces';
  String get Users => 'users';
}
