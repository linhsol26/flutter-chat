// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatContact _$$_ChatContactFromJson(Map<String, dynamic> json) =>
    _$_ChatContact(
      name: json['name'] as String,
      profilePic: json['profilePic'] as String,
      contactId: json['contactId'] as String,
      timeSent: DateTime.parse(json['timeSent'] as String),
      lastMessage: json['lastMessage'] as String,
      lastJoined: json['lastJoined'] == null
          ? null
          : DateTime.parse(json['lastJoined'] as String),
    );

Map<String, dynamic> _$$_ChatContactToJson(_$_ChatContact instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profilePic': instance.profilePic,
      'contactId': instance.contactId,
      'timeSent': instance.timeSent.toIso8601String(),
      'lastMessage': instance.lastMessage,
      'lastJoined': instance.lastJoined?.toIso8601String(),
    };
