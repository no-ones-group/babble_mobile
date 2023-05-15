import 'dart:convert';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/new_ui/space/chat_space.dart';
import 'package:babble_mobile/new_ui/space/user_space.dart';
import 'package:babble_mobile/new_ui/space/widgets/logo.dart';
import 'package:babble_mobile/new_ui/space/widgets/space_profile_picture.dart';
import 'package:babble_mobile/new_ui/space/widgets/user_profile_pic.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends StatelessWidget {
  final RootController _rootController = Get.find();
  Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Logo(
          withName: true,
          size: LogoSize.medium,
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem(child: Text('Coming Soon')),
            ];
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const UserSpace()));
        },
        child: const Icon(Icons.chat),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Stories',
                style: RootConstants.textStyleSubHeader,
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.blue,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Chats',
                style: RootConstants.textStyleSubHeader,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _rootController.user.spaces.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: _rootController.user.spaces[index].get(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.hasData) {
                        Space space =
                            Space.fromDocumentSnapshotObject(snapshot.data!);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: ((context) => ChatSpace(space)))),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            tileColor: Colors.black12,
                            leading: SpaceProfilePic(
                              space: space,
                            ),
                            title: Text(
                              space.spaceName == ''
                                  ? (_rootController.user.displayName ==
                                          space.displayName1
                                      ? space.displayName2
                                      : space.displayName1)
                                  : space.spaceName,
                              style: RootConstants.textStyleContent,
                            ),
                            trailing: Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('1'),
                              ),
                            ),
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
