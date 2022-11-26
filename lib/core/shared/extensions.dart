import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/video_player_item.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

extension ResultHandler<T> on Result<Failure, T> {
  T? success(BuildContext context) {
    if (isSuccess()) {
      return getSuccess()!;
    } else {
      getError()!.show(context);
    }
    return null;
  }
}

extension ErrorEx on Failure {
  void show(BuildContext context) =>
      when((msg) => showError(context, msg ?? 'Something wrong happened.'),
          noConnection: () => showNoConnectionError(context));
}

extension MessageTypeEx on MessageType {
  String get convert {
    switch (this) {
      case MessageType.image:
        return '📸 Photo';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.gif:
        return '🎥 Gif';
      case MessageType.audio:
        return '🎶 Audio';
      default:
        return '';
    }
  }

  Widget display(String msg) {
    switch (this) {
      case MessageType.text:
        return Text(msg, style: const TextStyle(fontSize: 16));
      case MessageType.video:
        return VideoPlayerItem(videoUrl: msg);
      default:
        return CachedNetworkImage(imageUrl: msg);
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case MessageType.text:
        return const EdgeInsets.only(left: 10, right: 30, top: 5, bottom: 20);
      default:
        return const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 25);
    }
  }
}
