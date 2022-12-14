// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/files.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/slide_menu.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/routing/app_router.dart';
import 'package:whatsapp_ui/story/presentation/confirm_story_screen.dart';
import 'package:whatsapp_ui/story/shared/providers.dart';

class ConversationList extends HookConsumerWidget {
  const ConversationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(getStoriesProvider);

    useAutomaticKeepAlive(wantKeepAlive: true);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          storiesAsync.maybeWhen(
            data: (stories) {
              if (stories.isEmpty) {
                return Column(
                  children: [
                    AvatarWidget(
                      type: AvatarType.plus,
                      onTap: () async {
                        final image = await pickImageFromGallery(context);

                        if (image != null) {
                          final editableImage = await Navigator.push<File?>(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmStoryScreen(image: image)),
                          );

                          if (editableImage != null) {
                            ref
                                .read(storyNotifierProvider.notifier)
                                .addStory(storyImage: editableImage);
                          } else {
                            showError(context);
                          }
                        }
                      },
                    ),
                    gapH4,
                    Text(
                      'Add a story',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: context.p3,
                    ),
                  ],
                );
              }
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 80,
                width: double.infinity,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final myId = ref.read(authRepositoryProvider).currentUser?.uid;
                    final alreadySeen = stories[index].viewed.contains(myId);
                    return Column(
                      children: [
                        AvatarWidget(
                          borderWidth: alreadySeen ? 1 : 2,
                          roundedColor: alreadySeen ? greyColor : primaryColor,
                          imgUrl: stories[index].profilePic,
                          onTap: () {
                            ref
                                .read(storyRepositoryProvider)
                                .setViewed(creatorId: stories[index].creatorId);
                            context.pushNamed(AppRoute.statusView.name, extra: stories[index]);
                          },
                        ),
                        gapH4,
                        Text(
                          stories[index].creatorId == myId ? 'My stories' : stories[index].username,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: context.p3,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) => gapW8,
                ),
              );
            },
            orElse: () => const LoadingWidget(),
          ),
          Expanded(
            child: AnimatedStreamList<ChatContact>(
              streamList: ref.read(chatRepositoryProvider).getChatContacts(),
              shrinkWrap: true,
              duration: const Duration(milliseconds: 200),
              itemBuilder: (chatContact, index, _, animation) {
                return InkWell(
                  onTap: () {
                    ref.read(chatNotifierProvider.notifier).setJoinedChat(
                          receiverId: chatContact.contactId,
                        );

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
                  child: SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: _ConversationTile(
                        chatContact: chatContact,
                        onDeleted: () async {
                          EasyLoading.show(dismissOnTap: false);
                          await ref
                              .read(chatRepositoryProvider)
                              .deleteChat(receiverUserId: chatContact.contactId);
                          EasyLoading.dismiss();
                        },
                      ),
                    ),
                  ),
                );
              },
              itemRemovedBuilder:
                  (ChatContact item, int index, BuildContext context, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: _ConversationTile(
                      chatContact: item,
                      onDeleted: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends HookWidget {
  const _ConversationTile({Key? key, required this.chatContact, required this.onDeleted})
      : super(key: key);

  final ChatContact chatContact;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(milliseconds: 300));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SlideMenu(
        controller: controller,
        menuItems: [
          CircleAvatar(
            backgroundColor: redColor,
            child: IconButton(
              onPressed: () {
                controller.animateBack(.0);
                onDeleted.call();
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
                color: whiteColor,
              ),
            ),
          ),
        ],
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
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(DateFormat.Hm().format(chatContact.timeSent),
                  style: context.sub1.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
              if (chatContact.lastJoined == null ||
                  chatContact.lastJoined!.isBefore(chatContact.timeSent))
                const Icon(Icons.circle_rounded, color: Colors.red, size: 10),
            ],
          ),
        ),
      ),
    );
  }
}
