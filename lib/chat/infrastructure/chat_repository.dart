import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/domain/message.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatRepository(this._firestore, this._auth);

  Future<Result<Failure, bool>> sendTextMsg({
    required String message,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      final timeSent = DateTime.now();
      final receiverUser = await _firestore
          .collection(CollectionPath.users)
          .doc(receiverUserId)
          .get()
          .then((info) => UserModel.fromJson(info.data()!));

      await _saveDataToContactSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: message,
        timeSent: timeSent,
      );

      await _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        receiverUsername: receiverUser.name,
        text: message,
        timeSent: timeSent,
        messageType: MessageType.text,
        username: senderUser.name,
        messageId: const Uuid().v1(),
      );
      return const Success(true);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Future<void> _saveDataToContactSubCollection({
    required UserModel senderUser,
    required UserModel receiverUser,
    required String text,
    required DateTime timeSent,
  }) async {
    final receiverChatContact = ChatContact(
      name: senderUser.name,
      profilePic: senderUser.profilePic,
      contactId: senderUser.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await _firestore
        .collection(CollectionPath.users)
        .doc(receiverUser.uid)
        .collection(CollectionPath.chats)
        .doc(_auth.currentUser?.uid)
        .set(receiverChatContact.toJson());

    final senderChatContact = ChatContact(
      name: receiverUser.name,
      profilePic: receiverUser.profilePic,
      contactId: receiverUser.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.chats)
        .doc(receiverUser.uid)
        .set(senderChatContact.toJson());
  }

  Future<void> _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required String messageId,
    required String username,
    required String receiverUsername,
    required MessageType messageType,
    required DateTime timeSent,
  }) async {
    final senderId = _auth.currentUser!.uid;
    final message = Message(
      senderId: senderId,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    /// Save to [sender]
    await _firestore
        .collection(CollectionPath.users)
        .doc(senderId)
        .collection(CollectionPath.chats)
        .doc(receiverUserId)
        .collection(CollectionPath.messages)
        .doc(messageId)
        .set(message.toJson());

    /// Save to [receiver]
    await _firestore
        .collection(CollectionPath.users)
        .doc(receiverUserId)
        .collection(CollectionPath.chats)
        .doc(senderId)
        .collection(CollectionPath.messages)
        .doc(messageId)
        .set(message.toJson());
  }
}
