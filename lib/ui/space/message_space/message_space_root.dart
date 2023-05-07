import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/constants/space_root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_body.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MessageSpaceRoot extends StatelessWidget {
  final _rootController = Get.find<RootController>();
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  MessageSpaceRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: RootConstants().spaceWidth,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() =>
              Text(_extendedSidebarController.selectedChat.value.spaceName)),
          backgroundColor: SpaceRootConstants().headerColor,
          toolbarHeight: RootConstants.headerHeight,
          elevation: 0,
        ),
        body: Container(
          color: SpaceRootConstants().containerColor,
          child: Column(
            children: [
              MessageSpaceBody(),
              MessageSpaceFooter(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            var uuid = const Uuid().v4();
            _extendedSidebarController.selectedChat.value.messagesCollection
                .add({
              MessageModel.byField:
                  FirebaseFirestore.instance.doc('${User.usersCollection}/2'),
              MessageModel.chatSpaceField: _extendedSidebarController
                  .selectedChat.value.spaceDocumentReference,
              MessageModel.contentField: uuid,
              MessageModel.idField: uuid,
              MessageModel.messageTypeField: MessageType.text.name,
              MessageModel.replyingToField: null,
              MessageModel.sentTimeField: Timestamp.now(),
            });
          },
          isExtended: true,
          mini: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
