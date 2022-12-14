import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/application/auth_notifier.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    FirebaseMessaging.instance,
  );
});

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges();
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

final currentUserProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  return await ref.watch(authRepositoryProvider).currentUserData;
});

final currentUserStreamProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).currentUserDataStream;
});

final getUserByIdProvider = StreamProvider.autoDispose.family<UserModel, String>((ref, id) {
  return ref.watch(authRepositoryProvider).getUserById(id);
});

final userStateProvider = StreamProvider.autoDispose<bool>((ref) {
  return ref.watch(authRepositoryProvider).userState();
});

final storageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});
