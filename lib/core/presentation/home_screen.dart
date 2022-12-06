import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/contacts/presentation/contact_user_wrapper.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/widgets/conversation_list.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
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

    final scrollController = useScrollController();
    final isCollapsed = useValueNotifier(false);

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.hasClients && scrollController.offset >= 100) {
          isCollapsed.value = true;
        } else {
          isCollapsed.value = false;
        }
      });
      return () => scrollController.removeListener;
    }, []);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: whiteColor,
        centerTitle: false,
        title: Text('Chat App',
            style: context.sub1.copyWith(
              fontSize: 30,
              color: primaryColor,
              fontWeight: FontWeight.w300,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: primaryColor),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: [
        const ConversationList(),
        const ContactUserWrapper(),
        const Center(child: Text('Calls')),
      ][selectedIndex.value],
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: selectedIndex.value == 0
          ? FloatingActionButton(
              onPressed: () async {
                final image = await pickImageFromGallery(context);

                if (image != null) {
                  // ignore: use_build_context_synchronously
                  context.goNamed(AppRoute.confirmStatus.name, extra: image);
                }
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
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
              CupertinoIcons.person_crop_square_fill,
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
