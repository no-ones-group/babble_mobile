import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ExtendedSidebarController extends GetxController {
  RxString hoveredId = ('-1').obs;
  var selectedUser = (User(id: '', fullName: '', displayName: '')).obs;
  var selectedChat = Space.defaultV1().obs;
  RxInt selectedSidebarItemId = 0.obs;
  List titles = ['Chats', 'Users', 'Settings', 'Profile'];
  RootController rootController = Get.find<RootController>();
  @override
  void onInit() {
    super.onInit();
  }
}
