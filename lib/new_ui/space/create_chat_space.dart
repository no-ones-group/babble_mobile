import 'package:babble_mobile/api/message_space_api.dart';
import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class CreateChatSpace extends StatelessWidget {
  final User user;
  final _rootController = Get.find<RootController>();
  final _textEditingController = TextEditingController();
  CreateChatSpace({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: CupertinoTextField(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              style: const TextStyle(
                fontSize: 22,
                color: Color.fromARGB(255, 255, 184, 78),
              ),
              controller: _textEditingController,
              cursorColor: const Color.fromARGB(255, 73, 218, 238),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 184, 78),
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              onSubmitted: (value) {},
            ),
          ),
          TextButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              encrypt.Key key = encrypt.Key.fromSecureRandom(32);
              encrypt.IV iv = encrypt.IV.fromSecureRandom(16);
              Space space = Space(
                key: key.base64,
                iv: iv.base64,
                spaceName: _textEditingController.text,
                createdBy: _rootController.user.userDocumentReference,
                createdTime: Timestamp.now(),
                shouldAddUser: true,
                admins: [_rootController.user.userDocumentReference],
                users: [
                  _rootController.user.userDocumentReference,
                  user.userDocumentReference
                ],
                spacePic: '',
              );
              await MessageSpaceAPI().createSpace(space);
              await _rootController.refreshUserData();
              nav.pop();
            },
            child: Text(
              'Create',
              style: RootConstants.textStyleSubHeader,
            ),
          ),
        ],
      ),
    );
  }
}
