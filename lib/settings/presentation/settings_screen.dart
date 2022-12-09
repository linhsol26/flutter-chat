import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserStreamProvider);

    return userAsync.when(
      data: (user) {
        if (user != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: const AvatarWidget(roundedColor: primaryColor),
                title: Text(user.name,
                    style: context.sub1.copyWith(fontSize: 16, fontWeight: FontWeight.w300)),
                subtitle: Text(user.phoneNumber, style: context.sub1.copyWith(fontSize: 12)),
              ),
              ListTile(
                leading: Text('Change profile', style: context.sub1.copyWith(fontSize: 18)),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () {
                  context.pushNamed(AppRoute.user.name, extra: UserScreenType.edit);
                },
              ),
              SwitchListTile(
                title: Text('Theme', maxLines: 1, style: context.sub1.copyWith(fontSize: 18)),
                value: false,
                onChanged: (value) {},
              ),
              ListTile(
                leading: Text('Sign out', style: context.sub1.copyWith(fontSize: 18)),
                trailing: IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ),
            ],
          );
        }
        return const CustomErrorWidget();
      },
      error: (_, __) => const CustomErrorWidget(),
      loading: () => const LoadingWidget(),
    );
  }
}
