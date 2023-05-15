import 'dart:convert';

import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/contact_tile/tiles.dart';
import 'package:babble_mobile/ui/extended_sidebar/shrinking_tile.dart';
import 'package:babble_mobile/ui/extended_sidebar/user_sidebar/user_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/space/profile_space/profile_space_root.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSidebarRoot extends StatelessWidget {
  final UserSidebarController _userSidebarController =
      Get.find<UserSidebarController>();
  final _rootController = Get.find<RootController>();
  UserSidebarRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _userSidebarController.data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
            for (var contact in _userSidebarController.contacts) {
              for (var phone in contact.phones) {
                for (var doc in snapshot.data!.docs) {
                  if (doc.id == phone.number ||
                      doc.id == phone.normalizedNumber) {
                    docs.add(doc);
                  }
                }
              }
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                User user = User(
                    id: docs[index].get(User.idField) ?? '',
                    displayName: docs[index].get(User.displayNameField) ?? '',
                    fullName: docs[index].get(User.fullNameField) ?? '',
                    profilePicLink:
                        docs[index].get(User.profilePicLinkField) ?? '',
                    spaces: (docs[index].get(User.spacesField) as List)
                        .map((item) => item as DocumentReference)
                        .toList());
                return ShrinkingTile(user: user);
              },
              itemCount: docs.length,
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
