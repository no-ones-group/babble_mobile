// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/new_ui/space/widgets/message.dart';
import 'package:babble_mobile/new_ui/space/widgets/profile_pic.dart';
import 'package:babble_mobile/new_ui/space/widgets/user_profile_pic.dart';
import 'package:babble_mobile/new_ui/space/widgets/space_profile_picture.dart';
import 'package:babble_mobile/new_ui/space/widgets/utils/message_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class ChatSpace extends StatelessWidget {
  final Space space;
  final _rootController = Get.find<RootController>();
  final _messageController = Get.put<MessageController>(MessageController());
  final _textEditingController = TextEditingController();
  ChatSpace(this.space, {super.key});

  Future sendMessage(MessageType type) async {
    DocumentReference? replyingToRef;
    String id = const Uuid().v1();
    if (_messageController.isReplying.isTrue) {
      replyingToRef = space.messagesCollection
          .doc('/${_messageController.isReplyingTo.value}');
    }
    await space.messagesCollection.doc(id).set({
      MessageModel.byField: _rootController.user.userDocumentReference,
      MessageModel.chatSpaceField: space.spaceDocumentReference,
      MessageModel.contentField: _textEditingController.text,
      MessageModel.idField: id,
      MessageModel.messageTypeField: type.name,
      MessageModel.replyingToField: replyingToRef,
      MessageModel.sentTimeField: Timestamp.now(),
    });
    _textEditingController.text = '';
    _messageController.isReplyingTo.value = '';
    _messageController.isReplying.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SpaceProfilePic(space: space),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                space.spaceName == ''
                    ? (_rootController.user.displayName == space.displayName1
                        ? space.displayName2
                        : space.displayName1)
                    : space.spaceName,
                style: RootConstants.textStyleSubHeader,
                maxLines: 1,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('spaces')
                    .doc(space.uuid)
                    .collection('messages')
                    .orderBy('sentTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Message(
                            messageModel: MessageModel.fromObject(
                                snapshot.data!.docs[index].data()));
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: CupertinoTextField(
                suffix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.small(
                    heroTag: null,
                    child: const Icon(Icons.send),
                    onPressed: () async => sendMessage(MessageType.text),
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
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);

                          if (result != null && result.files.isNotEmpty) {
                            File file = File(result.files.single.path!);
                            Navigator.of(context).push(DialogRoute(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Column(
                                        children: [
                                          Image.file(file),
                                          ElevatedButton(
                                              onPressed: () async {
                                                _textEditingController.text =
                                                    base64.encode(await file
                                                        .readAsBytes());
                                                sendMessage(MessageType.image);
                                              },
                                              child: Text(
                                                'Send',
                                                style: RootConstants
                                                    .textStyleSubHeader,
                                              ))
                                        ],
                                      ),
                                    )));
                          }
                        },
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
                onSubmitted: (value) async => sendMessage(MessageType.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}