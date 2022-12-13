import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/infrastructure/chat_repository.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/search/custom_search_delegate.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

final _searchChatProvider = Provider<_SearchChat>((ref) {
  return _SearchChat(ref.watch(chatRepositoryProvider));
});

class CustomSearchChatDelegate extends CustomSearchDelegate<List<ChatContact>> {
  CustomSearchChatDelegate(super.ref);

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
        child: Text('Start typing to search your chats..'),
      );
    }

    final search = ref.watch(_searchChatProvider);

    search.searchChats(query);

    return _buildResultsWidget(search);
  }

  AnimatedStreamList<ChatContact> _buildResultsWidget(_SearchChat search) {
    return AnimatedStreamList<ChatContact>(
        streamList: search.resultsChat,
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
                    subtitle: Text(
                      contact.lastMessage,
                      style: context.sub2.copyWith(fontSize: 16),
                    ),
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
                  subtitle: Text(
                    contact.lastMessage,
                    style: context.sub2,
                  ),
                  trailing: const Icon(CupertinoIcons.chat_bubble),
                  onTap: () {
                    close(context, contact);
                  },
                ),
              ),
            )));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Start typing to search your chats..'),
      );
    }

    final search = ref.watch(_searchChatProvider);

    search.searchChats(query);
    return _buildResultsWidget(search);
  }
}

class _SearchChat {
  final ChatRepository _chatRepository;

  _SearchChat(this._chatRepository) {
    _resultsChat = _searchChatsTerms.debounceTime(const Duration(milliseconds: 500)).switchMap(
      (query) async* {
        yield await _chatRepository.search(query.trim());
      },
    );
  }

  final _searchChatsTerms = BehaviorSubject<String>();
  void searchChats(String query) => _searchChatsTerms.add(query);

  late Stream<List<ChatContact>> _resultsChat;
  Stream<List<ChatContact>> get resultsChat => _resultsChat;
}
