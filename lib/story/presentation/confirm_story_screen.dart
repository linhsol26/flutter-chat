import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_maker/story_maker.dart';

class ConfirmStoryScreen extends StatelessWidget {
  const ConfirmStoryScreen({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: StoryMaker(filePath: image.path));
  }
}
