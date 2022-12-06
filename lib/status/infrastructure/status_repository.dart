import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';
import 'package:whatsapp_ui/status/domain/status_model.dart';

class StatusRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  StatusRepository(this._auth, this._firestore, this._authRepository);

  Future<Result<Failure, void>> uploadStatus({
    required File statusImage,
  }) async {
    try {
      final user = await _authRepository.currentUserData;
      final statusId = const Uuid().v1();
      final uid = _auth.currentUser?.uid ?? '';
      final path = 'status/$statusId$uid';

      final imgUrl = await _authRepository.storeFileToFirebase(path, statusImage);

      List<String> uidWhoCanSee = [];

      final userData = await _firestore.collection(CollectionPath.users).get();
      for (int i = 0; i < userData.docs.length; i++) {
        final user = UserModel.fromJson(userData.docs[i].data());
        uidWhoCanSee.add(user.uid);
      }

      List<String> statusImgUrls = [];
      final statusSnapshot =
          await _firestore.collection(CollectionPath.status).where('uid', isEqualTo: uid).get();

      if (statusSnapshot.docs.isNotEmpty) {
        final status = StatusModel.fromJson(statusSnapshot.docs[0].data());
        statusImgUrls = [...status.photoUrl];
        statusImgUrls.add(imgUrl);

        await _firestore
            .collection(CollectionPath.status)
            .doc(statusSnapshot.docs[0].id)
            .update({'photoUrl': statusImgUrls});
      } else {
        statusImgUrls = [imgUrl];
      }

      final status = StatusModel(
          uid: uid,
          username: user?.name ?? '',
          phoneNumber: user?.phoneNumber ?? '',
          photoUrl: statusImgUrls,
          createdAt: DateTime.now(),
          profilePic: user?.profilePic ?? '',
          statusId: statusId,
          whoCanSee: uidWhoCanSee);

      await _firestore.collection(CollectionPath.status).doc(statusId).set(status.toJson());

      return const Success(null);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Stream<List<StatusModel>> getStatus() {
    List<StatusModel> status = [];

    return _firestore
        .collection(CollectionPath.status)
        .where('createdAt')
        .snapshots()
        .asyncMap((snapshot) {
      for (var tempData in snapshot.docs) {
        StatusModel tempStatus = StatusModel.fromJson(tempData.data());
        if (tempStatus.whoCanSee.contains(_auth.currentUser!.uid)) {
          status.add(tempStatus);
        }
      }
      return status;
    });
  }
}
