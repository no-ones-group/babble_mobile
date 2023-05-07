import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSpaceBody extends StatelessWidget {
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  final _scrollController = ScrollController();
  MessageSpaceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        height: MediaQuery.of(context).size.height -
            RootConstants.headerHeight -
            RootConstants.footerHeight,
        width: MediaQuery.of(context).size.width - RootConstants().sidebarWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('spaces')
              .doc(_extendedSidebarController.selectedChat.value.uuid)
              .collection('messages')
              .orderBy('sentTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                controller: _scrollController,
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
    );
  }
}
