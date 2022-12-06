// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StatusModel _$$_StatusModelFromJson(Map<String, dynamic> json) =>
    _$_StatusModel(
      uid: json['uid'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String,
      photoUrl:
          (json['photoUrl'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      profilePic: json['profilePic'] as String,
      statusId: json['statusId'] as String,
      whoCanSee:
          (json['whoCanSee'] as List<dynamic>).map((e) => e as String).toList(),
      isSeen: (json['isSeen'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$_StatusModelToJson(_$_StatusModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'profilePic': instance.profilePic,
      'statusId': instance.statusId,
      'whoCanSee': instance.whoCanSee,
      'isSeen': instance.isSeen,
    };
