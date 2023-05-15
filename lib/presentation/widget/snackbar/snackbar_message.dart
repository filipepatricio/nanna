import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@Freezed(toJson: false)
class SnackbarMessage {
  SnackbarMessage._({
    required this.type,
    this.message,
    this.subMessage,
    this.action,
    this.child,
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

  factory SnackbarMessage.offline(
    BuildContext context, {
    SnackbarAction? action,
  }) =>
      SnackbarMessage._(
        message: context.l10n.noConnection_snackbar_message,
        subMessage: context.l10n.noConnection_snackbar_subMessage,
        type: SnackbarMessageType.info,
        action: action,
      );

  factory SnackbarMessage.error(BuildContext context) => SnackbarMessage._(
        message: context.l10n.common_error_tryAgainLater,
        type: SnackbarMessageType.error,
      );

  factory SnackbarMessage.guest(BuildContext context) => SnackbarMessage._(
        message: context.l10n.guest_signIn_snackbar_message,
        subMessage: context.l10n.guest_signIn_snackbar_subMessage,
        type: SnackbarMessageType.info,
        action: SnackbarAction(
          label: context.l10n.guest_signIn_error_action,
          callback: () => context.pushRoute(const SignInPageModal()),
        ),
      );

  factory SnackbarMessage.custom({
    required Widget child,
  }) =>
      SnackbarMessage._(
        type: SnackbarMessageType.info,
        child: child,
      );

  final String? message;
  final Widget? child;
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
