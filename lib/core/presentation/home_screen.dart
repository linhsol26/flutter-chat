// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/contacts/presentation/contact_user_wrapper.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/widgets/conversation_list.dart';
import 'package:whatsapp_ui/core/presentation/widgets/search/custom_search_group_delegate.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/group/presentation/group_conversation_list.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';
import 'package:whatsapp_ui/routing/app_router.dart';
import 'package:whatsapp_ui/settings/presentation/settings_screen.dart';

import 'widgets/search/custom_search_chat_delegate.dart';
import 'widgets/search/custom_search_user_delegate.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authRepositoryProvider).updateUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authRepositoryProvider).updateUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerCtrl = useMemoized(() => ZoomDrawerController());
    final selectedIndex = useState(0);
    final listTitle = ref.watch(currentUserStreamProvider).maybeWhen(
          data: (user) => [
            'Welcome, ${user?.name}',
            'Your Groups',
            'Connect with others',
          ],
          orElse: () => [
            'Welcome',
            'Your Groups',
            'Connect with others',
          ],
        );

    return ZoomDrawer(
      controller: drawerCtrl,
      style: DrawerStyle.defaultStyle,
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      menuScreenTapClose: true,
      showShadow: true,
      menuScreen: const SettingsScreen(),
      mainScreen: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: false,
          title: GestureDetector(
            onTap: () => drawerCtrl.toggle!(),
            child: Text(listTitle[selectedIndex.value],
                style: context.sub1.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                )),
          ),
          actions: [
            if (kDebugMode)
              IconButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.logout),
              ),
            IconButton(
              icon: const Icon(Icons.search, color: primaryColor),
              onPressed: () async {
                final res = await showSearch(
                  context: context,
                  delegate: [
                    CustomSearchChatDelegate(ref),
                    CustomSearchGroupDelegate(ref),
                    CustomSearchUserDelegate(ref)
                  ][selectedIndex.value],
                );

                if (res is ChatContact) {
                  await ref.read(chatNotifierProvider.notifier).setJoinedChat(
                        receiverId: res.contactId,
                      );

                  context.push(
                    '/home/direct-chat',
                    extra: UserModel(
                      name: res.name,
                      uid: res.contactId,
                      profilePic: res.profilePic,
                      phoneNumber: '',
                    ),
                  );
                } else if (res is GroupModel) {
                  await ref
                      .read(groupNotifierProvider.notifier)
                      .setJoinedGroupChat(groupId: res.groupId);
                  context.push('/home/group-chat', extra: res);
                } else if (res is UserModel) {
                  await ref.read(chatNotifierProvider.notifier).setJoinedChat(
                        receiverId: res.uid,
                      );

                  context.push('/home/direct-chat', extra: res);
                }
              },
            ),
          ],
        ),
        body: [
          const ConversationList(),
          const GroupConversationList(),
          const ContactUserWrapper(),
        ][selectedIndex.value],
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: selectedIndex.value == 0 || selectedIndex.value == 1
            ? ExpandableFab(
                closeButtonStyle: ExpandableFabCloseButtonStyle(
                    child: Icon(
                  Icons.close,
                  color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                )),
                distance: 80,
                child: const Icon(Icons.add, color: Colors.white),
                children: [
                  FloatingActionButton(
                    heroTag: const ValueKey('btn-story'),
                    onPressed: () async {
                      final image = await pickImageFromGallery(context);

                      if (image != null) {
                        // ignore: use_build_context_synchronously
                        context.goNamed(AppRoute.confirmStatus.name, extra: image);
                      }
                    },
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.amp_stories_sharp, color: Colors.white),
                  ),
                  FloatingActionButton(
                    heroTag: const ValueKey('btn-group'),
                    onPressed: () {
                      if (selectedIndex.value != 1) {
                        selectedIndex.value = 1;
                      }
                      context.goNamed(AppRoute.createGroup.name);
                    },
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.group_add_rounded, color: Colors.white),
                  ),
                  FloatingActionButton(
                    heroTag: const ValueKey('btn-new-chat'),
                    onPressed: () => selectedIndex.value = 2,
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.add_comment_rounded, color: Colors.white),
                  ),
                ],
              )
            : null,
        bottomNavigationBar: FlashyTabBar(
          animationCurve: Curves.linear,
          selectedIndex: selectedIndex.value,
          iconSize: 30,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          shadows: const [BoxShadow(color: primaryColor, blurRadius: 3)],
          items: [
            FlashyTabBarItem(
              icon: const Icon(
                CupertinoIcons.chat_bubble_2,
                color: primaryColor,
              ),
              activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
              title: Text(
                'Chats',
                style: context.sub1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            FlashyTabBarItem(
              icon: const Icon(
                CupertinoIcons.group,
                color: primaryColor,
              ),
              activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
              title: Text(
                'Groups',
                style: context.sub1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            FlashyTabBarItem(
              icon: const Icon(
                CupertinoIcons.person_badge_plus,
                color: primaryColor,
              ),
              activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
              title: Text(
                'Contacts',
                style: context.sub1.copyWith(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          onItemSelected: (i) => selectedIndex.value = i,
        ),
      ),
    );
  }
}
