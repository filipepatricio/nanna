import 'dart:math';

import 'package:flutter/material.dart';

enum DropCapMode {
  /// default
  inside,
  upwards,
  aside,

  /// Does not support dropCapPadding, indentation, dropCapPosition and custom dropCap.
  /// Try using DropCapMode.upwards in combination with dropCapPadding and forceNoDescent=true
  baseline
}

enum DropCapPosition {
  start,
  end,
}

class DropCap extends StatelessWidget {
  const DropCap({
    required this.child,
    required this.width,
    required this.height,
    super.key,
  });

  final Widget child;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: child);
  }
}

class DropCapText extends StatelessWidget {
  const DropCapText(
    this.data, {
    required this.style,
    required this.dropCap,
    this.mode = DropCapMode.inside,
    this.textAlign = TextAlign.start,
    this.dropCapPadding = EdgeInsets.zero,
    this.indentation = Offset.zero,
    this.forceNoDescent = false,
    this.textDirection = TextDirection.ltr,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.dropCapPosition,
    this.belowTextWidget,
    Key? key,
  }) : super(key: key);

  final String data;
  final DropCap dropCap;
  final DropCapMode mode;
  final TextStyle style;
  final TextAlign textAlign;
  final EdgeInsets dropCapPadding;
  final Offset indentation;
  final bool forceNoDescent;
  final TextDirection textDirection;
  final DropCapPosition? dropCapPosition;
  final int? maxLines;
  final TextOverflow overflow;
  final Widget? belowTextWidget;

  @override
  Widget build(BuildContext context) {
    final textStyle = style;

    if (data == '') return Text(data, style: textStyle);

    CrossAxisAlignment sideCrossAxisAlignment = CrossAxisAlignment.start;

    final capWidth = dropCap.width + dropCapPadding.left + dropCapPadding.right;
    final capHeight = dropCap.height + dropCapPadding.top + dropCapPadding.bottom;

    final textSpan = TextSpan(
      text: data,
      style: textStyle,
    );

    final textPainter = TextPainter(textDirection: textDirection, text: textSpan, textAlign: textAlign);
    final lineHeight = textPainter.preferredLineHeight;

    int rows = ((capHeight - indentation.dy) / lineHeight).ceil();

    // DROP CAP MODE - UPWARDS
    if (mode == DropCapMode.upwards) {
      rows = 1;
      sideCrossAxisAlignment = CrossAxisAlignment.end;
    }

    // BUILDER
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double boundsWidth = constraints.maxWidth - capWidth;
        if (boundsWidth < 1) boundsWidth = 1;

        int charIndexEnd = data.length;

        if (rows > 0) {
          textPainter.layout(maxWidth: boundsWidth);
          final yPos = rows * lineHeight;
          final charIndex = textPainter.getPositionForOffset(Offset(0, yPos)).offset;
          textPainter.maxLines = rows;
          textPainter.layout(maxWidth: boundsWidth);
          if (textPainter.didExceedMaxLines) charIndexEnd = charIndex;
        }

        // DROP CAP MODE - LEFT
        if (mode == DropCapMode.aside) charIndexEnd = data.length;

        final topString = data.substring(0, charIndexEnd);
        final bottomString = data.substring(min(charIndexEnd, data.length));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection: dropCapPosition == null || dropCapPosition == DropCapPosition.start
                  ? textDirection
                  : (textDirection == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr),
              crossAxisAlignment: sideCrossAxisAlignment,
              children: <Widget>[
                Padding(padding: dropCapPadding, child: dropCap),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.loose(
                          Size(
                            boundsWidth,
                            (lineHeight * min(maxLines ?? rows, rows)) + indentation.dy,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(top: indentation.dy),
                          child: Text(
                            topString,
                            overflow: (maxLines == null || (maxLines! > rows && overflow == TextOverflow.fade))
                                ? TextOverflow.clip
                                : overflow,
                            maxLines: maxLines,
                            textDirection: textDirection,
                            textAlign: textAlign,
                            style: textStyle,
                          ),
                        ),
                      ),
                      if (bottomString.isEmpty) belowTextWidget ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            if (maxLines == null && bottomString.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(left: indentation.dx),
                child: Text(
                  bottomString,
                  overflow: overflow,
                  maxLines: maxLines != null && maxLines! > rows ? maxLines! - rows : null,
                  textAlign: textAlign,
                  textDirection: textDirection,
                  style: textStyle,
                ),
              ),
              belowTextWidget ?? const SizedBox.shrink(),
            ]
          ],
        );
      },
    );
  }
}
