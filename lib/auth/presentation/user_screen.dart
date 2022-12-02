import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:whatsapp_ui/auth/presentation/widgets/input_form_widget.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/core/shared/mixins.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

const defaultAvatar =
    'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

class UserScreen extends HookConsumerWidget with DismissKeyboard {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = useState<File?>(null);
    final btnCtrl = useMemoized(() => RoundedLoadingButtonController());
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();

    ref.listen<AsyncValue>(authNotifierProvider, (_, state) {
      state.maybeWhen(
        data: (_) {
          btnCtrl.success();
          showSuccess(context);
          context.pushNamed(AppRoute.home.name);
        },
        error: (error, stackTrace) {
          (error as Failure).show(context);
          btnCtrl.reset();
        },
        orElse: () {},
      );
    });

    return GestureDetector(
      onTap: () => dismiss(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        image.value == null
                            ? const CircleAvatar(
                                backgroundImage: NetworkImage(defaultAvatar),
                                radius: 64,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(image.value!),
                                radius: 64,
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () async {},
                            // image.value = await pickImageFromGallery(context),
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    gapH64,
                    InputFormWidget(
                      controller: nameCtrl,
                      label: 'Name',
                      inputType: InputType.text,
                    ),
                    gapH16,
                    InputFormWidget(
                      controller: phoneCtrl,
                      label: 'Phone',
                      inputType: InputType.number,
                    ),
                    gapH32,
                    RoundedLoadingButton(
                      controller: btnCtrl,
                      color: messageColor,
                      animateOnTap: false,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          btnCtrl.start();
                          ref.read(authNotifierProvider.notifier).saveUserInf(
                                image.value,
                                nameCtrl.text.trim(),
                                phoneCtrl.text.trim(),
                              );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
