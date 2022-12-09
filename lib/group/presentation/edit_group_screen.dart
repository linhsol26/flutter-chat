import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    final image = useState<File?>(null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0.2,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_outlined, color: primaryColor),
        ),
        title: Text('Edit', style: context.p1),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  image.value = await pickImageFromGallery(context);

                  if (image.value != null) {
                    ref.read(groupNotifierProvider.notifier).updateGroupImage(
                          groupId: group.groupId,
                          groupPic: image.value!,
                        );
                  }
                },
                child: group.groupPic != null
                    ? AvatarWidget(imgUrl: group.groupPic)
                    : image.value != null
                        ? CircleAvatar(radius: 58, backgroundImage: FileImage(image.value!))
                        : const CircleAvatar(radius: 58, child: Icon(Icons.group, size: 50)),
              ),
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
