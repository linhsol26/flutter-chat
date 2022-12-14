import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload.freezed.dart';
part 'notification_payload.g.dart';

@freezed
class NotificationPayload with _$NotificationPayload {
  const NotificationPayload._();
  const factory NotificationPayload({
    required String body,
    required String title,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}
