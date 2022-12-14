import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/domain/message.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final AuthRepository _authRepository;

  ChatRepository(this._firestore, this._auth, this._authRepository);

  Future<Result<Failure, bool>> sendTextMsg({
    required String message,
    required String receiverUserId,
    required UserModel senderUser,
    required bool isGroup,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();
      UserModel? receiverUser;

      if (!isGroup) {
        receiverUser = await _firestore
            .collection(CollectionPath.users)
            .doc(receiverUserId)
            .get()
            .then((info) => UserModel.fromJson(info.data()!));
      }

      await _saveDataToContactSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        text: message,
        timeSent: timeSent,
        isGroup: isGroup,
        receiverUserId: receiverUserId,
      );

      await _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        receiverUsername: receiverUser?.name ?? '',
        text: message,
        timeSent: timeSent,
        messageType: MessageType.text,
        username: senderUser.name,
        messageId: const Uuid().v1(),
        messageReply: messageReply,
        senderUsername: senderUser.name,
        isGroup: isGroup,
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
    required UserModel? receiverUser,
    required String text,
    required DateTime timeSent,
    required bool isGroup,
    required String receiverUserId,
  }) async {
    if (isGroup) {
      await _firestore.collection(CollectionPath.groups).doc(receiverUserId).update({
        'senderId': senderUser.uid,
        'lastMessage': text,
        'timeSent': timeSent.toString(),
      });
    } else {
      DateTime? lastJoined;
      await _firestore
          .collection(CollectionPath.users)
          .doc(receiverUserId)
          .collection(CollectionPath.chats)
          .doc(_auth.currentUser?.uid)
          .get()
          .then((value) {
        if (value.data() != null) {
          lastJoined = ChatContact.fromJson(value.data()!).lastJoined;
        } else {
          lastJoined = null;
        }
      });

      final receiverChatContact = ChatContact(
        name: senderUser.name,
        profilePic: senderUser.profilePic,
        contactId: senderUser.uid,
        timeSent: timeSent,
        lastMessage: text,
        lastJoined: lastJoined,
      );

      await _firestore
          .collection(CollectionPath.users)
          .doc(receiverUserId)
          .collection(CollectionPath.chats)
          .doc(_auth.currentUser?.uid)
          .set(receiverChatContact.toJson());

      final senderChatContact = ChatContact(
        name: receiverUser?.name ?? '',
        profilePic: receiverUser?.profilePic ?? defaultAvatar,
        contactId: receiverUserId,
        timeSent: timeSent,
        lastMessage: text,
        lastJoined: timeSent,
      );

      await _firestore
          .collection(CollectionPath.users)
          .doc(_auth.currentUser?.uid)
          .collection(CollectionPath.chats)
          .doc(receiverUser?.uid)
          .set(senderChatContact.toJson());
    }
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
    required bool isGroup,
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

    if (isGroup) {
      // groups -> group id -> chat -> message
      await _firestore
          .collection(CollectionPath.groups)
          .doc(receiverUserId)
          .collection(CollectionPath.chats)
          .doc(messageId)
          .set(message.toJson());
    } else {
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

  Stream<List<ChatContact>> getChatContacts() {
    return _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser!.uid)
        .collection(CollectionPath.chats)
        .orderBy('timeSent', descending: true)
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
          lastMessage: chatContact.lastMessage,
          lastJoined: chatContact.lastJoined,
        ));
      }

      return chatContacts;
    });
  }

  Stream<List<GroupModel>> getChatGroups() {
    return _firestore
        .collection(CollectionPath.groups)
        .where('memberIds', arrayContains: _auth.currentUser!.uid)
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map((snapshot) {
      List<GroupModel> groups = [];
      for (var group in snapshot.docs) {
        groups.add(GroupModel.fromJson(group.data()));
      }
      return groups;
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
        .asyncMap((snapshot) {
      List<Message> messages = [];

      for (var msg in snapshot.docs) {
        messages.add(Message.fromJson(msg.data()));
      }

      return messages.reversed.toList();
    });
  }

  Stream<List<Message>> getGroupMessages(String groupId) {
    return _firestore
        .collection(CollectionPath.groups)
        .doc(groupId)
        .collection(CollectionPath.chats)
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((snapshot) {
      List<Message> messages = [];

      for (var msg in snapshot.docs) {
        messages.add(Message.fromJson(msg.data()));
      }

      return messages.reversed.toList();
    });
  }

  Future<Result<Failure, void>> sendFileMessage({
    required File file,
    required String receiverUid,
    required UserModel sender,
    required MessageType messageType,
    required bool isGroup,
    required MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();
      final ref = 'chat/${messageType.type}/${sender.uid}/$receiverUid/$messageId';

      final imgUrl = await _authRepository.storeFileToFirebase(ref, file);

      UserModel? receiver;
      if (!isGroup) {
        receiver = await _firestore
            .collection(CollectionPath.users)
            .doc(receiverUid)
            .get()
            .then((data) => UserModel.fromJson(data.data()!));
      }

      await _saveDataToContactSubCollection(
        senderUser: sender,
        receiverUser: receiver,
        text: messageType.convert,
        timeSent: timeSent,
        isGroup: isGroup,
        receiverUserId: receiverUid,
      );

      await _saveMessageToMessageSubCollection(
        receiverUserId: receiverUid,
        text: imgUrl,
        messageId: messageId,
        username: sender.name,
        receiverUsername: receiver?.name ?? '',
        messageType: messageType,
        timeSent: timeSent,
        messageReply: messageReply,
        senderUsername: sender.name,
        isGroup: isGroup,
      );

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } on FirebaseException catch (e) {
      return Error(Failure(msg: e.message));
    }
  }

  Future<Result<Failure, void>> setSeen({
    required String receiverId,
    required String messageId,
  }) async {
    try {
      final senderId = _auth.currentUser!.uid;

      /// Save to [sender]
      await _firestore
          .collection(CollectionPath.users)
          .doc(senderId)
          .collection(CollectionPath.chats)
          .doc(receiverId)
          .collection(CollectionPath.messages)
          .doc(messageId)
          .update({'isSeen': true});

      /// Save to [receiver]
      await _firestore
          .collection(CollectionPath.users)
          .doc(receiverId)
          .collection(CollectionPath.chats)
          .doc(senderId)
          .collection(CollectionPath.messages)
          .doc(messageId)
          .update({'isSeen': true});

      setJoinedChat(receiverId: receiverId);

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Future<Result<Failure, void>> setJoinedChat({
    required String receiverId,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;

      await _firestore
          .collection(CollectionPath.users)
          .doc(userId)
          .collection(CollectionPath.chats)
          .doc(receiverId)
          .update({'lastJoined': DateTime.now().toString()});

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Future<void> deleteChat({
    required String receiverUserId,
  }) async {
    await _firestore
        .collection(CollectionPath.users)
        .doc(receiverUserId)
        .collection(CollectionPath.chats)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.messages)
        .get()
        .then((value) {
      for (var element in value.docs) {
        _firestore
            .collection(CollectionPath.users)
            .doc(receiverUserId)
            .collection(CollectionPath.chats)
            .doc(_auth.currentUser?.uid)
            .collection(CollectionPath.messages)
            .doc(element.id)
            .delete();
      }
    });

    await _firestore
        .collection(CollectionPath.users)
        .doc(receiverUserId)
        .collection(CollectionPath.chats)
        .doc(_auth.currentUser?.uid)
        .delete();

    await _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.chats)
        .doc(receiverUserId)
        .collection(CollectionPath.messages)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await _firestore
            .collection(CollectionPath.users)
            .doc(_auth.currentUser?.uid)
            .collection(CollectionPath.chats)
            .doc(receiverUserId)
            .collection(CollectionPath.messages)
            .doc(element.id)
            .delete();
      }
    });

    await _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.chats)
        .doc(receiverUserId)
        .delete();
  }

  /// Delete in both
  Future<void> deleteMessage({
    required String receiverUserId,
    required String messageId,
  }) async {
    await _firestore
        .collection(CollectionPath.users)
        .doc(receiverUserId)
        .collection(CollectionPath.chats)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.messages)
        .doc(messageId)
        .delete();

    await _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.chats)
        .doc(receiverUserId)
        .collection(CollectionPath.messages)
        .doc(messageId)
        .delete();
  }

  /// Delete only in yours
  Future<void> deleteMessageOnMySite({
    required String receiverUserId,
    required String messageId,
  }) async {
    await _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.chats)
        .doc(receiverUserId)
        .collection(CollectionPath.messages)
        .doc(messageId)
        .delete();
  }

  Future<List<ChatContact>> search(String query) async {
    final snapshot = await _firestore
        .collection(CollectionPath.users)
        .doc(_auth.currentUser?.uid)
        .collection(CollectionPath.chats)
        .get();
    List<ChatContact> contacts = [];
    for (var contact in snapshot.docs) {
      final chatContact = ChatContact.fromJson(contact.data());
      if (chatContact.name.compare(query)) {
        final userData =
            await _firestore.collection(CollectionPath.users).doc(chatContact.contactId).get();

        final user = UserModel.fromJson(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
            lastJoined: chatContact.lastJoined,
          ),
        );
      }
    }

    return contacts;
  }
}
