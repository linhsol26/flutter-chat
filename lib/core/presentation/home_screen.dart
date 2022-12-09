import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/contacts/presentation/contact_user_wrapper.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/widgets/conversation_list.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/presentation/group_conversation_list.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

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
    final selectedIndex = useState(0);
    final name = ref.watch(currentUserProvider).maybeWhen(
          data: (user) => user?.name ?? '',
          orElse: () => '',
        );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: whiteColor,
        centerTitle: false,
        title: Text('Welcome, $name',
            style: context.sub1.copyWith(
              fontSize: 18,
              color: primaryColor,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: primaryColor),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: [
        const ConversationList(),
        const GroupConversationList(),
        const ContactUserWrapper(),
        const UserScreen(),
      ][selectedIndex.value],
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: selectedIndex.value == 0 || selectedIndex.value == 1
          ? ExpandableFab(
              closeButtonStyle: const ExpandableFabCloseButtonStyle(
                  child: Icon(
                Icons.close,
                color: whiteColor,
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
              ],
            )
          : null,
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: selectedIndex.value,
        iconSize: 30,
        backgroundColor: whiteColor,
        shadows: const [BoxShadow(color: primaryColor, blurRadius: 3)],
        items: [
          FlashyTabBarItem(
            icon: const Icon(
              CupertinoIcons.chat_bubble_2,
              color: primaryColor,
            ),
            title: Text(
              'Chats',
              style: context.sub1.copyWith(
                fontSize: 14,
                color: primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              CupertinoIcons.group,
              color: primaryColor,
            ),
            title: Text(
              'Groups',
              style: context.sub1.copyWith(
                fontSize: 14,
                color: primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              CupertinoIcons.person_badge_plus,
              color: primaryColor,
            ),
            title: Text(
              'Contacts',
              style: context.sub1.copyWith(
                fontSize: 14,
                color: primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              CupertinoIcons.settings,
              color: primaryColor,
            ),
            title: Text(
              'Settings',
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
    );
  }
}
