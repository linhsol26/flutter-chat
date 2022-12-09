import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:whatsapp_ui/auth/shared/providers.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class SenderGroupMessageCard extends HookConsumerWidget {
  const SenderGroupMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    this.senderId,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageType messageType;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageType repliedMessageType;
  final String? senderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;

    final sender = ref
        .watch(getUserByIdProvider(senderId!))
        .maybeWhen(data: (user) => user, orElse: () => null);

    return SwipeableTile.swipeToTrigger(
      isElevated: false,
      behavior: HitTestBehavior.deferToChild,
      key: UniqueKey(),
      color: Colors.white,
      direction: SwipeDirection.startToEnd,
      onSwiped: (_) => onRightSwipe(),
      backgroundBuilder: (_, SwipeDirection direction, AnimationController progress) {
        return AnimatedBuilder(
          animation: progress,
          builder: (_, __) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sender != null)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        sender.name,
                        textAlign: TextAlign.start,
                        style: context.sub1.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Card(
                    elevation: 1,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )),
                    color: greyColor,
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isReplying) ...[
                            gapH4,
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: subColor,
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
                                          child: const Icon(Icons.reply, size: 12),
                                        ),
                                        Text(
                                          username,
                                          style: context.sub1.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    gapH4,
                                    messageType.displayReply(repliedText, context),
                                  ],
                                )),
                            gapH8,
                          ],
                          messageType.display(message, context),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 4),
                    child: Text(date,
                        style: context.sub1.copyWith(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
