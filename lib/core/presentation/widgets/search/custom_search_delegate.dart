import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class CustomSearchDelegate<T> extends SearchDelegate {
  final WidgetRef ref;

  CustomSearchDelegate(this.ref);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        );
  }
}
