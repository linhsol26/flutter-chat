import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/message_reply_preview.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

class ChatInputField extends HookConsumerWidget {
  const ChatInputField({Key? key, required this.receiverId, required this.callback})
      : super(key: key);

  final String receiverId;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showEmoji = useValueNotifier(false);
    final focusNode = useFocusNode();
    final messageController = useTextEditingController();

    final showSend =
        useListenableSelector(messageController, () => messageController.text.isNotEmpty);

    final messageReply = ref.watch(messageReplyProvider);

    return Column(
      children: [
        messageReply != null ? const MessageReplyPreview() : const SizedBox.shrink(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
              child: CircleAvatar(
                backgroundColor: primaryColor,
                child: IconButton(
                  onPressed: () {
                    showEmoji.value = !showEmoji.value;

                    if (showEmoji.value) {
                      focusNode.unfocus();
                    } else {
                      focusNode.requestFocus();
                    }
                  },
                  icon: const Icon(Icons.emoji_emotions, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: messageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: whiteColor,
                  suffixIcon: SizedBox(
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
                                    messageReply,
                                  );

                              ref.read(messageReplyProvider.notifier).state = null;
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
                                    messageReply,
                                  );

                              ref.read(messageReplyProvider.notifier).state = null;
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
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFF128C73),
                child: IconButton(
                    onPressed: () async {
                      if (showSend) {
                        ref.read(chatNotifierProvider.notifier).sendTextMessage(
                              messageController.text.trim(),
                              receiverId,
                              messageReply,
                            );

                        messageController.clear();
                        ref.read(messageReplyProvider.notifier).state = null;

                        callback.call();
                      }
                    },
                    icon: Icon(
                      showSend ? Icons.send : Icons.mic,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
            valueListenable: showEmoji,
            builder: (context, isShow, _) {
              return isShow
                  ? SizedBox(
                      height: 310,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          messageController.text = messageController.text + emoji.emoji;
                        },
                      ),
                    )
                  : const SizedBox.shrink();
            }),
      ],
    );
  }
}
