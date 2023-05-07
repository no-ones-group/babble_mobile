import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RootController extends GetxController {
  var pageTitle = ''.obs;
  String loggedInUserPhoneNumber = '1';
  var userPersistentValues = GetStorage('user');
  Widget pageContent = const SizedBox(
    child: Center(
      child: Text('Welcome to Babble Land!'),
    ),
  );
  var user = User.defaultV1();
  late DocumentReference userDoc;

  void setPage(Widget page, String title) {
    pageTitle.value = title;
    pageContent = page;
  }

  bool isUserLoggedIn() {
    return userPersistentValues.read<String>('id') != null &&
        userPersistentValues.read<String>('id')!.isNotEmpty;
  }

  @override
  void onInit() async {
    if (isUserLoggedIn()) {
      loggedInUserPhoneNumber = userPersistentValues.read<String>('id')!;
    }
    userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUserPhoneNumber);
    user = await UserAPI().getUser(loggedInUserPhoneNumber);
    super.onInit();
  }
}
