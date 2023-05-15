import 'dart:convert';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/constants/space_root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/custom_rect_tween.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/hero_dialog_route.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/message_conntroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

class Message extends StatelessWidget {
  final MessageModel messageModel;
  final Color _color = Colors.red;
  final messageController = Get.find<MessageController>();
  final RootController _rootController = Get.find<RootController>();
  Message({
    super.key,
    required this.messageModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isLoggedInUser = messageModel.by.id == _rootController.user.id;
    return Align(
      alignment: isLoggedInUser ? Alignment.topRight : Alignment.topLeft,
      child: Obx(
        () => Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            // minWidth: MediaQuery.of(context).size.width * 0.4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: messageController.isReplying.value &&
                    messageController.isReplyingTo.value == messageModel.id
                ? _color
                : isLoggedInUser
                    ? const Color.fromRGBO(19, 196, 163, 1)
                    : const Color.fromRGBO(76, 96, 133, 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: messageModel.by.get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Text(
                          snapshot.data!.get(User.displayNameField),
                          style: GoogleFonts.poppins(),
                        );
                      }
                      return Text(
                        'loading...',
                        style: GoogleFonts.poppins(),
                      );
                    },
                  ),
                  PopupMenuButton(
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
                      ];
                    },
                  ),
                ],
              ),
              messageModel.replyingTo != null
                  ? ReplyingTo(messageModel.replyingTo!)
                  : const SizedBox(),
              Content(
                messageType: messageModel.messageType,
                content: messageModel.content,
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
    );
  }
}

class ReplyingTo extends StatelessWidget {
  final DocumentReference message;
  const ReplyingTo(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(8)),
      child: FutureBuilder(
        future: message.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            String text = snapshot.data!.get('messageType') == 'text'
                ? snapshot.data!.get('content')
                : '${snapshot.data!.get('messageType')}';
            return Text(text);
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
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1,
                ),
              ),
            ),
          ));
        } else {
          spans.add(TextSpan(
            text: '$e ',
            style: const TextStyle(
              overflow: TextOverflow.clip,
            ),
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        ));
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
                      child: Image.memory(
                        base64.decode(content),
                      ),
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
                      child: Placeholder(),
                    )
                  : const SizedBox(
                      child: Text('Un-Identified MessageType'),
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
