import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAPI {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<User> getUser(String phoneNumber) async {
    if (await isUserAlreadyRegistered(phoneNumber)) {
      var data = await _instance.collection('users').doc(phoneNumber).get();
      User user = User(
        id: phoneNumber,
        profilePicLink: data.get(User.profilePicLinkField),
        displayName: data.get(User.displayNameField),
        fullName: data.get(User.fullNameField),
        spaces: (data.get(User.spacesField) as List)
            .map((item) => item as DocumentReference)
            .toList(),
      );
      return user;
    }
    return User.defaultV1();
  }

  void createUser(User user) {
    _instance.collection('users').doc(user.id).set({
      User.displayNameField: user.displayName,
      User.idField: user.id,
      User.profilePicLinkField: user.profilePicLink,
      User.spacesField: [],
      User.fullNameField: user.fullName,
    });
  }

  Future<bool> isUserAlreadyRegistered(String phoneNumber) async =>
      (await _instance.collection(User.usersCollection).doc(phoneNumber).get())
          .exists;

  Future<void> addSpace(String userId, Space space) async {
    await _instance.collection(User.usersCollection).doc(userId).update({
      User.spacesField: FieldValue.arrayUnion(
          [_instance.collection(Space.spacesCollection).doc(space.uuid)])
    });
  }
}
