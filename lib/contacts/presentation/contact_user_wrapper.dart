import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/contacts/presentation/contacts_screen.dart';
import 'package:whatsapp_ui/contacts/presentation/users_list_screen.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

class ContactUserWrapper extends HookConsumerWidget {
  const ContactUserWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final title = useListenableSelector(
      tabController,
      () => tabController.index == 0 ? 'Contacts' : 'Users',
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(title),
        backgroundColor: appBarColor,
        leading: IconButton(
          onPressed: () => context.goNamed(AppRoute.home.name),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: tabColor,
          indicatorWeight: 4,
          labelColor: tabColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Contacts'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [ContactsScreen(), UsersListScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
