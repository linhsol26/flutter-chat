import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:whatsapp_ui/chat/presentation/widgets/video_player_item.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';

extension UIThemeEx on BuildContext {
  TextStyle get h1 => Theme.of(this).textTheme.displayLarge!;
  TextStyle get h2 => Theme.of(this).textTheme.displayMedium!;
  TextStyle get h3 => Theme.of(this).textTheme.displaySmall!;
  TextStyle get h4 => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get p1 => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get p2 => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get p3 => Theme.of(this).textTheme.bodySmall!;
  TextStyle get p4 => Theme.of(this).textTheme.titleSmall!;
  TextStyle get p5 => Theme.of(this).textTheme.titleMedium!;
  TextStyle get sub1 => Theme.of(this).textTheme.labelSmall!;
  TextStyle get sub2 => Theme.of(this).textTheme.labelMedium!;
  TextStyle get sub3 => Theme.of(this).textTheme.labelLarge!;
}

extension ResultHandler<T> on Result<Failure, T> {
  T? success(BuildContext context) {
    if (isSuccess()) {
      return getSuccess();
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

  Widget display(String msg, [BuildContext? context, bool darkTheme = false]) {
    switch (this) {
      case MessageType.text:
        return Text(msg,
            style: darkTheme
                ? context!.p5.copyWith(fontSize: 16, color: whiteColor)
                : context!.p5.copyWith(fontSize: 16));
      case MessageType.video:
        return VideoPlayerItem(videoUrl: msg);
      default:
        return CachedNetworkImage(imageUrl: msg);
    }
  }

  Widget displayReply(String msg, [BuildContext? context]) {
    switch (this) {
      case MessageType.text:
        return Text(msg, style: context!.p2.copyWith(color: brownColor, fontSize: 14));
      case MessageType.video:
        return VideoPlayerItem(videoUrl: msg);
      default:
        return CachedNetworkImage(imageUrl: msg);
    }
  }
}
