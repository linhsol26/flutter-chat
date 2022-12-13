import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/search/custom_search_delegate.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/group/infrastructure/group_repository.dart';
import 'package:whatsapp_ui/group/shared/providers.dart';

final _searchGroupProvider = Provider<_SearchGroup>((ref) {
  return _SearchGroup(ref.watch(groupRepositoryProvider));
});

class CustomSearchGroupDelegate extends CustomSearchDelegate<List<GroupModel>> {
  CustomSearchGroupDelegate(super.ref);

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
        child: Text('Start typing to search your groups..'),
      );
    }

    final search = ref.watch(_searchGroupProvider);

    search.searchGroups(query);

    return _buildResultsWidget(search);
  }

  AnimatedStreamList<GroupModel> _buildResultsWidget(_SearchGroup search) {
    return AnimatedStreamList<GroupModel>(
        streamList: search.resultsGroup,
        itemBuilder: (contact, index, context, animation) {
          return SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(
                opacity: animation,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: contact.groupPic != null
                        ? AvatarWidget(
                            imgUrl: contact.groupPic,
                          )
                        : const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.group),
                          ),
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
                  leading: AvatarWidget(imgUrl: contact.groupPic),
                  title: Text(contact.name, style: context.sub3),
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
        child: Text('Start typing to search your groups..'),
      );
    }

    final search = ref.watch(_searchGroupProvider);

    search.searchGroups(query);
    return _buildResultsWidget(search);
  }
}

class _SearchGroup {
  final GroupRepository _groupRepository;

  _SearchGroup(this._groupRepository) {
    _resultsGroup = _searchGroupsTerms.debounceTime(const Duration(milliseconds: 500)).switchMap(
      (query) async* {
        yield await _groupRepository.search(query.trim());
      },
    );
  }

  final _searchGroupsTerms = BehaviorSubject<String>();
  void searchGroups(String query) => _searchGroupsTerms.add(query);

  late Stream<List<GroupModel>> _resultsGroup;
  Stream<List<GroupModel>> get resultsGroup => _resultsGroup;
}
