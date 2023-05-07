import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/contact_tile/tiles.dart';
import 'package:babble_mobile/ui/extended_sidebar/user_sidebar/user_sidebar_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSidebarRoot extends StatelessWidget {
  final UserSidebarController _userSidebarController =
      Get.put(UserSidebarController());
  UserSidebarRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _userSidebarController.data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Tiles(
                  user: User(
                    id: snapshot.data?.docs[index].get(User.idField) ?? '',
                    displayName:
                        snapshot.data?.docs[index].get(User.displayNameField) ??
                            '',
                    fullName:
                        snapshot.data?.docs[index].get(User.fullNameField) ??
                            '',
                    profilePicLink: snapshot.data?.docs[index]
                            .get(User.profilePicLinkField) ??
                        '',
                  ),
                );
              },
              itemCount: snapshot.data?.docs.length,
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
