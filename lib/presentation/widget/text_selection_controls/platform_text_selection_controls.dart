import 'package:better_informed_mobile/presentation/util/platform_util.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/cupertino_text_selection_controls.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/material_text_selection_controls.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/text_selection_control_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

TextSelectionControls createPlatformSpecific(List<DelegateTextSelectionControlData> controls) {
  if (defaultTargetPlatform.isApple) {
    return CupertinoTextSelectionControls(controls);
  }

  return MaterialTextSelectionControls(controls);
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

      delegate.hideToolbar();
      status?.update();

      onShare(text);
    },
    (delegate) => !delegate.textEditingValue.selection.isCollapsed,
  );
}

DelegateTextSelectionControlData lookUpControlData(String label) {
  Future<void> onLookUp(selected) {
    return const MethodChannel('so.informed.internal').invokeMethod<String>('lookUp', selected);
  }

  return DelegateTextSelectionControlData(
    label,
    (delegate, status) {
      final fullText = delegate.textEditingValue.text;
      final text = delegate.textEditingValue.selection.textInside(fullText);

      delegate.hideToolbar();
      status?.update();

      onLookUp(text);
    },
    (delegate) => !delegate.textEditingValue.selection.isCollapsed,
  );
}
