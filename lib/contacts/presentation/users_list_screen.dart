// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
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
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      gapH12,
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
                                          color: brownColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      gapH12,
                                      Text(
                                        user.phoneNumber,
                                        style: context.sub3.copyWith(color: blackColor),
                                      ),
                                      gapH12,
                                      Text(
                                        user.isOnline
                                            ? UserStatus.online.name.toUpperCase()
                                            : UserStatus.offline.name.toUpperCase(),
                                        style: context.sub3.copyWith(color: blackColor),
                                      ),
                                      gapH12,
                                      ElevatedButton(
                                        onPressed: () {
                                          context.go('/home/direct-chat', extra: user);
                                        },
                                        child: Text(
                                          'Connect to ${user.name}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Card(
                          elevation: 1,
                          surfaceTintColor: backgroundLightColor,
                          shadowColor: accentColor,
                          shape: const RoundedRectangleBorder(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AvatarWidget(imgUrl: user.profilePic),
                              Text(
                                user.name,
                                style: context.sub3.copyWith(color: blackColor),
                              ),
                            ],
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
