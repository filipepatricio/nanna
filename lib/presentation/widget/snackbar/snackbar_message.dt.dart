import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snackbar_message.dt.freezed.dart';

@freezed
class SnackbarMessage with _$SnackbarMessage {
  factory SnackbarMessage.simple({
    required String message,
    required SnackbarMessageType type,
    SnackbarAction? action,
  }) = _SnackbarMessageSimple;

  factory SnackbarMessage.custom({
    required Widget message,
    required SnackbarMessageType type,
  }) = _SnackbarMessageCustom;
}

enum SnackbarMessageType { positive, negative, informative }

class SnackbarAction {
  SnackbarAction({
    required this.label,
    required this.callback,
  });

  String label;
  VoidCallback callback;
}
