import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  const factory UserModel({
    required String name,
    required String uid,
    required String profilePic,
    @Default(true) bool isOnline,
    required String phoneNumber,
    @Default([]) List<Map<String, dynamic>> groups,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
