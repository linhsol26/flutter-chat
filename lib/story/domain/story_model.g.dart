// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StoryModel _$$_StoryModelFromJson(Map<String, dynamic> json) =>
    _$_StoryModel(
      creatorId: json['creatorId'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String,
      photoUrl:
          (json['photoUrl'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      profilePic: json['profilePic'] as String,
      storyId: json['storyId'] as String,
      whoCanSee:
          (json['whoCanSee'] as List<dynamic>).map((e) => e as String).toList(),
      viewed: (json['viewed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$_StoryModelToJson(_$_StoryModel instance) =>
    <String, dynamic>{
      'creatorId': instance.creatorId,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'profilePic': instance.profilePic,
      'storyId': instance.storyId,
      'whoCanSee': instance.whoCanSee,
      'viewed': instance.viewed,
    };
