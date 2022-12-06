import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/message.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/my_message_card.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/sender_message_card.dart';

class ChatList extends HookConsumerWidget {
  const ChatList({Key? key, required this.receiverId, required this.scrollController})
      : super(key: key);

  final String receiverId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.read(chatRepositoryProvider).getChatMessages(receiverId);
    return AnimatedStreamList<Message>(
      shrinkWrap: true,
      duration: const Duration(milliseconds: 500),
      scrollController: scrollController,
      scrollPhysics: const BouncingScrollPhysics(),
      streamList: messages,
      itemBuilder: (Message msg, context, index, animation) {
        final isMe = msg.senderId == ref.read(authRepositoryProvider).currentUser?.uid;
        final notMe = msg.receiverId == ref.read(authRepositoryProvider).currentUser?.uid;
        final timeSent = DateFormat.Hm().format(msg.timeSent);

        if (!msg.isSeen && notMe) {
          ref
              .read(chatNotifierProvider.notifier)
              .setSeen(receiverId: receiverId, messageId: msg.messageId);
        }

        if (isMe) {
          return SizeTransition(
            sizeFactor: animation,
            child: MyMessageCard(
              key: ValueKey(msg.messageId),
              message: msg.text,
              date: timeSent,
              messageType: msg.type,
              repliedText: msg.repliedMessage,
              repliedMessageType: msg.repliedMessageType,
              username: msg.repliedTo,
              onLeftSwipe: () {
                ref.read(messageReplyProvider.notifier).state = MessageReply(
                  message: msg.text,
                  isMe: isMe,
                  messageType: msg.type,
                );
              },
              isSeen: msg.isSeen,
            ),
          );
        }
        return SizeTransition(
          sizeFactor: animation,
          child: SenderMessageCard(
            key: ValueKey(msg.messageId),
            message: msg.text,
            date: timeSent,
            messageType: msg.type,
            username: msg.repliedTo,
            repliedText: msg.repliedMessage,
            repliedMessageType: msg.repliedMessageType,
            onRightSwipe: () {
              ref.read(messageReplyProvider.notifier).state = MessageReply(
                message: msg.text,
                isMe: isMe,
                messageType: msg.type,
              );
            },
          ),
        );
      },
      itemRemovedBuilder: (item, index, context, animation) => const SizedBox.shrink(),
    );
  }
}
