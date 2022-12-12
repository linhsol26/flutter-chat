import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/contacts/presentation/contacts_screen.dart';
import 'package:whatsapp_ui/contacts/presentation/users_list_screen.dart';

class ContactUserWrapper extends HookConsumerWidget {
  const ContactUserWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: const [
          UsersListScreen(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Text('From yours contacts'),
          ),
          ContactsScreen(),
        ],
      ),
    );
  }
}
