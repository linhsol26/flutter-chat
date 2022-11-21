import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:whatsapp_ui/auth/presentation/login_screen.dart';
import 'package:whatsapp_ui/core/domain/failure.dart';

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
