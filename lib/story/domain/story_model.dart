import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel with _$StoryModel {
  const StoryModel._();
  const factory StoryModel({
    required String creatorId,
    required String username,
    required String phoneNumber,
    required List<String> photoUrl,
    required DateTime createdAt,
    required String profilePic,
    required String storyId,
    required List<String> whoCanSee,
    @Default(<String>[]) List<String> viewed,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
}
