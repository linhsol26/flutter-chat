import 'package:flutter/material.dart';

mixin DismissKeyboard {
  dismiss() => FocusManager.instance.primaryFocus?.unfocus();
}
