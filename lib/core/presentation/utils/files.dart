import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_ui/core/presentation/snackbar/snackbar.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showError(context);
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showError(context);
  }
  return video;
}

// 1SL1LoQo9eWOmjbYTBnbWShWo528i7Uo
Future<GiphyGif?> pickGif(BuildContext context) async {
  GiphyGif? pickedGif;
  try {
    pickedGif = await Giphy.getGif(context: context, apiKey: '1SL1LoQo9eWOmjbYTBnbWShWo528i7Uo');
  } catch (e) {
    showError(context);
  }
  return pickedGif;
}
