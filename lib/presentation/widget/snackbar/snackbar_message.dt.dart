import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snackbar_message.dt.freezed.dart';

@Freezed(toJson: false)
class SnackbarMessage with _$SnackbarMessage {
  factory SnackbarMessage.simple({
    required String message,
    required SnackbarMessageType type,
    String? subMessage,
    SnackbarAction? action,
  }) = _SnackbarMessageSimple;
}

enum SnackbarMessageType { info, success, warning, error, subscription }

class SnackbarAction {
  SnackbarAction({
    required this.label,
    required this.callback,
  });

  String label;
  VoidCallback callback;
}
