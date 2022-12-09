import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/group/infrastructure/group_repository.dart';

class GroupNotifier extends StateNotifier<AsyncValue> {
  GroupNotifier(this._repository) : super(const AsyncLoading());

  final GroupRepository _repository;

  Future<void> createGroup({
    required String name,
    required List<UserModel> selectedUsers,
    File? groupPic,
  }) async {
    state = const AsyncLoading();

    final result =
        await _repository.createGroup(name: name, selectedUsers: selectedUsers, groupPic: groupPic);

    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }

  Future<void> setJoinedGroupChat({required String groupId}) async =>
      await _repository.setJoinedGroupChat(groupId: groupId);

  Future<void> updateGroupImage({
    required String groupId,
    required File groupPic,
  }) async {
    state = const AsyncLoading();

    final result = await _repository.updateGroupImage(groupPic: groupPic, groupId: groupId);

    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }
}
