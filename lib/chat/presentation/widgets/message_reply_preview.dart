import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/app_theme.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.reply_rounded, size: 30),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  messageReply?.isMe ?? false
                      ? 'Replying to yourself'
                      : 'Replying to ${messageReply?.username ?? 'other'}',
                  style: context.sub1.copyWith(fontWeight: FontWeight.w500),
                ),
                gapH4,
                messageReply?.messageType.display(
                      messageReply.message,
                      context,
                      isDark,
                    ) ??
                    const SizedBox.shrink(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(messageReplyProvider.notifier).state = null;
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
