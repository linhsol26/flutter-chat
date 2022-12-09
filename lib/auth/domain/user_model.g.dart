// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      name: json['name'] as String,
      uid: json['uid'] as String,
      profilePic: json['profilePic'] as String,
      isOnline: json['isOnline'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String,
      groups: (json['groups'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'profilePic': instance.profilePic,
      'isOnline': instance.isOnline,
      'phoneNumber': instance.phoneNumber,
      'groups': instance.groups,
    };
