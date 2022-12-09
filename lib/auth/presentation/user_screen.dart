import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:whatsapp_ui/auth/presentation/widgets/input_form_widget.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/core/shared/mixins.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

const defaultAvatar =
    'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

enum UserScreenType { edit, create }

class UserScreen extends HookConsumerWidget with DismissKeyboard {
  const UserScreen({super.key, this.type = UserScreenType.create});

  final UserScreenType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = useState<File?>(null);
    final btnCtrl = useMemoized(() => RoundedLoadingButtonController());
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final user =
        ref.watch(currentUserStreamProvider).maybeWhen(data: (user) => user, orElse: () => null);

    final nameCtrl = useTextEditingController(
        text: type == UserScreenType.edit && user != null ? user.name : null);
    final phoneCtrl = useTextEditingController(
        text: type == UserScreenType.edit && user != null ? user.phoneNumber : null);
    ref.listen<AsyncValue>(authNotifierProvider, (_, state) {
      state.maybeWhen(
        data: (_) async {
          btnCtrl.success();
          if (type != UserScreenType.edit) {
            showSuccess(context);
            context.pushNamed(AppRoute.home.name);
          }
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
        appBar: type == UserScreenType.edit
            ? AppBar(
                backgroundColor: whiteColor,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                elevation: 0.2,
                title: Text('Edit profile', style: context.sub3.copyWith(fontSize: 24)),
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_outlined),
                ),
              )
            : null,
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
                        if (type == UserScreenType.edit && user != null)
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 58,
                          )
                        else
                          image.value == null
                              ? const CircleAvatar(
                                  backgroundImage: NetworkImage(defaultAvatar),
                                  radius: 58,
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image.value!),
                                  radius: 58,
                                ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () async {
                              image.value = await pickImageFromGallery(context);
                            },
                            icon: Icon(type == UserScreenType.edit
                                ? CupertinoIcons.camera_rotate
                                : Icons.add_a_photo),
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
                      color: primaryColor,
                      animateOnTap: false,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          dismiss();
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
