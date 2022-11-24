import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/my_message_card.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/sender_message_card.dart';

class ChatList extends HookConsumerWidget {
  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  final String receiverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final asyncRef = ref.watch(getChatMessagesProvider(receiverId));

    return asyncRef.when(
      data: (messages) => ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isMe = msg.senderId == ref.read(authRepositoryProvider).currentUser?.uid;
          final timeSent = DateFormat.Hm().format(msg.timeSent);

          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });

          if (isMe) {
            return MyMessageCard(message: msg.text, date: timeSent);
          }
          return SenderMessageCard(message: msg.text, date: timeSent);
        },
      ),
      error: (error, _) => const CustomErrorWidget(),
      loading: () => const LoadingWidget(),
    );
  }
}
