import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';

class ContactsList extends HookConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: AnimatedStreamList<ChatContact>(
        streamList: ref.read(getChatContactsProvider.stream),
        shrinkWrap: true,
        scrollPhysics: const BouncingScrollPhysics(),
        itemBuilder: (chatContact, index, _, animation) {
          return Column(
            children: [
              InkWell(
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      chatContact.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        chatContact.lastMessage,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: AvatarWidget(
                      imgUrl: chatContact.profilePic,
                    ),
                    trailing: Text(
                      DateFormat.Hm().format(chatContact.timeSent),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(color: dividerColor, indent: 85),
            ],
          );
        },
        itemRemovedBuilder:
            (ChatContact item, int index, BuildContext context, Animation<double> animation) {
          return null;
        },
      ),
    );
  }
}
