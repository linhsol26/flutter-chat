import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/chat_input_field.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/group/presentation/group_list.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

class GroupScreen extends HookConsumerWidget {
  const GroupScreen({Key? key, required this.group}) : super(key: key);

  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: group.groupPic != null
                ? AvatarWidget(imgUrl: group.groupPic)
                : const CircleAvatar(radius: 30, child: Icon(Icons.group)),
            textColor: Colors.white,
            title: Text(
              group.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.p1,
            ),
            onTap: () {
              context.pushNamed(AppRoute.editGroup.name, extra: group);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Iconsax.call, color: primaryColor),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Iconsax.video, color: primaryColor),
            ),
          ],
          bottom: const PreferredSize(preferredSize: Size.fromHeight(10), child: SizedBox.shrink()),
        ),
        persistentFooterButtons: [
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ChatInputField(
                receiverId: group.groupId,
                isGroup: true,
                callback: () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(microseconds: 50),
                      );
                    }
                  });

                  ref
                      .read(groupNotifierProvider.notifier)
                      .setJoinedGroupChat(groupId: group.groupId);
                }),
          )
        ],
        body: GroupList(
          groupId: group.groupId,
          scrollController: scrollController,
          receiverName: group.name,
        ),
      ),
    );
  }
}
