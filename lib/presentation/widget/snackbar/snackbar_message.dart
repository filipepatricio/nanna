import 'package:better_informed_mobile/exports.dart';
import 'package:flutter/material.dart';

class SnackbarMessage {
  SnackbarMessage._({
    required this.message,
    required this.type,
    this.subMessage,
    this.action,
  });

  factory SnackbarMessage.simple({
    required String message,
    required SnackbarMessageType type,
    String? subMessage,
    SnackbarAction? action,
  }) =>
      SnackbarMessage._(
        message: message,
        type: type,
        subMessage: subMessage,
        action: action,
      );

  factory SnackbarMessage.offline({
    String? message,
    String? subMessage,
    SnackbarAction? action,
  }) =>
      SnackbarMessage._(
        message: message ?? LocaleKeys.noConnection_snackbar_message.tr(),
        subMessage: subMessage ?? LocaleKeys.noConnection_snackbar_subMessage.tr(),
        type: SnackbarMessageType.info,
        action: action,
      );

  final String message;
  final SnackbarMessageType type;
  final String? subMessage;
  final SnackbarAction? action;
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
