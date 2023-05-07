import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/constants/space_root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MessageSpaceFooter extends StatelessWidget {
  final _rootController = Get.find<RootController>();
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  final _textEditingController = TextEditingController();
  MessageSpaceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RootConstants.footerHeight,
      width: MediaQuery.of(context).size.width - RootConstants().sidebarWidth,
      color: SpaceRootConstants().containerColor,
      // color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CupertinoTextField(
              suffix: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.small(
                  heroTag: null,
                  child: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
              prefix: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_box_outlined,
                    color: Color.fromARGB(255, 255, 184, 78),
                  ),
                  onPressed: () {},
                ),
              ),
              padding: const EdgeInsets.all(0),
              style: const TextStyle(
                fontSize: 22,
                color: Color.fromARGB(255, 255, 184, 78),
              ),
              controller: _textEditingController,
              cursorColor: const Color.fromARGB(255, 73, 218, 238),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 184, 78),
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              onSubmitted: (value) {
                _extendedSidebarController.selectedChat.value.messagesCollection
                    .add({
                  MessageModel.byField:
                      _rootController.user.userDocumentReference,
                  MessageModel.chatSpaceField: _extendedSidebarController
                      .selectedChat.value.spaceDocumentReference,
                  MessageModel.contentField: _textEditingController.text,
                  MessageModel.idField: const Uuid().v1(),
                  MessageModel.messageTypeField: MessageType.text.name,
                  MessageModel.replyingToField: null,
                  MessageModel.sentTimeField: Timestamp.now(),
                });
                _textEditingController.text = '';
              },
            ),
          ),
        ],
      ),
    );
  }
}
