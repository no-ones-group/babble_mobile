import 'dart:io';

import 'package:get/get.dart';

class RootConstants {
  // UI constants
  bool get isMobileScreen => Get.size.width <= 500;

  static double get headerHeight => 60;

  static double get footerHeight => 70;

  double get sidebarWidth => 70;

  double get extendedSidebarWidth =>
      isPlatformMobile ? Get.size.width - sidebarWidth : 300;
  static bool get isPlatformMobile => Platform.isAndroid || Platform.isIOS;

  static bool get spaceVisible => !isPlatformMobile;

  double get spaceWidth => Get.size.width - sidebarWidth - extendedSidebarWidth;
}

mixin CollectionFields {
  String get Spaces => 'spaces';
  String get Users => 'users';
}
