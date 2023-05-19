import 'dart:convert';
import 'dart:io';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/new_ui/space/widgets/utils/custom_rect_tween.dart';
import 'package:babble_mobile/new_ui/space/widgets/utils/hero_dialog_route.dart';
import 'package:babble_mobile/new_ui/space/widgets/utils/message_controller.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class Message extends StatelessWidget {
  final MessageModel messageModel;
  final Space space;
  final messageController = Get.find<MessageController>();
  final RootController _rootController = Get.find<RootController>();
  late final String decryptedContent;

  TextStyle get messageHeader => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  Message({
    super.key,
    required this.messageModel,
    required this.space,
  }) {
    encrypt.Key key = encrypt.Key.fromBase64(space.key);
    encrypt.IV iv = encrypt.IV.fromBase64(space.iv);
    encrypt.Encrypter decrypter = encrypt.Encrypter(encrypt.AES(key));
    decryptedContent = decrypter.decrypt64(messageModel.content, iv: iv);
  }

  Future deleteMessage() async {
    await space.messagesCollection.doc(messageModel.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedInUser = messageModel.by.id == _rootController.user.id;
    return Flexible(
      child: Align(
        alignment: isLoggedInUser ? Alignment.topRight : Alignment.topLeft,
        child: Obx(
          () => Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxWidth: kIsWeb
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.width * 0.7,
              // minWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: messageController.isReplying.value &&
                      messageController.isReplyingTo.value == messageModel.id
                  ? Colors.red
                  : isLoggedInUser
                      ? RootConstants.userMessageColor
                      : RootConstants.notUserMessageColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: messageModel.by.get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Text(
                            snapshot.data!.get(User.displayNameField),
                            style: messageHeader,
                          );
                        }
                        return Text(
                          'loading...',
                          style: messageHeader,
                        );
                      },
                    ),
                    PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: const Text('Reply'),
                            onTap: () {
                              messageController.isReplying.value = true;
                              messageController.isReplyingTo.value =
                                  messageModel.id;
                            },
                          ),
                          PopupMenuItem(
                            child: const Text('Delete'),
                            onTap: () async {
                              await deleteMessage();
                            },
                          ),
                        ];
                      },
                      child: const Icon(Icons.settings),
                    ),
                  ],
                ),
                messageModel.replyingTo != null
                    ? ReplyingTo(messageModel.replyingTo!, space)
                    : const SizedBox(),
                Align(
                  alignment: isLoggedInUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Content(
                    messageType: messageModel.messageType,
                    content: decryptedContent,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        '${messageModel.sentTime.toDate().hour}:${messageModel.sentTime.toDate().minute} ${messageModel.sentTime.toDate().hour < 12 ? 'AM' : 'PM'}'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReplyingTo extends StatelessWidget {
  final DocumentReference message;
  final Space space;
  const ReplyingTo(this.message, this.space, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(8)),
      child: FutureBuilder<DocumentSnapshot<Object?>>(
        future: message.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            MessageModel replyModel =
                MessageModel.fromDocumentSnapshot(snapshot.data);
            encrypt.Key key = encrypt.Key.fromBase64(space.key);
            encrypt.IV iv = encrypt.IV.fromBase64(space.iv);
            encrypt.Encrypter decrypter = encrypt.Encrypter(encrypt.AES(key));
            String decryptedContent =
                decrypter.decrypt64(replyModel.content, iv: iv);
            return Content(
              messageType: replyModel.messageType,
              content: decryptedContent,
            );
          }
          return const Text('Message was deleted');
        },
      ),
    );
  }
}

class Content extends StatelessWidget {
  final MessageType messageType;
  final String content;
  final List<InlineSpan> spans = [];
  late final File file;

  TextStyle get messageContent => GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
      );

  Future<void> prepareContent() async {
    if (messageType != MessageType.text) {
      file = File("cache_file.cache");
      file = await file.writeAsBytes(base64.decode(content));
    }
  }

  Content({super.key, required this.messageType, required this.content}) {
    if (messageType == MessageType.text) {
      content.toString().split(' ').forEach((e) {
        if (Uri.parse(e).isAbsolute || e.contains('.')) {
          spans.add(WidgetSpan(
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () async {
                if (e.contains('.')) {
                  await launchUrl(Uri.parse('https://$e'));
                } else {
                  await launchUrl(Uri.parse(e));
                }
              },
              child: Text(
                '$e ',
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1,
                ),
              ),
            ),
          ));
        } else {
          spans.add(TextSpan(
            text: '$e ',
            style: messageContent,
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    prepareContent();
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: messageType == MessageType.text
            ? RichText(
                text: TextSpan(
                  children: spans,
                ),
              )
            : messageType == MessageType.image
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        HeroDialogRoute(
                          builder: (context) => ContentDetails(
                            content: content,
                            messageType: MessageType.image,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: MessageType.image,
                      createRectTween: (begin, end) {
                        return CustomRectTween(begin: begin!, end: end!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.memory(base64.decode(content)),
                      ),
                    ),
                  )
                : messageType == MessageType.video
                    ? Container(
                        height: 200,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: VideoPlayer(
                          VideoPlayerController.file(file),
                        ),
                      )
                    : const SizedBox(
                        child: Text('Un-Identified MessageType'),
                      ),
      ),
    );
  }
}

class ContentDetails extends StatelessWidget {
  final String content;
  final MessageType messageType;
  const ContentDetails(
      {super.key, required this.content, required this.messageType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: MessageType.image,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                  child: Image.memory(
                    base64.decode(content),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
