import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/chat_input_field.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/chat_list.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Consumer(builder: (context, ref, _) {
            final foundUser = ref.watch(getUserByIdProvider(user.uid));
            return foundUser.when(
              data: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_.name),
                  Text(
                    _.isOnline ? UserStatus.online.name : UserStatus.offline.name,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              error: (error, _) => const CustomErrorWidget(msg: 'Cannot load user'),
              loading: () => const LinearProgressIndicator(),
            );
          }),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(receiverId: user.uid),
            ),
            ChatInputField(receiverId: user.uid),
          ],
        ),
      ),
    );
  }
}
