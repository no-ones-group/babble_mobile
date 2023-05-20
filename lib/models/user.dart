import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String id;
  late String? profilePicLink;
  late String fullName;
  late String displayName;
  late bool isOnline;
  late String isTyping;
  late List<DocumentReference> spaces;

  static String get idField => 'id';
  static String get profilePicLinkField => 'profilePicLink';
  static String get fullNameField => 'fullName';
  static String get displayNameField => 'displayName';
  static String get spacesField => 'spaces';
  static String get isOnlineField => 'isOnline';
  static String get isTypingField => 'isTyping';
  static String get usersCollection => 'users';
  DocumentReference get userDocumentReference =>
      FirebaseFirestore.instance.doc('/$usersCollection/$id');

  User({
    required this.id,
    this.profilePicLink,
    required this.fullName,
    required this.displayName,
    this.isOnline = false,
    this.isTyping = '',
    this.spaces = const [],
  });

  User.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    log('--> ${doc.id}');
    id = doc.get(idField);
    fullName = doc.get(fullNameField);
    displayName = doc.get(displayNameField);
    isOnline = doc.get(isOnlineField);
    isTyping = doc.get(isTypingField);
    profilePicLink = doc.get(profilePicLinkField);
    spaces = (doc.get(spacesField) as List)
        .map((item) => item as DocumentReference)
        .toList();
  }

  User.defaultV1() {
    id = 'defaultID';
    fullName = 'default fullName';
    displayName = 'default displayName';
    isOnline = true;
    isTyping = 'defaultID';
    profilePicLink = '';
    spaces = const [];
  }
}
