import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/status/infrastructure/status_repository.dart';

class StatusNotifier extends StateNotifier<AsyncValue<void>> {
  StatusNotifier(this._repository) : super(const AsyncLoading());

  final StatusRepository _repository;

  Future<void> addStatus({
    required File statusImage,
  }) async {
    state = const AsyncLoading();
    final result = await _repository.uploadStatus(statusImage: statusImage);

    state = result.when(
      (error) => AsyncError(error, StackTrace.fromString(error.toString())),
      (success) => const AsyncData(null),
    );
  }
}
