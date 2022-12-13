import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

showSuccess(BuildContext context, [String msg = 'Successful!!!']) {
  // var snackBar = SnackBar(
  //   elevation: 0,
  //   behavior: SnackBarBehavior.floating,
  //   backgroundColor: Colors.transparent,
  //   content: AwesomeSnackbarContent(
  //     title: 'Congratulations!',
  //     message: msg,
  //     contentType: ContentType.success,
  //   ),
  // );

  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showError(BuildContext context, [String msg = 'Something went wrong.']) {
  var snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Oh My God!',
      message: msg,
      contentType: ContentType.failure,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showNoConnectionError(BuildContext context) {
  var snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Oh My God!',
      message: 'No Connection.',
      contentType: ContentType.help,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
