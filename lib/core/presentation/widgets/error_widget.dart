import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    Key? key,
    this.msg,
  }) : super(key: key);

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      msg ?? 'Something went wrong.',
      style: const TextStyle(color: Colors.white),
    ));
  }
}
