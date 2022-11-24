import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/utils/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';

class ContactsList extends HookConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRef = ref.watch(getChatContactsProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: asyncRef.when(
        data: (chatContacts) => ListView.builder(
          shrinkWrap: true,
          itemCount: chatContacts.length,
          itemBuilder: (context, index) {
            final chatContact = chatContacts[index];
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
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          chatContact.profilePic,
                        ),
                        radius: 30,
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
        ),
        error: (error, _) => const CustomErrorWidget(),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
