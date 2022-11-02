import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_ui/auth/presentation/login_screen.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/mobile_layout_screen.dart';
import 'package:whatsapp_ui/core/presentation/not_found_screen.dart';
import 'package:whatsapp_ui/core/presentation/utils/responsive_layout.dart';
import 'package:whatsapp_ui/core/presentation/web_layout_screen.dart';
import 'package:whatsapp_ui/landing/presentation/landing_screen.dart';
import 'package:whatsapp_ui/routing/go_router_refresh_stream.dart';

enum AppRoute {
  landing,
  home,
  login,
  user,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location == '/login' || state.location == '/') {
          return '/home';
        }
      } else {
        if (state.location == '/account' || state.location == '/orders') {
          return '/';
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
            builder: (context, state) => const UserScreen(),
          ),
          GoRoute(
            path: 'home',
            name: AppRoute.home.name,
            builder: (context, state) {
              return const ResponsiveLayout(
                mobileScreenLayout: MobileLayoutScreen(),
                webScreenLayout: WebLayoutScreen(),
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
