import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/message_reply_preview.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

class ChatInputField extends HookConsumerWidget {
  const ChatInputField({
    Key? key,
    required this.receiverId,
    required this.callback,
    this.isGroup = false,
  }) : super(key: key);

  final String receiverId;
  final bool isGroup;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final messageController = useTextEditingController();

    final messageReply = ref.watch(messageReplyProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        messageReply != null ? const MessageReplyPreview() : const SizedBox.shrink(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: messageController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  filled: true,
                  fillColor: whiteColor,
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final image = await pickImageFromGallery(context);
                            if (image != null) {
                              ref.read(chatNotifierProvider.notifier).sendFileMessage(
                                    image,
                                    receiverId,
                                    MessageType.image,
                                    isGroup,
                                    messageReply,
                                  );

                              ref.read(messageReplyProvider.notifier).state = null;

                              callback.call();
                            }
                          },
                          icon: const Icon(Icons.camera_alt, color: Colors.grey),
                        ),
                        IconButton(
                          onPressed: () async {
                            final video = await pickVideoFromGallery(context);
                            if (video != null) {
                              ref.read(chatNotifierProvider.notifier).sendFileMessage(
                                    video,
                                    receiverId,
                                    MessageType.image,
                                    isGroup,
                                    messageReply,
                                  );

                              ref.read(messageReplyProvider.notifier).state = null;

                              callback.call();
                            }
                          },
                          icon: const Icon(Icons.attach_file, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: primaryColor,
                child: IconButton(
                    onPressed: () async {
                      ref.read(chatNotifierProvider.notifier).sendTextMessage(
                            messageController.text.trim(),
                            receiverId,
                            isGroup,
                            messageReply,
                          );

                      callback.call();
                      messageController.clear();
                      ref.read(messageReplyProvider.notifier).state = null;
                    },
                    icon: const Icon(Icons.send_rounded, color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
