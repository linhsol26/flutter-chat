import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/chat/infrastructure/chat_repository.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  ChatNotifier(this._repo, this._auth) : super(const AsyncData(null));

  final ChatRepository _repo;
  final AuthRepository _auth;

  Future<void> sendTextMessage(String text, String receiverId) async {
    final senderUser = await _auth.currentUserData;
    final result =
        await _repo.sendTextMsg(message: text, receiverUserId: receiverId, senderUser: senderUser!);

    state = result.when(
        (error) => AsyncError(
              error,
              StackTrace.fromString(error.toString()),
            ),
        (success) => const AsyncData(null));
  }

  Future<void> sendFileMessage(File file, String receiverId, MessageType messageType) async {
    final sender = await _auth.currentUserData;
    final result = await _repo.sendFileMessage(
      file: file,
      receiverUid: receiverId,
      sender: sender!,
      messageType: messageType,
    );

    state = result.when(
        (error) => AsyncError(
              error,
              StackTrace.fromString(error.toString()),
            ),
        (success) => const AsyncData(null));
  }
}
