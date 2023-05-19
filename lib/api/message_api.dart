import 'package:babble_mobile/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MessageAPI {
  var firebaseFirestoreInstance = FirebaseFirestore.instance;

  void sendMessage(MessageModel msg) async {
    String uuid = const Uuid().v1();
    await firebaseFirestoreInstance.collection('Message').doc(uuid).set({
      MessageModel.idField: uuid,
      MessageModel.byField: msg.by,
      MessageModel.messageTypeField: msg.messageType,
      MessageModel.replyingToField: msg.replyingTo,
      MessageModel.chatSpaceField: msg.chatSpace,
      MessageModel.contentField: msg.content,
    });
  }

  void deleteMessage(String id) {}

  void replyToMessage(int replyMessageID) {}
}
