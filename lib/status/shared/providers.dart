import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/status/application/status_notifier.dart';
import 'package:whatsapp_ui/status/infrastructure/status_repository.dart';

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  return StatusRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    ref.watch(authRepositoryProvider),
  );
});

final statusNotifierProvider = StateNotifierProvider<StatusNotifier, AsyncValue<void>>((ref) {
  return StatusNotifier(ref.watch(statusRepositoryProvider));
});

final getStatusProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(statusRepositoryProvider).getStatus();
});
