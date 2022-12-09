import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';

class GroupConversationList extends HookConsumerWidget {
  const GroupConversationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useAutomaticKeepAlive(wantKeepAlive: true);

    final user =
        ref.watch(currentUserStreamProvider).maybeWhen(data: (user) => user, orElse: () => null);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: AnimatedStreamList<GroupModel>(
        streamList: ref.read(chatRepositoryProvider).getChatGroups(),
        shrinkWrap: true,
        duration: const Duration(milliseconds: 200),
        itemBuilder: (groupModel, index, _, animation) {
          final lastJoined = user?.groups.singleWhere(
            (e) => e['id'] == groupModel.groupId,
            orElse: () => {'lastJoined': null},
          )['lastJoined'];
          final notMe = groupModel.senderId != user?.uid;

          return InkWell(
            onTap: () {
              ref
                  .read(groupNotifierProvider.notifier)
                  .setJoinedGroupChat(groupId: groupModel.groupId);
              context.push('/home/group-chat', extra: groupModel);
            },
            child: SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(
                opacity: animation,
                child: _ConversationTile(
                  groupModel: groupModel,
                  notMe: notMe,
                  lastJoined: lastJoined != null ? DateTime.tryParse(lastJoined) : null,
                ),
              ),
            ),
          );
        },
        itemRemovedBuilder:
            (GroupModel item, int index, BuildContext context, Animation<double> animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
              opacity: animation,
              child: _ConversationTile(
                groupModel: item,
                lastJoined: null,
                notMe: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    Key? key,
    required this.groupModel,
    required this.lastJoined,
    required this.notMe,
  }) : super(key: key);

  final GroupModel groupModel;
  final DateTime? lastJoined;
  final bool notMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(
          groupModel.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.p2.copyWith(fontSize: 18),
        ),
        subtitle: groupModel.lastMessage.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  groupModel.lastMessage,
                  style: context.sub2.copyWith(fontSize: 16),
                ),
              )
            : null,
        leading: groupModel.groupPic != null
            ? AvatarWidget(
                imgUrl: groupModel.groupPic,
              )
            : const CircleAvatar(
                radius: 30,
                child: Icon(Icons.group),
              ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(DateFormat.Hm().format(groupModel.timeSent),
                style: context.sub1.copyWith(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )),
            if (lastJoined == null || (groupModel.timeSent.isAfter(lastJoined!)))
              if (notMe) const Icon(Icons.circle_rounded, color: Colors.red, size: 10),
          ],
        ),
      ),
    );
  }
}
