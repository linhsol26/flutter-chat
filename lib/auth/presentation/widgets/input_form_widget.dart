import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';

class InputFormWidget extends HookWidget {
  const InputFormWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.inputType,
    this.validator,
    this.onFieldSubmitted,
    this.action = 'done',
  });

  final TextEditingController controller;
  final String label;
  final InputType inputType;
  final String action;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final node = useMemoized(() => FocusNode());

    return TextFormField(
      controller: controller,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: true,
      focusNode: node,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      textAlign: TextAlign.left,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Type your ${label.toLowerCase()}...',
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        errorStyle: const TextStyle(fontSize: 14, color: Colors.red),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      obscureText: inputType == InputType.password,
      textInputAction: action.textInputAction,
      validator: validator ?? inputType.validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

enum InputType { email, password, text, number, confirmPassword }

extension ValidatorX on InputType {
  String? Function(String?) get validator {
    switch (this) {
      case InputType.email:
        return ValidationBuilder()
            .required('Please enter email address.')
            .email('Invalid email address.')
            .maxLength(100, 'Email address is too long.')
            .build();

      case InputType.password:
        return ValidationBuilder()
            .required('Please enter password.')
            .minLength(8, 'Password must have at least 8 characters.')
            .build();
      case InputType.number:
        return ValidationBuilder()
            .required('Please enter phone number.')
            .phone('Invalid phone number.')
            .minLength(10, 'Phone must have 10 numbers.')
            .maxLength(10, 'Phone must have 10 numbers.')
            .build();
      default:
        return ValidationBuilder().required('Cannot empty.').build();
    }
  }
}

extension TextInputActionEx on String {
  TextInputAction get textInputAction {
    switch (this) {
      case 'next':
        return TextInputAction.next;
      case 'go':
        return TextInputAction.go;
      default:
        return TextInputAction.done;
    }
  }
}
