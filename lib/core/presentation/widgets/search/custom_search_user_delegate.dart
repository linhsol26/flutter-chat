// ignore_for_file: use_build_context_synchronously

import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/contacts/infrastructure/contacts_repository.dart';
import 'package:whatsapp_ui/contacts/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/search/custom_search_delegate.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

final _searchUserProvider = Provider<_SearchUser>((ref) {
  return _SearchUser(ref.watch(authRepositoryProvider), ref.watch(contactsRepositoryProvider));
});

class CustomSearchUserDelegate extends CustomSearchDelegate<List<UserModel>> {
  CustomSearchUserDelegate(super.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.close),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Start typing to other search users..'),
      );
    }

    final search = ref.watch(_searchUserProvider);

    search.searchUsers(query);
    search.searchContacts(query);

    return _buildResultsWidget(search);
  }

  Widget _buildResultsWidget(_SearchUser search) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        AnimatedStreamList<UserModel>(
            shrinkWrap: true,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            streamList: search.resultsUser,
            itemBuilder: (contact, index, context, animation) {
              return SizeTransition(
                  sizeFactor: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: AvatarWidget(imgUrl: contact.profilePic),
                        title: Text(contact.name, style: context.sub3),
                        trailing: const Icon(CupertinoIcons.chat_bubble),
                        onTap: () {
                          close(context, contact);
                        },
                      ),
                    ),
                  ));
            },
            itemRemovedBuilder: (contact, __, context, animation) => SizeTransition(
                sizeFactor: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: AvatarWidget(imgUrl: contact.profilePic),
                      title: Text(contact.name, style: context.sub3),
                      trailing: const Icon(CupertinoIcons.chat_bubble),
                      onTap: () {
                        close(context, contact);
                      },
                    ),
                  ),
                ))),
        AnimatedStreamList<Contact>(
          shrinkWrap: true,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          streamList: search.resultsContact,
          itemBuilder: (contact, index, context, animation) {
            return SizeTransition(
                sizeFactor: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: contact.photo != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 28,
                            )
                          : const AvatarWidget(),
                      title: Text(contact.displayName, style: context.sub3),
                      trailing: const Icon(CupertinoIcons.chat_bubble),
                      onTap: () async {
                        final result = await ref.read(selectContactProvider(contact).future);
                        final foundUser = result.success(context);
                        if (foundUser != null) {
                          close(context, contact);
                        } else {
                          showError(context, 'User is not regist in app yet.');
                        }
                      },
                    ),
                  ),
                ));
          },
          itemRemovedBuilder: (contact, _, context, animation) => SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(
                opacity: animation,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: contact.photo != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 28,
                          )
                        : const AvatarWidget(),
                    title: Text(contact.displayName, style: context.sub3),
                    trailing: const Icon(CupertinoIcons.chat_bubble),
                    onTap: () {
                      close(context, contact);
                    },
                  ),
                ),
              )),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Start typing to other search users..'),
      );
    }

    final search = ref.watch(_searchUserProvider);

    search.searchUsers(query);
    search.searchContacts(query);
    return _buildResultsWidget(search);
  }
}

class _SearchUser {
  final AuthRepository _authRepository;
  final ContactsRepository _contactsRepository;

  _SearchUser(this._authRepository, this._contactsRepository) {
    _resultsUser = _searchUsersTerms.debounceTime(const Duration(milliseconds: 500)).switchMap(
      (query) async* {
        yield await _authRepository.search(query.trim());
      },
    );

    _resultsContact =
        _searchContactsTerms.debounceTime(const Duration(milliseconds: 500)).switchMap(
      (query) async* {
        yield await _contactsRepository.search(query.trim());
      },
    );
  }

  final _searchUsersTerms = BehaviorSubject<String>();
  void searchUsers(String query) => _searchUsersTerms.add(query);

  late Stream<List<UserModel>> _resultsUser;
  Stream<List<UserModel>> get resultsUser => _resultsUser;

  final _searchContactsTerms = BehaviorSubject<String>();
  void searchContacts(String query) => _searchContactsTerms.add(query);

  late Stream<List<Contact>> _resultsContact;
  Stream<List<Contact>> get resultsContact => _resultsContact;
}
