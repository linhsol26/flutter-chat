import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
import 'package:whatsapp_ui/chat/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

final searchHistoryProvider = StateProvider<List<String>>((ref) {
  return [];
});

class CustomSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  CustomSearchDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
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
    if (query.isNotEmpty) {
      ref.read(searchHistoryProvider.notifier).state.add(query);
    }
    return AnimatedStreamList<ChatContact>(
        streamList: ref.read(chatRepositoryProvider).search(query),
        itemBuilder: (contact, index, context, animation) {
          return SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(
                opacity: animation,
                child: ListTile(
                  leading: AvatarWidget(imgUrl: contact.profilePic),
                  title: Text(contact.name, style: context.sub3),
                  trailing: const Icon(CupertinoIcons.chat_bubble),
                ),
              ));
        },
        itemRemovedBuilder: (_, __, ___, ____) => Container());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = query.isEmpty ? ref.watch(searchHistoryProvider) : []
      ..toSet()
      ..toList();
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ListTile(
                  title: Text(history[index], style: context.sub3),
                  trailing: IconButton(
                    onPressed: () {
                      ref.read(searchHistoryProvider.notifier).state.removeAt(index);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
