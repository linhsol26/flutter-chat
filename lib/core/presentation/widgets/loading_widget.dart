import 'package:flutter/material.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: LinearProgressIndicator(color: primaryColor),
    );
  }
}
