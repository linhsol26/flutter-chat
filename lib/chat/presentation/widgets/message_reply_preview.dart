import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return SizedBox(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                      ref.read(messageReplyProvider.state).update((state) => null);
                    },
                    icon: const Icon(Icons.close, size: 16))
              ],
            ),
            gapH8,
            Text(messageReply?.message ?? '')
          ],
        ),
      ),
    );
  }
}
