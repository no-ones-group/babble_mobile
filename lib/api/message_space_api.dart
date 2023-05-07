import 'dart:developer';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageSpaceAPI with CollectionFields {
  final _firestoreInstance = FirebaseFirestore.instance;

  void getSpace(String uuid) {}

  Future<List<Space>> getSpaces(User user) async {
    List<Space> spaces = [];
    for (var space in user.spaces) {
      spaces.add(Space.fromDocumentSnapshotObject((await space.get())));
    }
    return spaces;
  }

  Future<void> createSpace(Space space) async {
    await _firestoreInstance.collection('messageSpaces').doc(space.uuid).set({
      'admins': [_firestoreInstance.doc(space.createdBy.id)],
      'users': [_firestoreInstance.doc(space.createdBy.id)],
    });
    List<DocumentReference> docs = [];
    for (var user in space.users) {
      docs.add(user);
    }
    await _firestoreInstance
        .collection('messageSpaces')
        .doc(space.uuid)
        .update({'users': FieldValue.arrayUnion(docs)});
  }
}
