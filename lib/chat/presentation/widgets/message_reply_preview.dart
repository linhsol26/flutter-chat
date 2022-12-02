import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply?.isMe ?? false ? 'Me' : 'Other',
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
