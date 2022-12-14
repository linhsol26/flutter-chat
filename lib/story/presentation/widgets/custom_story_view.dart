import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/story/domain/story_model.dart';

class CustomStoryView extends StatefulWidget {
  const CustomStoryView({super.key, required this.story});

  final StoryModel story;

  @override
  State<CustomStoryView> createState() => _CustomStoryViewState();
}

class _CustomStoryViewState extends State<CustomStoryView> {
  late final StoryController storyController;

  List<StoryItem> items = [];

  @override
  void initState() {
    super.initState();
    storyController = StoryController();
    initStory();
  }

  void initStory() {
    for (var url in widget.story.photoUrl) {
      items.add(StoryItem.pageImage(url: url, controller: storyController));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty
          ? const LoadingWidget()
          : StoryView(
              storyItems: items,
              controller: storyController,
              onComplete: () => context.pop(),
              onVerticalSwipeComplete: (_) => context.pop(),
            ),
    );
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }
}
