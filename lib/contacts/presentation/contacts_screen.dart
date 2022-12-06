// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class ContactsScreen extends HookConsumerWidget {
  const ContactsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(getContactsProvider);

    return Scaffold(
      body: contacts.when(
        data: (async) {
          if (async.isSuccess()) {
            final contacts = async.getSuccess() ?? [];
            return ListView.separated(
                itemCount: contacts.length + 2,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                itemBuilder: (_, index) {
                  if (index == 0 || index == contacts.length + 1) {
                    return Container();
                  }
                  final contact = contacts[index - 1];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: CircleAvatar(
                      backgroundImage: contact.photo != null
                          ? MemoryImage(contact.photo!)
                          : Image.network(defaultAvatar,
                                  loadingBuilder: (_, __, ___) => const CircularProgressIndicator())
                              .image,
                      radius: 30,
                    ),
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onTap: () async {
                      final result = await ref.read(selectContactProvider(contact).future);
                      final foundUser = result.success(context);
                      if (foundUser != null) {
                        context.go('/home/direct-chat', extra: foundUser);
                      } else {
                        showError(context, 'User is not regist in app yet.');
                      }
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
