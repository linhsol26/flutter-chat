import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const Message._();
  const factory Message({
    required String senderId,
    required String receiverId,
    required String text,
    required MessageType type,
    required DateTime timeSent,
    required String messageId,
    required bool isSeen,
    @Default('') String repliedMessage,
    @Default('') String repliedTo,
    @Default(MessageType.text) MessageType repliedMessageType,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}
