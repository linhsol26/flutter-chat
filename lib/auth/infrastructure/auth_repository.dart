import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRepository(this._auth, this._firestore, this._storage);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> get currentUserData async {
    final user =
        await _firestore.collection(CollectionPath.users).doc(currentUser?.uid ?? '').get();

    return user.data() != null ? UserModel.fromJson(user.data()!) : null;
  }

  Future<Result<Failure, void>> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 's-not-found') {
        return const Error(Failure(msg: 'Not found any user with email.'));
      } else if (e.code == 'wrong-password') {
        return const Error(Failure(msg: 'Email or password was wrong.'));
      } else if (e.code == 'email-already-in-use') {
        return const Error(Failure(msg: 'Email already in use. Try another one.'));
      } else if (e.code == 'invalid-email') {
        return const Error(Failure(msg: 'Email is invalid. Try another one.'));
      }
      return Error(Failure(msg: e.toString()));
    } on SocketException {
      return const Error(Failure.noConnection());
    }
  }

  Future<Result<Failure, void>> saveUserInfo(File? image, String name, String phoneNumber) async {
    try {
      String? imgPath;
      final uid = _auth.currentUser?.uid;

      if (image != null) {
        imgPath = await storeFileToFirebase('profilePic/$uid', image);
      }

      final user = UserModel(
        name: name,
        uid: uid!,
        profilePic: imgPath ?? defaultAvatar,
        phoneNumber: phoneNumber,
        groupId: [],
      );

      await _firestore.collection(CollectionPath.users).doc(uid).set(user.toJson());

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(Failure(msg: e.message));
    } on SocketException {
      return const Error(Failure.noConnection());
    }
  }

  Future<Result<Failure, dynamic>> signUpWithEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return const Success(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Error(Failure(msg: 'Not found any user with email.'));
      } else if (e.code == 'wrong-password') {
        return const Error(Failure(msg: 'Email or password was wrong.'));
      } else if (e.code == 'email-already-in-use') {
        return const Error(Failure(msg: 'Email already in use. Try another one.'));
      } else if (e.code == 'invalid-email') {
        return const Error(Failure(msg: 'Email is invalid. Try another one.'));
      }
      return Error(Failure(msg: e.toString()));
    } on SocketException {
      return const Error(Failure.noConnection());
    }
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = _storage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Stream<UserModel> getUserById(String id) {
    return _firestore
        .collection(CollectionPath.users)
        .doc(id)
        .snapshots()
        .map((user) => UserModel.fromJson(user.data()!));
  }

  Future<void> updateUserState(bool isOnline) async {
    await _firestore.collection(CollectionPath.users).doc(_auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
