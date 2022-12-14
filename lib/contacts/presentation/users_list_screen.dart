// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class UsersListScreen extends HookConsumerWidget {
  const UsersListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(getUsersListProvider);

    return users.when(
      data: (async) {
        if (async.isSuccess()) {
          final users = async.getSuccess() ?? [];
          return AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];

                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () async {
                          final isOnline = ref.read(userStateProvider).maybeWhen(
                                data: (isOnline) => isOnline,
                                orElse: () => false,
                              );
                          showModalBottomSheet(
                              context: context,
                              elevation: 1,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              )),
                              builder: (context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      gapH32,
                                      CircleAvatar(
                                        radius: 80,
                                        backgroundImage: Image.network(user.profilePic).image,
                                        onBackgroundImageError: (exception, stackTrace) =>
                                            Image.network(defaultAvatar),
                                      ),
                                      gapH12,
                                      Text(
                                        user.name,
                                        style: context.h1.copyWith(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      gapH12,
                                      Text(
                                        user.phoneNumber,
                                        style: context.sub3,
                                      ),
                                      gapH12,
                                      Text(
                                        isOnline
                                            ? UserStatus.online.name.toUpperCase()
                                            : UserStatus.offline.name.toUpperCase(),
                                        style: context.sub3,
                                      ),
                                      gapH12,
                                      ElevatedButton(
                                        onPressed: () async {
                                          await ref
                                              .read(chatNotifierProvider.notifier)
                                              .setJoinedChat(receiverId: user.uid);
                                          Navigator.pop(context);
                                          context.go('/home/direct-chat', extra: user);
                                        },
                                        child: Text(
                                          'Connect to ${user.name}',
                                          style: context.sub3,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Card(
                          color: Theme.of(context).cardColor,
                          shape: const RoundedRectangleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AvatarWidget(imgUrl: user.profilePic),
                                gapH12,
                                Text(
                                  user.name,
                                  maxLines: 1,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: context.sub3,
                                ),
                                gapH2,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return CustomErrorWidget(
            msg: async.getError()?.when(
                  (msg) => msg ?? 'Something went wrong.',
                  noConnection: () => 'No connection.',
                ));
      },
      error: (_, __) => const CustomErrorWidget(),
      loading: () => const LoadingWidget(),
    );
  }
}
