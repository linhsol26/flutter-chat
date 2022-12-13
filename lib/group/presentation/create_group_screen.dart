import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/presentation/widgets/input_form_widget.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/core/shared/mixins.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

class CreateGroupScreen extends HookConsumerWidget with DismissKeyboard {
  const CreateGroupScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNameCtrl = useTextEditingController();
    final selectedUsers = useValueNotifier<List<UserModel>>([]);
    final selected = useValueListenable(selectedUsers);
    final usersAsync = ref.watch(getUsersListProvider);

    ref.listen<AsyncValue>(groupNotifierProvider, (_, state) {
      state.when(
          loading: () => EasyLoading.show(dismissOnTap: false),
          data: (_) {
            EasyLoading.dismiss();
            context.goNamed(AppRoute.home.name);
            EasyLoading.showSuccess('Successful!!!');
          },
          error: (error, _) {
            EasyLoading.dismiss();
            showError(context);
          });
    });

    return GestureDetector(
      onTap: dismiss,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Create group', style: context.sub3.copyWith(fontSize: 24)),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                gapH32,
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: greyColor),
                  child: const Icon(CupertinoIcons.group, color: blackColor, size: 80),
                ),
                gapH32,
                InputFormWidget(
                  controller: groupNameCtrl,
                  label: 'Group name',
                  inputType: InputType.text,
                ),
                if (selected.isNotEmpty) ...[
                  gapH16,
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      itemCount: selectedUsers.value.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => AvatarWidget(
                        imgUrl: selectedUsers.value[index].profilePic,
                      ),
                      separatorBuilder: (context, index) => gapW4,
                    ),
                  ),
                ],
                const Divider(),
                gapH8,
                Text('Select contacts', style: context.sub3.copyWith(fontSize: 18)),
                Expanded(
                  child: AnimationLimiter(
                    child: usersAsync.maybeWhen(
                      data: (result) {
                        final users = result.getSuccess() ?? [];
                        if (users.isEmpty) {
                          return const CustomErrorWidget(msg: 'Not found any users');
                        }
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: CheckboxListTile(
                                    title: Text(user.name,
                                        style: context.p1.copyWith(fontWeight: FontWeight.w300)),
                                    value: selected.contains(user),
                                    onChanged: (value) {
                                      if (value != null && value) {
                                        selectedUsers.value = List.from(selected)..add(user);
                                      } else {
                                        selectedUsers.value = List.from(selected)..remove(user);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: const ValueKey('btn-group'),
          child: const Icon(Icons.check_rounded, color: whiteColor),
          onPressed: () {
            final groupName = groupNameCtrl.text.isEmpty
                ? selected.map((e) => e.name).reduce((value, element) => '$value,$element')
                : groupNameCtrl.text.trim();

            ref.read(groupNotifierProvider.notifier).createGroup(
                  name: groupName,
                  selectedUsers: selected,
                );
          },
        ),
      ),
    );
  }
}
