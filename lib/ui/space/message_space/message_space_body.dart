import 'dart:developer';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_footer.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSpaceBody extends StatelessWidget {
  final _rootController = Get.find<RootController>();
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  final _scrollController = ScrollController();
  MessageSpaceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _rootController.extendedMenuVisible.value =
                  !_rootController.extendedMenuVisible.value;
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
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
              MessageSpaceFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
