import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/story/infrastructure/story_repository.dart';

class StoryNotifier extends StateNotifier<AsyncValue<void>> {
  StoryNotifier(this._repository) : super(const AsyncLoading());

  final StoryRepository _repository;

  Future<void> addStory({
    required File storyImage,
  }) async {
    state = const AsyncLoading();
    final result = await _repository.uploadStory(storyImage: storyImage);

    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }
}
