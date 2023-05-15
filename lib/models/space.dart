import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/contact_tile/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Space {
  String uuid = const Uuid().v1();
  late final String spaceName;
  late final DocumentReference createdBy;
  late final Timestamp createdTime;
  late final List<DocumentReference> admins;
  late final List<DocumentReference> users;
  late final String spacePic;
  late final bool shouldAddUser;
  late final String displayName1;
  late final String displayName2;

  static String get uuidField => 'uuid';
  static String get spaceNameField => 'spaceName';
  static String get createdByField => 'createdBy';
  static String get createdTimeField => 'createdTime';
  static String get adminsField => 'admins';
  static String get usersField => 'users';
  static String get spacePicField => 'spacePic';
  static String get shouldAddUserField => 'shouldAddUser';
  static String get displayName1Field => 'displayName1';
  static String get displayName2Field => 'displayName2';
  static String get messagesField => 'messages';
  static String get spacesCollection => 'spaces';
  DocumentReference get spaceDocumentReference =>
      FirebaseFirestore.instance.doc('/$spacesCollection/$uuid');
  CollectionReference get messagesCollection => FirebaseFirestore.instance
      .collection('/$spacesCollection/$uuid/$messagesField');

  Space({
    required this.spaceName,
    required this.spacePic,
    required this.createdBy,
    required this.createdTime,
    required this.shouldAddUser,
    required this.admins,
    required this.users,
    this.displayName1 = '',
    this.displayName2 = '',
  });

  Space.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    if (data.data() == null) {
      return;
    }

    spacePic = data[spacePicField] as String;
    uuid = data[uuidField] as String;
    spaceName = data[spaceNameField] as String;
    createdBy = data[createdByField] as DocumentReference;
    createdTime = data[createdTimeField] as Timestamp;
    shouldAddUser = data[shouldAddUserField] as bool;
    displayName1 = data[displayName1Field] as String;
    displayName2 = data[displayName2Field] as String;
    admins = (data[adminsField] as List)
        .map((item) => item as DocumentReference)
        .toList();
    users = (data[usersField] as List)
        .map((item) => item as DocumentReference)
        .toList();
  }

  Space.fromDocumentSnapshotObject(DocumentSnapshot<Object?> data) {
    if (data.data() == null) {
      return;
    }

    spacePic = data[spacePicField] as String;
    uuid = data[uuidField] as String;
    spaceName = data[spaceNameField] as String;
    createdBy = data[createdByField] as DocumentReference;
    createdTime = data[createdTimeField] as Timestamp;
    shouldAddUser = data[shouldAddUserField] as bool;
    displayName1 = data[displayName1Field] as String;
    displayName2 = data[displayName2Field] as String;
    admins = (data[adminsField] as List)
        .map((item) => item as DocumentReference)
        .toList();
    users = (data[usersField] as List)
        .map((item) => item as DocumentReference)
        .toList();
  }

  Space.defaultV1() {
    uuid = 'defaultUUID';
    spacePic = '';
    spaceName = 'defaultSpaceName';
    createdBy = FirebaseFirestore.instance.collection('spaces').doc('1');
    createdTime = Timestamp.now();
    shouldAddUser = false;
    displayName1 = '';
    displayName2 = '';
    admins = const [];
    users = const [];
  }

  Space.fromObject(Map<String, dynamic>? data) {
    uuid = data![uuidField];
    spacePic = data[spacePicField] as String;
    spaceName = data[spaceNameField] as String;
    createdBy = data[createdByField] as DocumentReference;
    createdTime = data[createdTimeField] as Timestamp;
    shouldAddUser = data[shouldAddUserField] as bool;
    displayName1 = data[displayName1Field] as String;
    displayName2 = data[displayName2Field] as String;
    admins = (data[adminsField] as List)
        .map((item) => item as DocumentReference)
        .toList();
    users = (data[usersField] as List)
        .map((item) => item as DocumentReference)
        .toList();
  }
}
