import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/contacts/presentation/contacts_screen.dart';
import 'package:whatsapp_ui/contacts/presentation/users_list_screen.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';

class ContactUserWrapper extends HookConsumerWidget {
  const ContactUserWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const [
          Expanded(child: UsersListScreen()),
          Text('From yours contacts'),
          gapH16,
          Expanded(child: ContactsScreen()),
        ],
      ),
    );
  }
}
