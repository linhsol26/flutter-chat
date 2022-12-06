import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/contacts/presentation/contacts_screen.dart';
import 'package:whatsapp_ui/contacts/presentation/users_list_screen.dart';

class ContactUserWrapper extends HookConsumerWidget {
  const ContactUserWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final title = useListenableSelector(
      tabController,
      () => tabController.index == 0 ? 'Contacts' : 'Users',
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [UsersListScreen(), ContactsScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
