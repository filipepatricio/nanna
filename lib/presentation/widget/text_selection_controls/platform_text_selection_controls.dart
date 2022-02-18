import 'dart:io';

import 'package:better_informed_mobile/presentation/widget/text_selection_controls/cupertino_text_selection_controls.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/material_text_selection_controls.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/text_selection_control_data.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

TextSelectionControls createPlatformSpecific(List<DelegateTextSelectionControlData> controls) {
  if (Platform.isAndroid) {
    return MaterialTextSelectionControls(controls);
  } else if (Platform.isIOS) {
    return CupertinoTextSelectionControls(controls);
  }

  throw Exception('Unhandled platform');
}

DelegateTextSelectionControlData shareControlData(
  String label, [
  Function(String text)? shareCallback,
]) {
  final onShare = shareCallback ?? (text) => Share.share(text);

  return DelegateTextSelectionControlData(
    label,
    (delegate, status) {
      final fullText = delegate.textEditingValue.text;
      final text = delegate.textEditingValue.selection.textInside(fullText);

      delegate.userUpdateTextEditingValue(TextEditingValue.empty, SelectionChangedCause.toolbar);
      delegate.hideToolbar();
      status?.update();

      onShare(text);
    },
    (delegate) => !delegate.textEditingValue.selection.isCollapsed,
  );
}
