import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/chat_sidebar/chat_sidebar_controller.dart';
import 'package:babble_mobile/ui/extended_sidebar/contact_tile/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSidebarRoot extends StatelessWidget with CollectionFields {
  final _chatSidebarController =
      Get.put<ChatSidebarController>(ChatSidebarController());
  ChatSidebarRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Users)
            .doc(_chatSidebarController.rootController.loggedInUserPhoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.active) {
            List<DocumentReference> docRefs =
                (snapshot.data!.get(User.spacesField) as List)
                    .map((item) => item as DocumentReference)
                    .toList();
            return ListView.builder(
              itemCount: docRefs.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: docRefs[index].get(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Chats(
                          space:
                              Space.fromDocumentSnapshotObject(snapshot.data!));
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
