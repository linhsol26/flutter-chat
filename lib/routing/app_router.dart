import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/presentation/login_screen.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/contacts/presentation/contact_user_wrapper.dart';
import 'package:whatsapp_ui/contacts/presentation/contacts_screen.dart';
import 'package:whatsapp_ui/chat/presentation/chat_screen.dart';
import 'package:whatsapp_ui/contacts/presentation/users_list_screen.dart';
import 'package:whatsapp_ui/core/presentation/home_screen.dart';
import 'package:whatsapp_ui/core/presentation/not_found_screen.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/group/presentation/create_group_screen.dart';
import 'package:whatsapp_ui/group/presentation/edit_group_screen.dart';
import 'package:whatsapp_ui/group/presentation/group_screen.dart';
import 'package:whatsapp_ui/landing/presentation/landing_screen.dart';
import 'package:whatsapp_ui/routing/go_router_refresh_stream.dart';
import 'package:whatsapp_ui/settings/presentation/settings_screen.dart';
import 'package:whatsapp_ui/story/domain/story_model.dart';
import 'package:whatsapp_ui/story/presentation/confirm_story_screen.dart';
import 'package:whatsapp_ui/story/presentation/widgets/custom_story_view.dart';

enum AppRoute {
  landing,
  home,
  login,
  user,
  contacts,
  dicrectChat,
  groupChat,
  users,
  contactUserWrapper,
  status,
  confirmStory,
  statusView,
  editGroup,
  createGroup,
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location == '/login' || state.location == '/') {
          return '/home';
        }
      } else {
        if (state.location == '/home' ||
            state.location == '/settings' ||
            state.location == '/user') {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.landing.name,
        builder: (context, state) => const LandingScreen(),
        routes: [
          GoRoute(
            path: 'login',
            name: AppRoute.login.name,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'user',
            name: AppRoute.user.name,
            builder: (context, state) => UserScreen(
                type: state.extra != null ? state.extra as UserScreenType : UserScreenType.create),
          ),
          GoRoute(
            path: 'status-view',
            name: AppRoute.statusView.name,
            pageBuilder: (context, state) => MaterialPage(
              fullscreenDialog: true,
              child: CustomStoryView(
                story: state.extra as StoryModel,
              ),
            ),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'home',
            name: AppRoute.home.name,
            builder: (context, state) {
              return const HomeScreen();
            },
            routes: [
              GoRoute(
                path: 'confirm-story',
                name: AppRoute.confirmStory.name,
                builder: (context, state) => ConfirmStoryScreen(
                  image: state.extra as File,
                ),
              ),
              GoRoute(
                  path: 'contact-user-wrapper',
                  name: AppRoute.contactUserWrapper.name,
                  builder: (context, state) => const ContactUserWrapper(),
                  routes: [
                    GoRoute(
                      path: 'contacts',
                      name: AppRoute.contacts.name,
                      builder: (context, state) => const ContactsScreen(),
                    ),
                    GoRoute(
                      path: 'users-list',
                      name: AppRoute.users.name,
                      builder: (context, state) => const UsersListScreen(),
                    ),
                  ]),
              GoRoute(
                path: 'direct-chat',
                name: AppRoute.dicrectChat.name,
                builder: (context, state) => ChatScreen(
                  user: state.extra as UserModel,
                ),
              ),
              GoRoute(
                path: 'group-chat',
                name: AppRoute.groupChat.name,
                builder: (context, state) => GroupScreen(
                  group: state.extra as GroupModel,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: AppRoute.editGroup.name,
                    builder: (context, state) => EditGroupScreen(
                      group: state.extra as GroupModel,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'create-group',
                name: AppRoute.createGroup.name,
                builder: (context, state) => const CreateGroupScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
