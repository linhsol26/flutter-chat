// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class ContactsScreen extends HookConsumerWidget {
  const ContactsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(getContactsProvider);

    return contacts.when(
      data: (async) {
        if (async.isSuccess()) {
          final contacts = async.getSuccess() ?? [];
          return AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: contacts.length,
              itemBuilder: (_, index) {
                final contact = contacts[index];

                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await ref.read(selectContactProvider(contact).future);
                          final foundUser = result.success(context);
                          if (foundUser != null) {
                            context.go('/home/direct-chat', extra: foundUser);
                          } else {
                            showError(context, 'User is not regist in app yet.');
                          }
                        },
                        child: Card(
                          elevation: 1,
                          surfaceTintColor: backgroundLightColor,
                          shadowColor: accentColor,
                          shape: const RoundedRectangleBorder(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CircleAvatar(
                                backgroundImage: contact.photo != null
                                    ? MemoryImage(contact.photo!)
                                    : Image.network(defaultAvatar,
                                        loadingBuilder: (_, __, ___) =>
                                            const CircularProgressIndicator()).image,
                                radius: 30,
                              ),
                              gapH12,
                              Text(
                                contact.displayName,
                                style: context.sub3.copyWith(color: blackColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return CustomErrorWidget(
            msg: async.getError()?.when(
                  (msg) => msg ?? 'Something went wrong.',
                  noConnection: () => 'No connection.',
                ));
      },
      error: (_, __) => const CustomErrorWidget(),
      loading: () => const LoadingWidget(),
    );
  }
}
