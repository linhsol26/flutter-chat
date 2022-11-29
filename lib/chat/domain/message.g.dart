// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      text: json['text'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timeSent: DateTime.parse(json['timeSent'] as String),
      messageId: json['messageId'] as String,
      isSeen: json['isSeen'] as bool,
      repliedMessage: json['repliedMessage'] as String? ?? '',
      repliedTo: json['repliedTo'] as String? ?? '',
      repliedMessageType: $enumDecodeNullable(
              _$MessageTypeEnumMap, json['repliedMessageType']) ??
          MessageType.text,
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'text': instance.text,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timeSent': instance.timeSent.toIso8601String(),
      'messageId': instance.messageId,
      'isSeen': instance.isSeen,
      'repliedMessage': instance.repliedMessage,
      'repliedTo': instance.repliedTo,
      'repliedMessageType': _$MessageTypeEnumMap[instance.repliedMessageType]!,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.audio: 'audio',
  MessageType.video: 'video',
  MessageType.gif: 'gif',
};
