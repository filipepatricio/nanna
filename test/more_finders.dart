import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension MoreFinders on CommonFinders {
  Finder byText(String text, {bool exactMatch = false}) => _ByTextFinder(text, exactMatch: exactMatch);
}

class _ByTextFinder extends MatchFinder {
  _ByTextFinder(this.text, {this.exactMatch = false, bool skipOffstage = true}) : super(skipOffstage: skipOffstage);

  final String text;
  final bool exactMatch;

  @override
  String get description => 'text "$text"';

  @override
  bool matches(Element candidate) {
    final widget = candidate.widget;
    if (widget is EditableText) {
      if (exactMatch) {
        return widget.controller.text == text;
      }
      return widget.controller.text.contains(text);
    } else if (widget is RichText) {
      final plainText = widget.text.toPlainText();
      if (exactMatch) {
        return plainText == text || plainText == text.withZeroWidthSpaces;
      }
      return plainText.contains(text) || plainText.contains(text.withZeroWidthSpaces);
    }
    return false;
  }
}

extension on String {
  String get withZeroWidthSpaces => Characters(this).toList().join('\u{200B}');
}
