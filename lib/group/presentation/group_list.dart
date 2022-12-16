import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/message.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/my_message_card.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/sender_group_message.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';

class GroupList extends HookConsumerWidget {
  const GroupList({
    Key? key,
    required this.groupId,
    required this.scrollController,
  }) : super(key: key);

  final String groupId;
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
      itemBuilder: (Message msg, index, context, animation) {
        final me = ref.read(authRepositoryProvider).currentUser;
        final isMe = msg.senderId == me?.uid;
        final timeSent = DateFormat.Hm().format(msg.timeSent);

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
                  username: msg.repliedTo,
                  replyTo: msg.senderId,
                );
              },
              isSeen: msg.isSeen,
              onHover: () async {
                await _showBottomSheet(context, ref, msg, isMe);
              },
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
            repliedText: msg.repliedMessage,
            repliedMessageType: msg.repliedMessageType,
            username: isMe ? 'You' : msg.repliedTo,
            onRightSwipe: () {
              ref.read(messageReplyProvider.notifier).state = MessageReply(
                message: msg.text,
                isMe: isMe,
                messageType: msg.type,
                username: '',
                replyTo: msg.senderId,
              );
            },
            senderId: !isMe ? msg.senderId : null,
            onHover: () async {
              await _showBottomSheet(context, ref, msg, isMe);
            },
          ),
        );
      },
      itemRemovedBuilder: (item, index, context, animation) => const SizedBox.shrink(),
    );
  }

  _showBottomSheet(BuildContext context, WidgetRef ref, Message msg, bool isMe) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(messageReplyProvider.notifier).state = MessageReply(
                        message: msg.text,
                        isMe: isMe,
                        messageType: msg.type,
                        username: 'You',
                        replyTo: msg.receiverId,
                      );
                    },
                    child: Text(
                      'Reply',
                      style: context.sub3.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref
                          .read(groupRepositoryProvider)
                          .deleteGroupMessage(groupId: groupId, messageId: msg.messageId);
                      EasyLoading.showSuccess('Unsent!!!');
                    },
                    child: Text(
                      'Unsend',
                      style: context.sub3.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Clipboard.setData(ClipboardData(text: msg.text));
                      EasyLoading.showSuccess('Copied!!!');
                    },
                    child: Text(
                      'Copy',
                      style: context.sub3.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
