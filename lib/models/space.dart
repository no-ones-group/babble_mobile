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

  static String get uuidField => 'uuid';
  static String get spaceNameField => 'spaceName';
  static String get createdByField => 'createdBy';
  static String get createdTimeField => 'createdTime';
  static String get adminsField => 'admins';
  static String get usersField => 'users';
  static String get messagesField => 'messages';
  static String get spacesCollection => 'spaces';
  DocumentReference get spaceDocumentReference =>
      FirebaseFirestore.instance.doc('/$spacesCollection/$uuid');
  CollectionReference get messagesCollection => FirebaseFirestore.instance
      .collection('/$spacesCollection/$uuid/$messagesField');

  Space({
    required this.spaceName,
    required this.createdBy,
    required this.createdTime,
    required this.admins,
    required this.users,
  });

  Space.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    if (data.data() == null) {
      return;
    }
    uuid = data[uuidField] as String;
    spaceName = data[spaceNameField] as String;
    createdBy = data[createdByField] as DocumentReference;
    createdTime = data[createdTimeField] as Timestamp;
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
    uuid = data[uuidField] as String;
    spaceName = data[spaceNameField] as String;
    createdBy = data[createdByField] as DocumentReference;
    createdTime = data[createdTimeField] as Timestamp;
    admins = (data[adminsField] as List)
        .map((item) => item as DocumentReference)
        .toList();
    users = (data[usersField] as List)
        .map((item) => item as DocumentReference)
        .toList();
  }

  Space.defaultV1() {
    uuid = 'defaultUUID';
    spaceName = 'defaultSpaceName';
    createdBy = FirebaseFirestore.instance.collection('spaces').doc('1');
    createdTime = Timestamp.now();
    admins = const [];
    users = const [];
  }

  Space.fromObject(Map<String, dynamic>? data) {
    uuid = data![uuidField];
    spaceName = data[spaceNameField] as String;
    createdBy = FirebaseFirestore.instance.doc(data[createdByField]);
    createdTime = data[createdTimeField] as Timestamp;
    admins = (data[adminsField] as List)
        .map((item) => item as DocumentReference)
        .toList();
    users = (data[usersField] as List)
        .map((item) => item as DocumentReference)
        .toList();
  }

  Future<List<Chats>> spacesFromList(List<DocumentReference> spaceDocs) async {
    List<Chats> chats = [];

    for (var doc in spaceDocs) {
      chats
          .add(Chats(space: Space.fromDocumentSnapshotObject(await doc.get())));
    }
    return chats;
  }
}
