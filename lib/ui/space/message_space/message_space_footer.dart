import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/constants/space_root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/message_conntroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class MessageSpaceFooter extends StatelessWidget {
  final _rootController = Get.find<RootController>();
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  final _textEditingController = TextEditingController();
  final _messageController = Get.find<MessageController>();
  MessageSpaceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: RootConstants.footerHeight,
      width: MediaQuery.of(context).size.width -
          (RootConstants.isPlatformMobile ? 0 : RootConstants().sidebarWidth),
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
                padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.add_box_outlined,
                        color: Color.fromARGB(255, 255, 184, 78),
                      ),
                      onTap: () {},
                    ),
                    Obx(
                      () => _messageController.isReplying.isTrue
                          ? TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white10,
                                ),
                              ),
                              onPressed: () =>
                                  _messageController.isReplying.value = false,
                              child: Row(
                                children: [
                                  Text(
                                    'Replying',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _messageController
                                        .isReplying.value = false,
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
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
                DocumentReference? replyingToRef;
                String id = const Uuid().v1();
                if (_messageController.isReplying.isTrue) {
                  replyingToRef = _extendedSidebarController
                      .selectedChat.value.messagesCollection
                      .doc('/${_messageController.isReplyingTo.value}');
                }
                _extendedSidebarController.selectedChat.value.messagesCollection
                    .doc(id)
                    .set({
                  MessageModel.byField:
                      _rootController.user.userDocumentReference,
                  MessageModel.chatSpaceField: _extendedSidebarController
                      .selectedChat.value.spaceDocumentReference,
                  MessageModel.contentField: _textEditingController.text,
                  MessageModel.idField: id,
                  MessageModel.messageTypeField: MessageType.text.name,
                  MessageModel.replyingToField: replyingToRef,
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
