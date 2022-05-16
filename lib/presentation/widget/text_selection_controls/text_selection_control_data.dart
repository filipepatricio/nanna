import 'package:flutter/widgets.dart';

typedef TextSelectionDelegateAction = Function(
  TextSelectionDelegate delegate,
  ClipboardStatusNotifier? clipboardStatus,
);

typedef TextSelectionControlValidator = bool Function(
  TextSelectionDelegate delegate,
);

class TextSelectionControlData {
  TextSelectionControlData(this.label, this.action);

  final String label;
  final VoidCallback action;
}

class DelegateTextSelectionControlData {
  DelegateTextSelectionControlData(
    this.label,
    this.action,
    this.validator,
  );

  final String label;
  final TextSelectionDelegateAction action;
  final TextSelectionControlValidator validator;
}

extension DelegateTextSelectionControlDataExtension on List<DelegateTextSelectionControlData> {
  List<TextSelectionControlData> mapToSelectionData(
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier? clipboardStatus,
  ) {
    return where((element) => element.validator(delegate))
        .map(
          (control) => TextSelectionControlData(
            control.label,
            () => control.action(delegate, clipboardStatus),
          ),
        )
        .toList();
  }
}
