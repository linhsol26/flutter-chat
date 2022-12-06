import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/utils/sizes.dart';
import 'package:whatsapp_ui/core/shared/enums.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageType messageType;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageType repliedMessageType;
  final bool isSeen;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.messageType,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      required this.isSeen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
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
                        Text(
                          username,
                          style: context.sub1.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        gapH4,
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: greyColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: messageType.displayReply(repliedText, context)),
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
                          color: Colors.black,
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
    );
  }
}
