import 'dart:convert';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/constants/space_root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/custom_rect_tween.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/hero_dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class Message extends StatelessWidget {
  final MessageModel messageModel;
  final RootController _rootController = Get.find<RootController>();
  Message({
    super.key,
    required this.messageModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isLoggedInUser = messageModel.by.id == _rootController.user.id;
    return Align(
      alignment: isLoggedInUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width -
                  RootConstants().extendedSidebarWidth -
                  RootConstants().sidebarWidth) *
              0.7,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isLoggedInUser
              ? const Color.fromRGBO(233, 196, 106, 1)
              : const Color.fromRGBO(231, 111, 81, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
    );
  }
}

class Content extends StatelessWidget {
  final MessageType messageType;
  final String content;
  final Color color = Colors.white12;
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
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
                      height: 200,
                      width: 250,
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
