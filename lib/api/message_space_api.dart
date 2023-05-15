import 'dart:developer';

import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageSpaceAPI with CollectionFields {
  final _firestoreInstance = FirebaseFirestore.instance;

  Future<Space> getSpace(String uuid) async {
    return Space.fromObject(
        (await _firestoreInstance.collection('spaces').doc(uuid).get()).data());
  }

  Future<List<Space>> getSpaces(User user) async {
    List<Space> spaces = [];
    for (var space in user.spaces) {
      spaces.add(Space.fromDocumentSnapshotObject((await space.get())));
    }
    return spaces;
  }

  Future<void> createSpace(Space space) async {
    await _firestoreInstance.collection(Spaces).doc(space.uuid).set({
      Space.uuidField: space.uuid,
      Space.createdByField: space.createdBy,
      Space.createdTimeField: space.createdTime,
      Space.shouldAddUserField: space.shouldAddUser,
      Space.spaceNameField: space.spaceName,
      Space.spacePicField: space.spacePic,
      Space.adminsField: space.admins,
      Space.usersField: space.users,
      Space.displayName1Field: space.displayName1,
      Space.displayName2Field: space.displayName2
    });
    for (var user in space.users) {
      UserAPI().addSpace(user.id, space);
    }
  }
}
