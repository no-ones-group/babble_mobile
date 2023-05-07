import 'package:cloud_firestore/cloud_firestore.dart';

import 'space.dart';
import 'user.dart';

class MessageModel {
  late final String id;
  late final String content;
  late final MessageType messageType;
  late final DocumentReference? replyingTo;
  late final DocumentReference by;
  late final Timestamp sentTime;
  late final DocumentReference chatSpace;

  static String get idField => 'id';
  static String get contentField => 'content';
  static String get messageTypeField => 'messageType';
  static String get replyingToField => 'replyingTo';
  static String get byField => 'by';
  static String get sentTimeField => 'sentTime';
  static String get chatSpaceField => 'chatSpace';

  MessageModel({
    required this.id,
    required this.content,
    this.messageType = MessageType.text,
    this.replyingTo,
    required this.by,
    required this.sentTime,
    required this.chatSpace,
  });

  MessageModel.fromObject(Map<String, dynamic> data) {
    id = data[idField];
    content = data[contentField];
    messageType =
        MessageType.values.firstWhere((e) => e.name == data[messageTypeField]);
    replyingTo = data[replyingToField] as DocumentReference?;
    by = data[byField] as DocumentReference;
    sentTime = data[sentTimeField] as Timestamp;
    chatSpace = data[chatSpaceField] as DocumentReference;
  }
}

enum MessageField {
  id,
  content,
  messageType,
  replyingTo,
  by,
  sentTime,
  chatSpace,
}

enum MessageType {
  text,
  image,
  video,
  audio,
}

enum ReadReceipt {
  seen,
  delivered,
  sent,
  notSent,
}
