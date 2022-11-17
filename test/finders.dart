import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

extension Finders on CommonFinders {
  Finder byText(
    String text, {
    bool exactMatch = false,
    bool skipOffstage = true,
  }) {
    return _ByTextFinder(
      text,
      exactMatch: exactMatch,
      skipOffstage: skipOffstage,
    );
  }

  Finder bySvgAssetName(
    String assetName, {
    bool skipOffstage = true,
  }) {
    return _SvgFinder(
      assetName,
      skipOffstage: skipOffstage,
    );
  }
}

class _ByTextFinder extends MatchFinder {
  _ByTextFinder(
    this.text, {
    this.exactMatch = false,
    bool skipOffstage = true,
  }) : super(skipOffstage: skipOffstage);

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

class _SvgFinder extends MatchFinder {
  _SvgFinder(
    this.assetName, {
    bool skipOffstage = true,
  }) : super(skipOffstage: skipOffstage);

  final String assetName;

  @override
  String get description => 'svg asset $assetName';

  @override
  bool matches(Element candidate) {
    final widget = candidate.widget;

    if (widget is SvgPicture) {
      final provider = widget.pictureProvider;

      if (provider is ExactAssetPicture) {
        return provider.assetName == assetName;
      }
    }

    return false;
  }
}

extension on String {
  String get withZeroWidthSpaces => Characters(this).toList().join('\u{200B}');
}
