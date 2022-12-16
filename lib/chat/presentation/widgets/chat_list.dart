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
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class ChatList extends HookConsumerWidget {
  const ChatList({
    Key? key,
    required this.receiverId,
    required this.scrollController,
    this.receiverName,
  }) : super(key: key);

  final String receiverId;
  final String? receiverName;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedStreamList<Message>(
      streamList: ref.read(chatRepositoryProvider).getChatMessages(receiverId),
      shrinkWrap: true,
      duration: const Duration(milliseconds: 100),
      scrollController: scrollController,
      scrollPhysics: const BouncingScrollPhysics(),
      reverse: true,
      itemBuilder: (Message msg, index, context, animation) {
        final me = ref.read(authRepositoryProvider).currentUser;
        final isMe = msg.senderId == me?.uid;
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
              username: msg.repliedTo != receiverName ? 'You' : msg.repliedTo,
              onLeftSwipe: () {
                ref.read(messageReplyProvider.notifier).state = MessageReply(
                    message: msg.text,
                    isMe: isMe,
                    messageType: msg.type,
                    username: 'You',
                    replyTo: receiverId);
              },
              isSeen: msg.isSeen,
              onHover: () {
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
                                      replyTo: receiverId);
                                },
                                child: Text(
                                  'Reply',
                                  style: context.sub3.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await ref.read(chatRepositoryProvider).deleteMessage(
                                      receiverUserId: receiverId, messageId: msg.messageId);
                                  EasyLoading.showSuccess('Unsent!!!');
                                },
                                child: Text(
                                  'Unsend',
                                  style: context.sub3.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(text: msg.text));
                                  Navigator.pop(context);
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
              },
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
            username: msg.repliedTo == receiverName ? msg.repliedTo : 'You',
            repliedText: msg.repliedMessage,
            repliedMessageType: msg.repliedMessageType,
            onRightSwipe: () {
              ref.read(messageReplyProvider.notifier).state = MessageReply(
                  message: msg.text,
                  isMe: isMe,
                  messageType: msg.type,
                  username: msg.repliedTo == receiverName ? receiverName ?? '' : 'You',
                  replyTo: receiverId);
            },
            onHover: () {
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
                                    username:
                                        msg.repliedTo == receiverName ? 'You' : receiverName ?? '',
                                    replyTo: receiverId);
                              },
                              child: Text(
                                'Reply',
                                style: context.sub3.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await ref.read(chatRepositoryProvider).deleteMessageOnMySite(
                                    receiverUserId: receiverId, messageId: msg.messageId);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Unsend',
                                style: context.sub3.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: msg.text));
                                Navigator.pop(context);
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
            },
          ),
        );
      },
      itemRemovedBuilder: (item, index, context, animation) => const SizedBox.shrink(),
    );
  }
}
