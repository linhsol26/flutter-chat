import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_model.freezed.dart';
part 'status_model.g.dart';

@freezed
class StatusModel with _$StatusModel {
  const StatusModel._();
  const factory StatusModel({
    required String uid,
    required String username,
    required String phoneNumber,
    required List<String> photoUrl,
    required DateTime createdAt,
    required String profilePic,
    required String statusId,
    required List<String> whoCanSee,
    @Default(<String>[]) List<String> isSeen,
  }) = _StatusModel;

  factory StatusModel.fromJson(Map<String, dynamic> json) => _$StatusModelFromJson(json);
}
