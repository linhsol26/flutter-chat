import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

class ChatInputField extends HookConsumerWidget {
  const ChatInputField({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  final String receiverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSend = useValueNotifier(false);
    final messageController = useTextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: messageController,
            onChanged: (v) {
              showSend.value = v.isNotEmpty;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.gif, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
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
                              );
                        } else {
                          showError(context);
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
                              );
                        } else {
                          showError(context);
                        }
                      },
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
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
          padding: const EdgeInsets.fromLTRB(2, 0, 8, 2),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF128C73),
            child: IconButton(
              onPressed: () {
                if (showSend.value) {
                  ref
                      .read(chatNotifierProvider.notifier)
                      .sendTextMessage(messageController.text.trim(), receiverId);

                  messageController.clear();
                }
              },
              icon: ValueListenableBuilder<bool>(
                  valueListenable: showSend,
                  builder: (context, isShow, _) {
                    return Icon(
                      isShow ? Icons.send : Icons.mic,
                      color: Colors.white,
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
