import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class MyMessageCard extends HookConsumerWidget {
  final String message;
  final String date;
  final MessageType messageType;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageType repliedMessageType;
  final bool isSeen;
  final VoidCallback onHover;
  final bool isGroup;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.messageType,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      required this.isSeen,
      this.isGroup = false,
      required this.onHover})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;

    final me = ref.watch(currentUserStreamProvider).whenData((value) => value?.name).value;

    return SwipeableTile.swipeToTrigger(
      isElevated: false,
      behavior: HitTestBehavior.deferToChild,
      key: UniqueKey(),
      color: Theme.of(context).scaffoldBackgroundColor,
      onSwiped: (_) => onLeftSwipe(),
      backgroundBuilder: (_, SwipeDirection direction, AnimationController progress) {
        return AnimatedBuilder(
          animation: progress,
          builder: (_, __) {
            return Container(
              alignment: Alignment.centerRight,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Transform.scale(
                  scale: Tween<double>(begin: 0.0, end: 1.2)
                      .animate(
                        CurvedAnimation(
                          parent: progress,
                          curve: const Interval(0.5, 1.0, curve: Curves.bounceInOut),
                        ),
                      )
                      .value,
                  child: Icon(
                    Icons.reply,
                    color: primaryColor.withOpacity(0.7),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: GestureDetector(
        onLongPress: () => onHover.call(),
        child: Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Card(
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )),
                  color: primaryColor,
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isReplying) ...[
                          gapH4,
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: greyColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Transform.rotate(
                                      angle: pi,
                                      child: const Icon(
                                        Icons.reply,
                                        size: 12,
                                        color: blackColor,
                                      ),
                                    ),
                                    Text(
                                      me == username ? 'You' : username,
                                      style: context.sub1.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                gapH4,
                                messageType.displayReply(repliedText, context),
                              ],
                            ),
                          ),
                          gapH8,
                        ],
                        messageType.display(message, context),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(date,
                          style: context.sub1.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(width: 5),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 20,
                        color: isSeen ? primaryColor : primaryColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
