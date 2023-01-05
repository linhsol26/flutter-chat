import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';

class AuthNotifier extends StateNotifier<AsyncValue> {
  AuthNotifier(this._authRepository) : super(const AsyncLoading());

  final AuthRepository _authRepository;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await _authRepository.signInWithEmailPassword(email, password);
    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    final result = await _authRepository.signUpWithEmailPassword(email, password);
    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }

  Future<void> sendReset(String email) async {
    state = const AsyncLoading();
    final result = await _authRepository.sendPasswordResetEmail(email);
    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => AsyncData(success),
    );
  }

  Future<void> signOut() async => await _authRepository.signOut();

  Future<void> saveUserInf(File? image, String name, String phoneNumber) async {
    state = const AsyncLoading();
    final result = await _authRepository.saveUserInfo(image, name, phoneNumber);
    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }

  Future<void> editUserInf(File? image, String name, String phoneNumber) async {
    state = const AsyncLoading();
    final result = await _authRepository.saveUserInfo(image, name, phoneNumber);
    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }
}
