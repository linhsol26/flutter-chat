import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/message.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/my_message_card.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/sender_group_message.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';

class GroupList extends HookConsumerWidget {
  const GroupList({
    Key? key,
    required this.groupId,
    required this.scrollController,
    this.receiverName,
  }) : super(key: key);

  final String groupId;
  final String? receiverName;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedStreamList<Message>(
      streamList: ref.read(chatRepositoryProvider).getGroupMessages(groupId),
      shrinkWrap: true,
      duration: const Duration(milliseconds: 200),
      scrollController: scrollController,
      scrollPhysics: const BouncingScrollPhysics(),
      reverse: true,
      itemBuilder: (Message msg, context, index, animation) {
        final me = ref.read(authRepositoryProvider).currentUser;
        final isMe = msg.senderId == me?.uid;
        final notMe = msg.receiverId == me?.uid;
        final timeSent = DateFormat.Hm().format(msg.timeSent);

        if (!msg.isSeen && notMe) {
          ref
              .read(chatNotifierProvider.notifier)
              .setSeen(receiverId: groupId, messageId: msg.messageId);
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
              username: msg.repliedTo != receiverName ? 'You' : msg.repliedTo,
              onLeftSwipe: () {
                ref.read(messageReplyProvider.notifier).state = MessageReply(
                  message: msg.text,
                  isMe: isMe,
                  messageType: msg.type,
                  username: msg.repliedTo == receiverName ? 'You' : msg.repliedTo,
                );
              },
              isSeen: msg.isSeen,
            ),
          );
        }
        return SizeTransition(
          sizeFactor: animation,
          child: SenderGroupMessageCard(
            key: ValueKey(msg.messageId),
            message: msg.text,
            date: timeSent,
            messageType: msg.type,
            username: msg.repliedTo == receiverName ? 'You' : msg.repliedTo,
            repliedText: msg.repliedMessage,
            repliedMessageType: msg.repliedMessageType,
            onRightSwipe: () {
              ref.read(messageReplyProvider.notifier).state = MessageReply(
                message: msg.text,
                isMe: isMe,
                messageType: msg.type,
                username: msg.repliedTo == receiverName ? 'You' : msg.repliedTo,
              );
            },
            senderId: !isMe ? msg.senderId : null,
          ),
        );
      },
      itemRemovedBuilder: (item, index, context, animation) => const SizedBox.shrink(),
    );
  }
}
