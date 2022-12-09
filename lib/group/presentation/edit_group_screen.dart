// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/presentation/widgets/input_form_widget.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';

class EditGroupScreen extends HookConsumerWidget {
  const EditGroupScreen({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(getListMembersProvider(group.memberIds));
    final groupInfoAsync = ref.watch(getGroupByIdProvider(group.groupId));

    final image = useState<File?>(null);

    final nameCtrl = useTextEditingController();
    final btnCtrl = useMemoized(() => RoundedLoadingButtonController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0.2,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_outlined, color: primaryColor),
        ),
        centerTitle: true,
        title: Text('Edit', style: context.sub3.copyWith(fontSize: 24)),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 32,
                          right: 32,
                          top: 32,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InputFormWidget(
                            controller: nameCtrl,
                            label: 'Group name',
                            inputType: InputType.text,
                          ),
                          gapH32,
                          RoundedLoadingButton(
                            controller: btnCtrl,
                            color: primaryColor,
                            onPressed: () async {
                              final response =
                                  await ref.read(groupRepositoryProvider).updateGroupName(
                                        groupId: group.groupId,
                                        name: nameCtrl.text.trim(),
                                      );

                              if (response.isSuccess()) {
                                await showSuccess(context);
                                Navigator.pop(context);
                              } else {
                                btnCtrl.error();
                                btnCtrl.reset();
                              }
                            },
                            child: Text('Change', style: context.p1.copyWith(color: whiteColor)),
                          ),
                          gapH32,
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.edit_outlined, color: primaryColor),
          ),
          IconButton(
            onPressed: () async {
              final result = await ref.read(getUsersListProvider.future);

              if (result.isSuccess()) {
                final users = result.getSuccess() ?? [];
                List<UserModel> availableUsers = [...users];

                for (var id in group.memberIds) {
                  for (var user in users) {
                    if (user.uid == id) {
                      availableUsers.remove(user);
                    }
                  }
                }

                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                    builder: (context) {
                      availableUsers = availableUsers.toSet().toList();
                      return AnimationLimiter(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          itemCount: availableUsers.length,
                          separatorBuilder: (_, index) => gapH8,
                          itemBuilder: (BuildContext context, int index) {
                            final user = availableUsers[index];
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                _ListMembersAvailable(
                                  index: index,
                                  user: user,
                                  availableUsers: availableUsers,
                                ),
                                if (index == availableUsers.length - 1)
                                  RoundedLoadingButton(
                                    controller: btnCtrl,
                                    color: primaryColor,
                                    onPressed: () async {
                                      final response =
                                          await ref.read(groupRepositoryProvider).addMembers(
                                                groupId: group.groupId,
                                                currentMemberIds: group.memberIds,
                                                selectedUsers: availableUsers,
                                              );

                                      if (response.isSuccess()) {
                                        await showSuccess(context);
                                        Navigator.pop(context);
                                      } else {
                                        btnCtrl.error();
                                        btnCtrl.reset();
                                      }
                                    },
                                    child: Text(
                                      'Add',
                                      style: context.p1.copyWith(color: whiteColor),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    });
              } else {
                showError(context);
              }
            },
            icon: const Icon(Icons.add, color: primaryColor),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  EasyLoading.show(dismissOnTap: false);
                  image.value = await pickImageFromGallery(context);

                  if (image.value != null) {
                    ref.read(groupNotifierProvider.notifier).updateGroupImage(
                          groupId: group.groupId,
                          groupPic: image.value!,
                        );
                  }

                  EasyLoading.dismiss();
                },
                child: group.groupPic != null
                    ? CircleAvatar(
                        radius: 58,
                        backgroundImage: Image.network(group.groupPic!).image,
                      )
                    : image.value != null
                        ? CircleAvatar(radius: 58, backgroundImage: FileImage(image.value!))
                        : const CircleAvatar(radius: 58, child: Icon(Icons.group, size: 50)),
              ),
              gapH20,
              groupInfoAsync.maybeWhen(
                data: (data) => Text(data.name, style: context.sub3.copyWith(fontSize: 24)),
                orElse: () => Text(group.name, style: context.sub3.copyWith(fontSize: 24)),
              ),
              gapH20,
              const Text('Members'),
              gapH20,
              Expanded(
                child: membersAsync.maybeWhen(
                    data: (members) {
                      return AnimationLimiter(
                        child: ListView.separated(
                          itemCount: members.length,
                          separatorBuilder: (_, __) => gapH8,
                          itemBuilder: (BuildContext context, int index) {
                            final member = members[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Card(
                                    child: ListTile(
                                      leading: SizedBox(
                                        height: 50,
                                        child: AvatarWidget(imgUrl: member.profilePic),
                                      ),
                                      title: Text(member.name),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    orElse: () => const LoadingWidget()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListMembersAvailable extends StatefulWidget {
  const _ListMembersAvailable({
    Key? key,
    required this.user,
    required this.availableUsers,
    required this.index,
  }) : super(key: key);

  final UserModel user;
  final List<UserModel> availableUsers;
  final int index;

  @override
  State<_ListMembersAvailable> createState() => _ListMembersAvailableState();
}

class _ListMembersAvailableState extends State<_ListMembersAvailable> {
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            child: CheckboxListTile(
              title:
                  Text(widget.user.name, style: context.p1.copyWith(fontWeight: FontWeight.w300)),
              value: widget.availableUsers.contains(widget.user),
              onChanged: (value) {
                if (value != null && value) {
                  widget.availableUsers.add(widget.user);
                } else {
                  widget.availableUsers.remove(widget.user);
                }
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
