import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/domain/message.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final AuthRepository _authRepository;

  ChatRepository(this._firestore, this._auth, this._authRepository);

  Future<Result<Failure, bool>> sendTextMsg({
    required String message,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
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
        messageReply: messageReply,
        senderUsername: senderUser.name,
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
    required MessageReply? messageReply,
    required String senderUsername,
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
      repliedMessage: messageReply?.message ?? '',
      repliedTo: messageReply != null
          ? messageReply.isMe
              ? senderUsername
              : receiverUsername
          : '',
      repliedMessageType: messageReply?.messageType ?? MessageType.text,
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

  Stream<List<ChatContact>> getChatContacts() {
    return _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser!.uid)
        .collection(CollectionPath.chats)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ChatContact> chatContacts = [];

      for (var contact in snapshot.docs) {
        final chatContact = ChatContact.fromJson(contact.data());
        final userData =
            await _firestore.collection(CollectionPath.users).doc(chatContact.contactId).get();

        final user = UserModel.fromJson(userData.data()!);

        chatContacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }

      return chatContacts;
    });
  }

  Stream<List<Message>> getChatMessages(String receiverId) {
    return _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser!.uid)
        .collection(CollectionPath.chats)
        .doc(receiverId)
        .collection(CollectionPath.messages)
        .orderBy('timeSent')
        .snapshots()
        .map((snapshot) {
      List<Message> messages = [];

      for (var msg in snapshot.docs) {
        messages.add(Message.fromJson(msg.data()));
      }

      return messages;
    });
  }

  Future<Result<Failure, void>> sendFileMessage({
    required File file,
    required String receiverUid,
    required UserModel sender,
    required MessageType messageType,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();
      final ref = 'chat/${messageType.type}/${sender.uid}/$receiverUid/$messageId';

      final imgUrl = await _authRepository.storeFileToFirebase(ref, file);

      final receiver = await _firestore
          .collection(CollectionPath.users)
          .doc(receiverUid)
          .get()
          .then((data) => UserModel.fromJson(data.data()!));

      await _saveDataToContactSubCollection(
        senderUser: sender,
        receiverUser: receiver,
        text: messageType.convert,
        timeSent: timeSent,
      );

      await _saveMessageToMessageSubCollection(
        receiverUserId: receiverUid,
        text: imgUrl,
        messageId: messageId,
        username: sender.name,
        receiverUsername: receiver.name,
        messageType: messageType,
        timeSent: timeSent,
        messageReply: messageReply,
        senderUsername: sender.name,
      );

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } on FirebaseException catch (e) {
      return Error(Failure(msg: e.message));
    }
  }

  Future<Result<Failure, bool>> sendGifMsg({
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
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
        text: 'GIF',
        timeSent: timeSent,
      );

      await _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        receiverUsername: receiverUser.name,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageType.gif,
        username: senderUser.name,
        messageId: const Uuid().v1(),
        messageReply: messageReply,
        senderUsername: senderUser.name,
      );
      return const Success(true);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }
}
