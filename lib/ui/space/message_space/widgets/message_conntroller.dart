import 'package:get/get.dart';

class MessageController extends GetxController {
  RxBool isReplying = false.obs;
  RxString isReplyingTo = ''.obs;
}
