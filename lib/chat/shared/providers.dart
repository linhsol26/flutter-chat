import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/application/chat_notifier.dart';
import 'package:whatsapp_ui/chat/domain/message.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/chat/infrastructure/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
    ref.watch(authRepositoryProvider),
  );
});

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, AsyncValue<void>>((ref) {
  return ChatNotifier(ref.watch(chatRepositoryProvider), ref.watch(authRepositoryProvider));
});

final getChatMessagesProvider = StreamProvider.family<List<Message>, String>((ref, receiverId) {
  return ref.watch(chatRepositoryProvider).getChatMessages(receiverId);
});

final messageReplyProvider = StateProvider<MessageReply?>((_) => null);
