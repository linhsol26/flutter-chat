// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageReply _$$_MessageReplyFromJson(Map<String, dynamic> json) =>
    _$_MessageReply(
      message: json['message'] as String,
      isMe: json['isMe'] as bool,
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      username: json['username'] as String,
      replyTo: json['replyTo'] as String,
    );

Map<String, dynamic> _$$_MessageReplyToJson(_$_MessageReply instance) =>
    <String, dynamic>{
      'message': instance.message,
      'isMe': instance.isMe,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'username': instance.username,
      'replyTo': instance.replyTo,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.audio: 'audio',
  MessageType.video: 'video',
  MessageType.gif: 'gif',
};
