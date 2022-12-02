import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/message_reply.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/my_message_card.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class ChatList extends HookConsumerWidget {
  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  final String receiverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final asyncRef = ref.watch(getChatMessagesProvider(receiverId));

    ref.listen<AsyncValue>(chatNotifierProvider, (_, state) {
      state.maybeWhen(
        error: (error, _) => (error as Failure).show(context),
        orElse: () {},
      );
    });

    return asyncRef.when(
      data: (messages) => ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isMe = msg.senderId == ref.read(authRepositoryProvider).currentUser?.uid;
          final notMe = msg.receiverId == ref.read(authRepositoryProvider).currentUser?.uid;
          final timeSent = DateFormat.Hm().format(msg.timeSent);

          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });

          if (!msg.isSeen && notMe) {
            ref
                .read(chatNotifierProvider.notifier)
                .setSeen(receiverId: receiverId, messageId: msg.messageId);
          }

          if (isMe) {
            return MyMessageCard(
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
            );
          }
          return SenderMessageCard(
            message: msg.text,
            date: timeSent,
            messageType: msg.type,
            username: msg.repliedTo,
            repliedText: msg.repliedMessage,
            repliedMessageType: msg.repliedMessageType,
            onLeftSwipe: () {
              ref.read(messageReplyProvider.notifier).state = MessageReply(
                message: msg.text,
                isMe: isMe,
                messageType: msg.type,
              );
            },
          );
        },
      ),
      error: (error, _) => const CustomErrorWidget(),
      loading: () => const LoadingWidget(),
    );
  }
}
