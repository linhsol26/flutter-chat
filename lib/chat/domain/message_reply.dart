import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

part 'message_reply.freezed.dart';
part 'message_reply.g.dart';

@freezed
class MessageReply with _$MessageReply {
  const MessageReply._();
  const factory MessageReply({
    required String message,
    required bool isMe,
    required MessageType messageType,
    required String username,
  }) = _MessageReply;

  factory MessageReply.fromJson(Map<String, dynamic> json) => _$MessageReplyFromJson(json);
}
