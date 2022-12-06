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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: backgroundLightColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply?.isMe ?? false ? ' Replying to yourself' : 'Replying to Other',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              IconButton(
                  onPressed: () {
                    ref.read(messageReplyProvider.notifier).state = null;
                  },
                  icon: const Icon(Icons.close, size: 16))
            ],
          ),
          gapH8,
          messageReply?.messageType.display(messageReply.message) ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
