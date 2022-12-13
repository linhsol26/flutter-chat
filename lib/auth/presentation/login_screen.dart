import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:whatsapp_ui/auth/presentation/widgets/input_form_widget.dart';
import 'package:whatsapp_ui/auth/presentation/widgets/show_up_animation.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

enum FormType { signup, signin }

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailCtrl = useTextEditingController();
    final pwdCtrl = useTextEditingController();
    final nameCtrl = useTextEditingController();
    final btnCtrl = useMemoized(() => RoundedLoadingButtonController());
    final type = useValueNotifier(FormType.signin);
    final isSignUp = useValueListenable(type) == FormType.signup;
    final validType = useValueNotifier(AutovalidateMode.disabled);
    final isOnUserInteract = useValueListenable(validType);
    final confirmInputCtrl = useAnimationController(duration: const Duration(milliseconds: 500));
    final passwordInputCtrl = useAnimationController(duration: const Duration(milliseconds: 500));

    ref.listen<AsyncValue>(authNotifierProvider, (_, state) {
      state.maybeWhen(
        data: (_) {
          btnCtrl.success();
          context.goNamed(isSignUp ? AppRoute.user.name : AppRoute.home.name);
        },
        error: (error, stackTrace) {
          (error as Failure).show(context);
          btnCtrl.reset();
        },
        orElse: () {},
      );
    });

    useEffect(() {
      passwordInputCtrl.forward();
      return null;
    });

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          autovalidateMode: isOnUserInteract,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Lottie.network(
                        'https://assets6.lottiefiles.com/packages/lf20_ZsoSL7RsIe.json'),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          gapH32,
                          InputFormWidget(
                            controller: emailCtrl,
                            label: 'Email',
                            inputType: InputType.email,
                          ),
                          gapH16,
                          ShowUpAnimation(
                            animationController: passwordInputCtrl,
                            animationDuration: const Duration(milliseconds: 200),
                            delayStart: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                            direction: Direction.horizontal,
                            offset: 0.5,
                            child: InputFormWidget(
                              controller: pwdCtrl,
                              label: 'Password',
                              inputType: InputType.password,
                            ),
                          ),
                          gapH16,
                          ShowUpAnimation(
                            animationController: confirmInputCtrl,
                            animationDuration: const Duration(milliseconds: 200),
                            delayStart: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                            direction: Direction.horizontal,
                            offset: 0.5,
                            child: InputFormWidget(
                              controller: nameCtrl,
                              label: 'Confirm Password',
                              inputType: InputType.password,
                              validator: (v) {
                                if (v != null && v != pwdCtrl.text && isSignUp) {
                                  return 'Password must match.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSignUp) gapH32,
                        RoundedLoadingButton(
                          controller: btnCtrl,
                          color: primaryColor,
                          animateOnTap: false,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              btnCtrl.start();
                              final notifier = ref.read(authNotifierProvider.notifier);
                              final email = emailCtrl.text.trim();
                              final password = pwdCtrl.text;

                              isSignUp
                                  ? notifier.signUp(email, password)
                                  : notifier.signIn(email, password);
                            }
                            validType.value = AutovalidateMode.onUserInteraction;
                          },
                          child: isSignUp
                              ? Text(
                                  'Sign Up',
                                  style: context.sub3,
                                )
                              : Text(
                                  'Login',
                                  style: context.sub3,
                                ),
                        ),
                        if (isSignUp) gapH32,
                        Flexible(
                          child: isSignUp
                              ? TextButton(
                                  onPressed: () {
                                    type.value = FormType.signin;
                                    confirmInputCtrl.reverse();
                                  },
                                  child: Text(
                                    'Back to login',
                                    style: context.sub3,
                                  ),
                                )
                              : Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        type.value = FormType.signup;
                                        confirmInputCtrl.forward();
                                      },
                                      child: Text(
                                        'Don\'t have account?',
                                        style: context.sub3,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Expanded(child: Divider(color: primaryColor)),
                                        gapW4,
                                        Text(
                                          'or',
                                          style: context.sub1.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        gapW4,
                                        const Expanded(child: Divider(color: primaryColor)),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Forgot your password?',
                                        style: context.sub3,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
