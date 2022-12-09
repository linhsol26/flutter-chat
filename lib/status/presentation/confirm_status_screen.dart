import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/routing/app_router.dart';
import 'package:whatsapp_ui/status/shared/providers.dart';

class ConfirmStatusScreen extends HookConsumerWidget {
  const ConfirmStatusScreen({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(statusNotifierProvider, (_, state) {
      state.maybeWhen(
        data: (_) {
          EasyLoading.dismiss();
          context.goNamed(AppRoute.home.name);
        },
        error: (error, stackTrace) {
          EasyLoading.dismiss();
          (error as Failure).show(context);
        },
        loading: () => EasyLoading.show(dismissOnTap: false),
        orElse: () {},
      );
    });

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(image),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: const ValueKey('btn-story'),
        onPressed: () {
          ref.read(statusNotifierProvider.notifier).addStatus(statusImage: image);
        },
        child: const Icon(Icons.done, color: Colors.white),
      ),
    );
  }
}
