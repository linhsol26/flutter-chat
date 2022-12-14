import 'dart:convert';
import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/auth/domain/user_model.dart';
import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/shared/storage_keys.dart';
import 'package:whatsapp_ui/group/domain/group_model.dart';
import 'package:whatsapp_ui/notification/domain/notification_payload.dart';
import 'package:http/http.dart' as http;

const String endpoint = 'https://fcm.googleapis.com/fcm/send';

enum NotificationType { direct, group }

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(authRepositoryProvider));
});

class NotificationRepository {
  final AuthRepository _authRepository;

  NotificationRepository(this._authRepository);

  Future<void> sendChatNotifications({
    required String receiverId,
    required NotificationPayload payload,
    required UserModel data,
  }) async {
    final token = await _authRepository.deviceTokenById(receiverId);
    final key = Keys.serverKey;

    if (token.isEmpty) return;

    try {
      await http.post(Uri.parse(endpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$key',
          },
          body: jsonEncode({
            'to': token,
            'notification': payload.toJson(),
            'data': {'type': NotificationType.direct.name, 'data': data.toJson()},
          }));
    } catch (e) {
      log('Notifications error: $e');
      return;
    }
  }

  Future<void> sendGroupNotifications({
    required String receiverId,
    required NotificationPayload payload,
    required GroupModel data,
  }) async {
    final token = await _authRepository.deviceTokenById(receiverId);
    final key = Keys.serverKey;

    if (token.isEmpty) return;

    try {
      await http.post(Uri.parse(endpoint), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$key',
      }, body: {
        'to': token,
        'notification': payload.toJson(),
        'data': {'type': NotificationType.group.name, 'data': data.toJson()},
      });
    } catch (e) {
      log('Notifications error: $e');
      return;
    }
  }
}
