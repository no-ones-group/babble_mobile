// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/new_ui/space/space_profile_space.dart';
import 'package:babble_mobile/new_ui/space/user_space.dart';
import 'package:babble_mobile/new_ui/space/widgets/message.dart';
import 'package:babble_mobile/new_ui/space/widgets/space_profile_picture.dart';
import 'package:babble_mobile/new_ui/space/widgets/utils/message_controller.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ChatSpace extends StatelessWidget {
  final Space space;
  final _rootController = Get.find<RootController>();
  final _messageController = Get.put<MessageController>(MessageController());
  final _textEditingController = TextEditingController();
  ChatSpace(this.space, {super.key});

  List<PopupMenuItem> populateMenuItems(BuildContext context) {
    List<PopupMenuItem> items = [];
    if (space.spaceName != '') {
      items.add(PopupMenuItem(
        child: const Text('Add user'),
        onTap: () => Future(
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => UserSpace(true, null, space)),
          ),
        ),
      ));
    }

    return items;
  }

  Future sendMessage(MessageType type) async {
    DocumentReference? replyingToRef;
    String id = const Uuid().v1();
    final encrypter =
        encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(space.key)));
    final iv = encrypt.IV.fromBase64(space.iv);
    if (_messageController.isReplying.isTrue) {
      replyingToRef = space.messagesCollection
          .doc('/${_messageController.isReplyingTo.value}');
    }
    await space.messagesCollection.doc(id).set({
      MessageModel.byField: _rootController.user.userDocumentReference,
      MessageModel.chatSpaceField: space.spaceDocumentReference,
      MessageModel.contentField:
          encrypter.encrypt(_textEditingController.text, iv: iv).base64,
      MessageModel.idField: id,
      MessageModel.messageTypeField: type.name,
      MessageModel.replyingToField: replyingToRef,
      MessageModel.sentTimeField: Timestamp.now(),
    });
    _textEditingController.text = '';
    _messageController.isReplyingTo.value = '';
    _messageController.isReplying.value = false;
  }

  void uploadFile(BuildContext context, File file, MessageType type) {
    Navigator.of(context).push(DialogRoute(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                children: [
                  Image.file(file),
                  ElevatedButton(
                      onPressed: () async {
                        _textEditingController.text =
                            base64.encode(await file.readAsBytes());
                        await sendMessage(type);
                      },
                      child: Text(
                        'Send',
                        style: RootConstants.textStyleSubHeader,
                      ))
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => populateMenuItems(context),
          ),
        ],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpaceProfilePic(space: space),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    space.spaceName == ''
                        ? (_rootController.user.displayName ==
                                space.displayName1
                            ? space.displayName2
                            : space.displayName1)
                        : space.spaceName,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            _rootController.user.isOnline
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        'Online',
                        style: RootConstants.textStyleContent,
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Flexible(
              child: Container(
                width: kIsWeb
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.width,
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
                                      snapshot.data!.docs[index].data()),
                                  space: space,
                                );
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
                            onPressed: () async =>
                                sendMessage(MessageType.text),
                          ),
                        ),
                        prefix: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                          child: Row(
                            children: [
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Image'),
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(type: FileType.image);

                                      if (result != null &&
                                          result.files.isNotEmpty) {
                                        File file =
                                            File(result.files.single.path!);
                                        uploadFile(
                                            context, file, MessageType.image);
                                      }
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Audio'),
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(type: FileType.audio);

                                      if (result != null &&
                                          result.files.isNotEmpty) {
                                        File file =
                                            File(result.files.single.path!);
                                        uploadFile(
                                            context, file, MessageType.audio);
                                      }
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Video'),
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(type: FileType.video);

                                      if (result != null &&
                                          result.files.isNotEmpty) {
                                        File file =
                                            File(result.files.single.path!);
                                        uploadFile(
                                            context, file, MessageType.video);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Obx(
                                () => _messageController.isReplying.isTrue
                                    ? TextButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.white10,
                                          ),
                                        ),
                                        onPressed: () => _messageController
                                            .isReplying.value = false,
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
                        onSubmitted: (value) async =>
                            sendMessage(MessageType.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            kIsWeb ? SpaceProfileSpace(space) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
