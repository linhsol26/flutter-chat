import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_action/slide_action.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

class LandingScreen extends HookConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.read(authRepositoryProvider).currentUser != null;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child:
                    Lottie.network('https://assets6.lottiefiles.com/packages/lf20_ZsoSL7RsIe.json'),
              ),
              Text.rich(
                TextSpan(
                  text:
                      'Our chat app is the perfect way to stay connected with friends and family.',
                  style: context.p2,
                ),
              ),
              gapH32,
              const Divider(color: Colors.grey),
              gapH32,
              if (!isSignIn)
                SizedBox(
                  height: 64,
                  child: SlideAction(
                    trackBuilder: (context, currentState) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Discover our app",
                            style: context.sub3.copyWith(fontSize: 16),
                          ),
                        ),
                      );
                    },
                    thumbBuilder: (context, currentState) => Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    action: () => context.replaceNamed(AppRoute.login.name),
                  ),
                ),
              gapH32,
            ],
          ),
        ),
      ),
    );
  }
}
