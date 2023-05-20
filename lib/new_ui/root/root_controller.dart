import 'dart:developer';

import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootController extends GetxController {
  String loggedInUserPhoneNumber = '1';
  var extendedMenuVisible = true.obs;
  var pref = SharedPreferences.getInstance();
  Widget pageContent = const SizedBox(
    child: Center(
      child: Text('Welcome to Babble Land!'),
    ),
  );
  var user = User.defaultV1();
  late DocumentReference userDoc;

  void setPage(Widget page, String title) {
    pageContent = page;
    update();
  }

  Future refreshUserData() async {
    userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUserPhoneNumber);
    user = await UserAPI().getUser(loggedInUserPhoneNumber);
  }

  Future onlineToggle(bool toggleValue) async {
    await refreshUserData();
    await userDoc.update({
      'isOnline': toggleValue,
    });
  }

  @override
  void onInit() async {
    var pref = await SharedPreferences.getInstance();
    if (pref.containsKey('user_id')) {
      loggedInUserPhoneNumber = pref.getString('user_id')!;
      log(pref.getString('user_id')!);
    }
    await onlineToggle(true);
    super.onInit();
  }

  @override
  void onClose() async {
    await onlineToggle(false);
    super.onClose();
  }
}
