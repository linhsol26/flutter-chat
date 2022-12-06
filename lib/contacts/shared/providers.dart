import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/contacts/infrastructure/contacts_repository.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  return ContactsRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});

final getContactsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(contactsRepositoryProvider);
  final result = await repo.getContacts();

  return result;
});

final selectContactProvider = FutureProvider.autoDispose.family((ref, Contact selected) async {
  final repo = ref.watch(contactsRepositoryProvider);
  final result = await repo.selectContact(selected);

  return result;
});

final getUsersListProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(contactsRepositoryProvider);
  final result = await repo.getUsersList();

  return result;
});
