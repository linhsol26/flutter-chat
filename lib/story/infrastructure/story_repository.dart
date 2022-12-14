import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';
import 'package:whatsapp_ui/story/domain/story_model.dart';

class StoryRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  StoryRepository(this._auth, this._firestore, this._authRepository);

  Future<Result<Failure, void>> uploadStory({
    required File storyImage,
  }) async {
    try {
      final user = await _authRepository.currentUserData;
      final storyId = const Uuid().v1();
      final uid = _auth.currentUser?.uid ?? '';
      final path = 'story/$storyId$uid';

      final imgUrl = await _authRepository.storeFileToFirebase(path, storyImage);

      List<String> uidWhoCanSee = [];

      final userData = await _firestore.collection(CollectionPath.users).get();
      for (int i = 0; i < userData.docs.length; i++) {
        final user = UserModel.fromJson(userData.docs[i].data());
        uidWhoCanSee.add(user.uid);
      }

      List<String> storyImgUrls = [];
      final storySnapshot = await _firestore
          .collection(CollectionPath.stories)
          .where('creatorId', isEqualTo: uid)
          .get();

      if (storySnapshot.docs.isNotEmpty) {
        final story = StoryModel.fromJson(storySnapshot.docs[0].data());
        storyImgUrls = [...story.photoUrl];
        storyImgUrls.add(imgUrl);

        await _firestore.collection(CollectionPath.stories).doc(storySnapshot.docs[0].id).update({
          'photoUrl': [...storyImgUrls]
        });
      } else {
        storyImgUrls = [imgUrl];
      }

      final story = StoryModel(
          creatorId: uid,
          username: user?.name ?? '',
          phoneNumber: user?.phoneNumber ?? '',
          photoUrl: storyImgUrls,
          createdAt: DateTime.now(),
          profilePic: user?.profilePic ?? '',
          storyId: storyId,
          whoCanSee: uidWhoCanSee,
          viewed: []);

      await _firestore.collection(CollectionPath.stories).doc(uid).set(story.toJson());

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Stream<List<StoryModel>> getStories() {
    return _firestore
        .collection(CollectionPath.stories)
        .where('createdAt')
        .snapshots()
        .asyncMap((snapshot) {
      List<StoryModel> status = [];
      for (var tempData in snapshot.docs) {
        StoryModel tempStatus = StoryModel.fromJson(tempData.data());
        if (tempStatus.whoCanSee.contains(_auth.currentUser!.uid)) {
          status.add(tempStatus);
        }
      }
      return status;
    });
  }

  Future<void> setViewed({
    required String creatorId,
  }) async {
    final myId = _auth.currentUser?.uid;

    final snapshot = await _firestore.collection(CollectionPath.stories).doc(creatorId).get();
    final viewed = StoryModel.fromJson(snapshot.data()!).viewed;

    final alreadyExisted = viewed.contains(myId);

    if (alreadyExisted) return;

    await _firestore.collection(CollectionPath.stories).doc(creatorId).update({
      'viewed': [myId, ...viewed].toList(),
    });
  }
}
