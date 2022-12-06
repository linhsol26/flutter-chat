import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/routing/app_router.dart';
import 'package:whatsapp_ui/status/domain/status_model.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key, required this.status});

  final StatusModel status;

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  late final StoryController storyController;

  List<StoryItem> items = [];

  @override
  void initState() {
    super.initState();
    storyController = StoryController();
    initStory();
  }

  void initStory() {
    for (var url in widget.status.photoUrl) {
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
              onComplete: () => context.goNamed(AppRoute.home.name),
            ),
    );
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }
}
