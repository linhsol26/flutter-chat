import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/group/application/group_notifier.dart';
import 'package:whatsapp_ui/group/infrastructure/group_repository.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    ref.watch(authRepositoryProvider),
  );
});

final groupNotifierProvider = StateNotifierProvider<GroupNotifier, AsyncValue>((ref) {
  return GroupNotifier(ref.watch(groupRepositoryProvider));
});

final getListMembersProvider =
    FutureProvider.family.autoDispose<List<UserModel>, List<String>>((ref, memberIds) async {
  final result = await ref.watch(groupRepositoryProvider).getListMembers(memberIds: memberIds);
  return result.when((error) => [], (success) => success);
});
