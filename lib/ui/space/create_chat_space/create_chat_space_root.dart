import 'dart:convert';

import 'package:babble_mobile/api/message_space_api.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/shrinking_tile.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateChatSpaceRoot extends StatelessWidget {
  final User user;
  final _textEditingController = TextEditingController();
  final _rootController = Get.find<RootController>();
  CreateChatSpaceRoot(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.25;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(),
        ),
        leading: IconButton(
          onPressed: () {
            _rootController.extendedMenuVisible.value =
                !_rootController.extendedMenuVisible.value;
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _textEditingController.text =
              '${_rootController.user.displayName}-${user.displayName}';
          Navigator.push(
            context,
            DialogRoute(
              context: context,
              builder: (context) => Dialog(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_a_photo),
                      ),
                      TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: 'Space Name',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Space space = Space(
                            spaceName: _textEditingController.text,
                            createdBy:
                                _rootController.user.userDocumentReference,
                            createdTime: Timestamp.now(),
                            shouldAddUser: true,
                            admins: [
                              _rootController.user.userDocumentReference
                            ],
                            users: [
                              _rootController.user.userDocumentReference,
                              user.userDocumentReference
                            ],
                            spacePic: '',
                          );
                          MessageSpaceAPI().createSpace(space);
                          Navigator.pop(context);
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                radius: radius <= 195 ? radius : 195,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Full Name'), Text(user.fullName)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Display Name'), Text(user.displayName)],
              ),
            ),
            const SizedBox(
              child: Text('Common chats'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: user.spaces.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: user.spaces[index].get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: snapshot.data!.get('spacePic') == ''
                                ? const SizedBox()
                                : Image.memory(base64
                                    .decode(snapshot.data!.get('spacePic'))),
                          ),
                          title: Text(snapshot.data!.get(Space.spaceNameField)),
                        );
                      }
                      return const SizedBox(
                        child: Text('You do not have any chats in common'),
                      );
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
