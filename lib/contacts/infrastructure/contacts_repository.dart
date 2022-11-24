import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/infrastructure/collection_path.dart';

class ContactsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ContactsRepository(this._firestore, this._auth);

  Future<Result<Failure, List<Contact>>> getContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final contacts = await FlutterContacts.getContacts(withProperties: true);
        return Success(contacts);
      } else {
        return const Success([]);
      }
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }

  Future<Result<Failure, UserModel?>> selectContact(Contact selected) async {
    try {
      final users = await _firestore.collection(CollectionPath.users).get();
      UserModel? foundUser;

      users.docs.any((doc) {
        final user = UserModel.fromJson(doc.data());
        final selectedPhone = selected.phones[0].number.trim().replaceAll('+', '');
        final notMe = user.uid != _auth.currentUser!.uid;

        if (user.phoneNumber == selectedPhone && notMe) {
          foundUser = user;
          return true;
        } else {
          return false;
        }
      });

      return Success(foundUser);
    } on SocketException {
      return const Error(Failure.noConnection());
    } catch (e) {
      return Error(Failure(msg: e.toString()));
    }
  }
}