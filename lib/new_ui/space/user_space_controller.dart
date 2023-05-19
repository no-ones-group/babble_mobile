import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class UserSpaceController extends GetxController {
  var selectedChat = (-1).obs;
  var rootController = Get.find<RootController>();
  var data = FirebaseFirestore.instance.collection('users').snapshots();
  late User user;
  late List<Space> spaces;
  late List<Contact> contacts;

  @override
  void onInit() async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }
    user = await UserAPI().getUser(rootController.loggedInUserPhoneNumber);
    super.onInit();
  }
}
