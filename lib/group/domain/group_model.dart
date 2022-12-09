import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const GroupModel._();
  const factory GroupModel({
    required String senderId,
    required String name,
    required String groupId,
    required String lastMessage,
    String? groupPic,
    required DateTime timeSent,
    required List<String> memberIds,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
}
