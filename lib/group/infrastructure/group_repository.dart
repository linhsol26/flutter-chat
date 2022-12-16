import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';

class GroupRepository {
  final FirebaseAuth _auth;
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;

  GroupRepository(this._auth, this._firestore, this._authRepository);

  Future<Result<Failure, void>> createGroup({
    required String name,
    required List<UserModel> selectedUsers,
    File? groupPic,
  }) async {
    try {
      final groupId = const Uuid().v1();
      String? groupPicUrl;
      if (groupPic != null) {
        final ref = 'group/$groupId';
        groupPicUrl = await _authRepository.storeFileToFirebase(ref, groupPic);
      }

      final senderId = _auth.currentUser!.uid;

      final memberIds = [senderId, ...selectedUsers.map((e) => e.uid).toList()];

      final group = GroupModel(
        senderId: senderId,
        name: name,
        groupId: groupId,
        lastMessage: '',
        memberIds: memberIds,
        groupPic: groupPicUrl,
        timeSent: DateTime.now(),
      );

      await _firestore.collection(CollectionPath.groups).doc(groupId).set(group.toJson());

      for (var id in memberIds) {
        final groups = await _firestore
            .collection(CollectionPath.users)
            .doc(id)
            .get()
            .then((userInfo) => UserModel.fromJson(userInfo.data()!).groups);
        await _firestore.collection(CollectionPath.users).doc(id).update({
          'groups': [
            {'id': groupId, 'lastJoined': DateTime.now().toString()},
            ...groups
          ]
        });
      }

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(Failure(msg: e.message));
    } on SocketException {
      return const Error(Failure.noConnection());
    }
  }

  Future<Result<Failure, void>> setJoinedGroupChat({
    required String groupId,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;

      final user = await _firestore
          .collection(CollectionPath.users)
          .doc(userId)
          .get()
          .then((value) => UserModel.fromJson(value.data()!));

      List<Map<String, dynamic>> newGroups = [];

      for (var group in user.groups) {
        if (group['id'] == groupId) {
          newGroups.add(
            {'id': groupId, 'lastJoined': DateTime.now().toString()},
          );
        } else {
          newGroups.add(group);
        }
      }

      await _firestore.collection(CollectionPath.users).doc(userId).update(
        {'groups': newGroups},
      );

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Future<Result<Failure, List<UserModel>>> getListMembers({
    required List<String> memberIds,
  }) async {
    try {
      List<UserModel> members = [];

      for (var id in memberIds) {
        final user = await _firestore
            .collection(CollectionPath.users)
            .doc(id)
            .get()
            .then((value) => UserModel.fromJson(value.data()!));

        members.add(user);
      }

      return Success(members);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Future<Result<Failure, void>> updateGroupImage({
    required File groupPic,
    required String groupId,
  }) async {
    try {
      final ref = 'group/$groupId';
      final groupPicUrl = await _authRepository.storeFileToFirebase(ref, groupPic);

      await _firestore.collection(CollectionPath.groups).doc(groupId).update({
        'groupPic': groupPicUrl,
      });

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Future<Result<Failure, void>> updateGroupName({
    required String name,
    required String groupId,
  }) async {
    try {
      await _firestore.collection(CollectionPath.groups).doc(groupId).update({
        'name': name,
      });

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Stream<GroupModel> getGroupById({
    required String groupId,
  }) {
    return _firestore
        .collection(CollectionPath.groups)
        .doc(groupId)
        .snapshots()
        .map((event) => GroupModel.fromJson(event.data()!));
  }

  Future<Result<Failure, List<String>>> addMembers({
    required String groupId,
    required List<String> currentMemberIds,
    required List<UserModel> selectedUsers,
  }) async {
    try {
      final memberIds = [...currentMemberIds, ...selectedUsers.map((e) => e.uid).toList()];

      await _firestore.collection(CollectionPath.groups).doc(groupId).update({
        'memberIds': memberIds,
      });

      for (var id in memberIds) {
        final groups = await _firestore
            .collection(CollectionPath.users)
            .doc(id)
            .get()
            .then((userInfo) => UserModel.fromJson(userInfo.data()!).groups);

        final alreadyExisted = groups.any((element) => element['id'] == groupId);

        if (!alreadyExisted) {
          await _firestore.collection(CollectionPath.users).doc(id).update({
            'groups': [
              {'id': groupId, 'lastJoined': null},
              ...groups
            ]
          });
        }
      }

      return Success(memberIds);
    } on FirebaseException catch (e) {
      return Error(Failure(msg: e.message));
    } on SocketException {
      return const Error(Failure.noConnection());
    }
  }

  Future<List<GroupModel>> search(String query) async {
    final user = await _authRepository.currentUserData;

    List<GroupModel> groups = [];
    if (user != null) {
      for (var e in user.groups) {
        final group = await _firestore
            .collection(CollectionPath.groups)
            .doc(e['id'])
            .get()
            .then((value) => GroupModel.fromJson(value.data()!));
        if (group.name.compare(query)) {
          groups.add(group);
        }
      }
    }
    return groups;
  }

  Future<void> deleteGroupMessage({
    required String groupId,
    required String messageId,
  }) async {
    await _firestore
        .collection(CollectionPath.groups)
        .doc(groupId)
        .collection(CollectionPath.chats)
        .doc(messageId)
        .delete();
  }

  Future<void> deleteGroupChat({
    required String groupId,
    required List<String> memberIds,
  }) async {
    await _firestore
        .collection(CollectionPath.groups)
        .doc(groupId)
        .collection(CollectionPath.chats)
        .get()
        .then((value) {
      for (var element in value.docs) {
        _firestore
            .collection(CollectionPath.groups)
            .doc(groupId)
            .collection(CollectionPath.chats)
            .doc(element.id)
            .delete();
      }
    });

    await _firestore.collection(CollectionPath.groups).doc(groupId).delete();

    for (var id in memberIds) {
      var groups = [];
      final snapshotUser = await _firestore.collection(CollectionPath.users).doc(id).get();

      groups = UserModel.fromJson(snapshotUser.data()!)
          .groups
          .where((element) => element['id'] != groupId)
          .toList();

      await _firestore.collection(CollectionPath.users).doc(id).update({
        'groups': [...groups]
      });
    }
  }
}
