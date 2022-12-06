import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.reply_rounded, color: primaryColor, size: 30),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  messageReply?.isMe ?? false ? 'Replying to yourself' : 'Replying to Other',
                  style: context.sub1.copyWith(fontWeight: FontWeight.w500),
                ),
                gapH4,
                messageReply?.messageType.display(messageReply.message, context) ??
                    const SizedBox.shrink(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(messageReplyProvider.notifier).state = null;
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.close,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
