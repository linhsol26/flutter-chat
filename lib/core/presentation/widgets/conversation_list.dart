import 'package:advstory/advstory.dart';
import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/status/shared/providers.dart';

class ConversationList extends HookConsumerWidget {
  const ConversationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamContacts = ref.watch(chatRepositoryProvider).getChatContacts();
    final statusAsync = ref.watch(getStatusProvider);
    final me = ref.watch(currentUserProvider).maybeWhen(data: (data) => data, orElse: () => null);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          statusAsync.maybeWhen(
            data: (result) {
              final stories = result.getSuccess() ?? [];
              return SizedBox(
                height: 100,
                child: AdvStory(
                    storyCount: stories.length + 1,
                    storyBuilder: (index) {
                      if (index == 0) {
                        return Story(
                          contentCount: 0,
                          contentBuilder: (contentIndex) => SimpleCustomContent(
                            builder: (_) => const CustomErrorWidget(),
                          ),
                        );
                      } else {
                        return Story(
                          contentCount: stories[index - 1].photoUrl.length,
                          contentBuilder: (contentIndex) => ImageContent(
                            header: const Text('Header'),
                            footer: const Text('Footer'),
                            url: stories[index - 1].photoUrl[contentIndex],
                            errorBuilder: () => const CustomErrorWidget(),
                          ),
                        );
                      }
                    },
                    trayBuilder: (index) => AdvStoryTray(
                          size: const Size(60, 60),
                          username: Text(
                            index == 0 ? 'My Story' : stories[index - 1].username,
                            style: context.sub2.copyWith(color: Colors.black),
                          ),
                          url: index == 0
                              ? me?.profilePic ?? defaultAvatar
                              : stories[index - 1].profilePic,
                        )),
              );
            },
            orElse: () => const LoadingWidget(),
          ),
          Expanded(
            child: AnimatedStreamList<ChatContact>(
              streamList: streamContacts,
              shrinkWrap: true,
              scrollPhysics: const BouncingScrollPhysics(),
              itemBuilder: (chatContact, index, _, animation) {
                return InkWell(
                  onTap: () {
                    context.push(
                      '/home/direct-chat',
                      extra: UserModel(
                        name: chatContact.name,
                        uid: chatContact.contactId,
                        profilePic: chatContact.profilePic,
                        phoneNumber: '',
                      ),
                    );
                  },
                  child: _ConversationTile(chatContact: chatContact),
                );
              },
              itemRemovedBuilder:
                  (ChatContact item, int index, BuildContext context, Animation<double> animation) {
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({Key? key, required this.chatContact}) : super(key: key);

  final ChatContact chatContact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(chatContact.name, style: context.p2.copyWith(fontSize: 18)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            chatContact.lastMessage,
            style: context.sub2.copyWith(fontSize: 16),
          ),
        ),
        leading: AvatarWidget(
          imgUrl: chatContact.profilePic,
        ),
        trailing: Text(DateFormat.Hm().format(chatContact.timeSent),
            style: context.sub1.copyWith(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }
}