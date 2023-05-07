import 'package:babble_mobile/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MessageAPI {
  var firebaseFirestoreInstance = FirebaseFirestore.instance;

  void sendMessage(MessageModel msg) async {
    String uuid = const Uuid().v1();
    await firebaseFirestoreInstance.collection('Message').doc(uuid).set({
      MessageField.id.name: uuid,
      MessageField.by.name: msg.by,
      MessageField.messageType.name: msg.messageType,
      MessageField.replyingTo.name: msg.replyingTo,
      MessageField.chatSpace.name: msg.chatSpace,
      MessageField.content.name: msg.content,
    });
  }

  void deleteMessage(String id) {}

  void replyToMessage(int replyMessageID) {}
}
