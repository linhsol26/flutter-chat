import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/chat_list.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/chat_input_field.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/notification/domain/notification_payload.dart';
import 'package:whatsapp_ui/notification/infrastructure/notification_repository.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final foundUser = ref.watch(getUserByIdProvider(user.uid));

    final isShowBtn = useListenableSelector(
        scrollController, () => scrollController.hasClients && scrollController.offset >= 0.2);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0.2,
            leading: IconButton(
              onPressed: () => context.goNamed(AppRoute.home.name),
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            title: foundUser.when(
              data: (user) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: AvatarWidget(imgUrl: user.profilePic),
                textColor: Colors.white,
                title: Text(user.name, style: context.p1),
                subtitle: Text(
                  user.isOnline ? 'Active Now' : UserStatus.offline.name.toUpperCase(),
                  style: context.sub1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: user.isOnline ? Colors.greenAccent[700] : const Color(0xFF797C7B),
                  ),
                ),
              ),
              error: (error, _) => const CustomErrorWidget(msg: 'Cannot load user'),
              loading: () => const CircularProgressIndicator(),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.call, color: primaryColor),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.video, color: primaryColor),
              ),
            ],
            bottom:
                const PreferredSize(preferredSize: Size.fromHeight(10), child: SizedBox.shrink()),
          ),
          persistentFooterButtons: [
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ChatInputField(
                  receiverId: user.uid,
                  callback: (msg) async {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(microseconds: 50),
                        );
                      }
                    });

                    ref.read(chatRepositoryProvider).setJoinedChat(receiverId: user.uid);

                    if (msg is String) {
                      final currentUser = await ref.read(authRepositoryProvider).currentUserData;
                      ref.read(notificationRepositoryProvider).sendChatNotifications(
                            receiverId: user.uid,
                            payload: NotificationPayload(body: msg, title: currentUser!.name),
                            data: currentUser,
                          );
                    }
                  }),
            )
          ],
          body: ChatList(
            receiverId: user.uid,
            scrollController: scrollController,
            receiverName: user.name,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
          floatingActionButton: isShowBtn
              ? FloatingActionButton.small(
                  onPressed: () {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(microseconds: 50),
                        );
                      }
                    });
                  },
                  child: const Icon(Icons.arrow_downward_rounded),
                )
              : null),
    );
  }
}
