// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/contacts/presentation/contact_user_wrapper.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/theme/app_theme.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/widgets/conversation_list.dart';
import 'package:whatsapp_ui/core/presentation/widgets/search/custom_search_group_delegate.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/group/presentation/group_conversation_list.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';
import 'package:whatsapp_ui/notification/infrastructure/notification_repository.dart';
import 'package:whatsapp_ui/routing/app_router.dart';
import 'package:whatsapp_ui/settings/presentation/settings_screen.dart';
import 'package:whatsapp_ui/story/presentation/confirm_story_screen.dart';
import 'package:whatsapp_ui/story/shared/providers.dart';
import 'widgets/search/custom_search_chat_delegate.dart';
import 'widgets/search/custom_search_user_delegate.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message");
}

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
    ref.read(authRepositoryProvider).saveDeviceToken();
    setUpInteractedMessage();
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

  Future<void> setUpInteractedMessage() async {
    //Get the message from tapping on the notification when app is not in foreground
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await _mapToType(initialMessage);
    }

    //Initialize FlutterLocalNotifications
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'schedular_channel', // id
      'Schedular Notifications', // title
      description: 'This channel is used for Schedular app notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings("@mipmap/ic_launcher"),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (_) =>
            _mapToType(RemoteMessage.fromMap(jsonDecode(_.payload!))));

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //This listens for messages when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_mapToType);

    //Listen to messages in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      //Construct local notification using our created channel
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: jsonEncode(message.toMap()),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "@mipmap/ic_launcher", //Your app icon goes here
            ),
          ),
        );
      }
    });
  }

  @pragma('vm:entry-point')
  _mapToType(RemoteMessage message) async {
    final json = message.data;
    final type = json['type'];
    final data = json['data'];

    if (type == NotificationType.direct.name) {
      final parsedData = UserModel.fromJson(jsonDecode(data));
      ref.read(chatNotifierProvider.notifier).setJoinedChat(
            receiverId: parsedData.uid,
          );

      navigatorKey.currentContext?.push('/home/direct-chat', extra: parsedData);
    } else if (type == NotificationType.group.name) {
      final parsedData = GroupModel.fromJson(jsonDecode(data));
      ref.read(groupNotifierProvider.notifier).setJoinedGroupChat(
            groupId: parsedData.groupId,
          );

      navigatorKey.currentContext?.push('/home/group-chat', extra: parsedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerCtrl = useMemoized(() => ZoomDrawerController());
    final selectedIndex = useState(0);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
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

    ref.listen<AsyncValue<void>>(storyNotifierProvider, (_, state) {
      state.maybeWhen(
        data: (_) {
          EasyLoading.showSuccess('Added story!!!');
        },
        error: (error, stackTrace) {
          EasyLoading.dismiss();
          (error as Failure).show(context);
        },
        loading: () => EasyLoading.show(dismissOnTap: false),
        orElse: () {},
      );
    });

    return ZoomDrawer(
      controller: drawerCtrl,
      style: DrawerStyle.defaultStyle,
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      menuScreenTapClose: true,
      showShadow: true,
      shadowLayer1Color: isDark ? null : greyColor,
      shadowLayer2Color: isDark ? null : backgroundLightColor.withOpacity(0.5),
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
            // if (kDebugMode)
            //   IconButton(
            //     onPressed: () => FirebaseAuth.instance.signOut(),
            //     icon: const Icon(Icons.logout),
            //   ),
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
                closeButtonStyle: const ExpandableFabCloseButtonStyle(
                    child: Icon(Icons.close, color: whiteColor)),
                distance: 80,
                child: const Icon(Icons.add, color: Colors.white),
                children: [
                  FloatingActionButton(
                    heroTag: const ValueKey('btn-story'),
                    onPressed: () async {
                      final image = await pickImageFromGallery(context);

                      if (image != null) {
                        final editableImage = await Navigator.push<File?>(
                          context,
                          MaterialPageRoute(builder: (context) => ConfirmStoryScreen(image: image)),
                        );

                        if (editableImage != null) {
                          ref
                              .read(storyNotifierProvider.notifier)
                              .addStory(storyImage: editableImage);
                        } else {
                          showError(context);
                        }
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
