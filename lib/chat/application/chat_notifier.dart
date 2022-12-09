import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/chat/infrastructure/chat_repository.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  ChatNotifier(this._repo, this._auth) : super(const AsyncData(null));

  final ChatRepository _repo;
  final AuthRepository _auth;

  Future<void> sendTextMessage(String text, String receiverId, bool isGroup,
      [MessageReply? mesasgeReply]) async {
    state = const AsyncLoading();
    final senderUser = await _auth.currentUserData;
    final result = await _repo.sendTextMsg(
      message: text,
      receiverUserId: receiverId,
      senderUser: senderUser!,
      isGroup: isGroup,
      messageReply: mesasgeReply,
    );

    state = result.when(
        (error) => AsyncError(
              error,
              StackTrace.fromString(error.toString()),
            ),
        (success) => const AsyncData(null));
  }

  Future<void> sendFileMessage(File file, String receiverId, MessageType messageType, bool isGroup,
      [MessageReply? mesasgeReply]) async {
    state = const AsyncLoading();
    final sender = await _auth.currentUserData;
    final result = await _repo.sendFileMessage(
      file: file,
      receiverUid: receiverId,
      sender: sender!,
      messageType: messageType,
      isGroup: isGroup,
      messageReply: mesasgeReply,
    );

    state = result.when(
        (error) => AsyncError(
              error,
              StackTrace.fromString(error.toString()),
            ),
        (success) => const AsyncData(null));
  }

  Future<void> sendGifMessage(String gifUrl, String receiverId, bool isGroup,
      [MessageReply? mesasgeReply]) async {
    state = const AsyncLoading();
    final senderUser = await _auth.currentUserData;
    final gifUrlPathIndex = gifUrl.lastIndexOf('-') + 1;
    final gifUrlPart = gifUrl.substring(gifUrlPathIndex);
    final newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    final result = await _repo.sendTextMsg(
      message: newGifUrl,
      receiverUserId: receiverId,
      senderUser: senderUser!,
      isGroup: isGroup,
      messageReply: mesasgeReply,
    );

    state = result.when(
        (error) => AsyncError(
              error,
              StackTrace.fromString(error.toString()),
            ),
        (success) => const AsyncData(null));
  }

  Future<void> setSeen({
    required String receiverId,
    required String messageId,
  }) async =>
      await _repo.setSeen(receiverId: receiverId, messageId: messageId);

  Future<void> setJoinedChat({
    required String receiverId,
  }) async =>
      await _repo.setJoinedChat(receiverId: receiverId);
}
