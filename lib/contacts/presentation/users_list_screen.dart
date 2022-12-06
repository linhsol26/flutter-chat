// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';

class UsersListScreen extends HookConsumerWidget {
  const UsersListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(getUsersListProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: users.when(
        data: (async) {
          if (async.isSuccess()) {
            final users = async.getSuccess() ?? [];
            return ListView.separated(
                itemCount: users.length + 2,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                itemBuilder: (_, index) {
                  if (index == 0 || index == users.length + 1) {
                    return Container();
                  }
                  final user = users[index - 1];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: CircleAvatar(
                      backgroundImage: Image.network(user.profilePic,
                          loadingBuilder: (_, __, ___) => const CircularProgressIndicator()).image,
                      radius: 30,
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onTap: () async {
                      context.go('/home/direct-chat', extra: user);
                    },
                  );
                });
          }
          return CustomErrorWidget(
              msg: async.getError()?.when(
                    (msg) => msg ?? 'Something went wrong.',
                    noConnection: () => 'No connection.',
                  ));
        },
        error: (_, __) => const CustomErrorWidget(),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
