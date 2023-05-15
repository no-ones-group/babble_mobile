import 'package:babble_mobile/api/message_space_api.dart';
import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/new_ui/space/chat_space.dart';
import 'package:babble_mobile/new_ui/space/create_chat_space.dart';
import 'package:babble_mobile/new_ui/space/widgets/user_profile_pic.dart';
import 'package:babble_mobile/ui/extended_sidebar/user_sidebar/user_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSpace extends StatefulWidget {
  const UserSpace({super.key});

  @override
  State<UserSpace> createState() => _UserSpaceState();
}

class _UserSpaceState extends State<UserSpace> {
  final _textEditingController = TextEditingController();
  final _userSidebarController = Get.find<UserSidebarController>();
  final _rootController = Get.find<RootController>();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
          style: RootConstants.textStyleHeader,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            CupertinoTextField(
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
              onChanged: (value) => setState(() {
                searchText = _textEditingController.text;
              }),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _userSidebarController.data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
                  for (var contact in _userSidebarController.contacts) {
                    for (var phone in contact.phones) {
                      for (var doc in snapshot.data!.docs) {
                        if ((doc.id == phone.number ||
                                doc.id == phone.normalizedNumber) &&
                            (doc.get(User.displayNameField) as String)
                                .contains(searchText)) {
                          docs.add(doc);
                        }
                      }
                    }
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        User user = User(
                            id: docs[index].get(User.idField) ?? '',
                            displayName:
                                docs[index].get(User.displayNameField) ?? '',
                            fullName: docs[index].get(User.fullNameField) ?? '',
                            profilePicLink:
                                docs[index].get(User.profilePicLinkField) ?? '',
                            spaces: (docs[index].get(User.spacesField) as List)
                                .map((item) => item as DocumentReference)
                                .toList());
                        return Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: ListTile(
                            tileColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            leading: UserProfilePic(user: user),
                            title: Text(
                              user.displayName,
                              style: RootConstants.textStyleContent,
                            ),
                            onTap: () async {
                              final spaceRef = FirebaseFirestore.instance
                                  .collection('spaces')
                                  .doc(
                                      '${user.userDocumentReference.id}-${_rootController.user.id}');
                              bool chatExists = (await spaceRef.get()).exists;
                              if (!chatExists) {
                                Space space = Space(
                                  spaceName: _textEditingController.text,
                                  createdBy: _rootController
                                      .user.userDocumentReference,
                                  createdTime: Timestamp.now(),
                                  shouldAddUser: false,
                                  displayName1:
                                      _rootController.user.displayName,
                                  displayName2: user.displayName,
                                  admins: [
                                    _rootController.user.userDocumentReference
                                  ],
                                  users: [
                                    _rootController.user.userDocumentReference,
                                    user.userDocumentReference
                                  ],
                                  spacePic: '',
                                );
                                space.uuid =
                                    '${user.userDocumentReference.id}-${_rootController.user.id}';
                                MessageSpaceAPI().createSpace(space);
                                await _rootController.refreshUserData();
                              }
                              Space space = Space.fromObject(
                                  (await spaceRef.get()).data());
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatSpace(space)));
                            },
                            onLongPress: () => Navigator.of(context).push(
                                DialogRoute(
                                    context: context,
                                    builder: (context) =>
                                        CreateChatSpace(user: user))),
                          ),
                        );
                      },
                      itemCount: docs.length,
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
