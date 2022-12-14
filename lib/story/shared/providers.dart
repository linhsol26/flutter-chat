import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/story/application/story_notifier.dart';
import 'package:whatsapp_ui/story/infrastructure/story_repository.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    ref.watch(authRepositoryProvider),
  );
});

final storyNotifierProvider = StateNotifierProvider<StoryNotifier, AsyncValue<void>>((ref) {
  return StoryNotifier(ref.watch(storyRepositoryProvider));
});

final getStoriesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(storyRepositoryProvider).getStories();
});
