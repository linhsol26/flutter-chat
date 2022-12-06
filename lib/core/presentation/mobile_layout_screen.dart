import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/widgets/contacts_list.dart';
import 'package:whatsapp_ui/routing/app_router.dart';
import 'package:whatsapp_ui/status/presentation/status_screen.dart';

class MobileLayoutScreen extends StatefulHookConsumerWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
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
    final tabController = useTabController(initialLength: 3);
    final isChatTab = useListenableSelector(tabController, () => tabController.index == 0);

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
        backgroundColor: appBarColor,
        centerTitle: false,
        title: const Text('Chat App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
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
            Tab(text: 'Chats'),
            Tab(text: 'Status'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          ContactsList(),
          StatusScreen(),
          Center(child: Text('Calls')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isChatTab) {
            context.goNamed(AppRoute.contactUserWrapper.name);
          } else {
            final image = await pickImageFromGallery(context);

            if (image != null) {
              // ignore: use_build_context_synchronously
              context.goNamed(AppRoute.confirmStatus.name, extra: image);
            }
          }
        },
        backgroundColor: tabColor,
        child: Icon(
          isChatTab ? Icons.comment : Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
