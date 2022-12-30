import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:better_informed_mobile/exports.dart' hide TextDirection;
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/custom_hooks.dart';
import 'package:better_informed_mobile/presentation/util/selection_controller_bundle.dart';
import 'package:better_informed_mobile/presentation/util/string_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_selectable_text.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/platform_text_selection_controls.dart';
import 'package:flutter/material.dart' hide SelectableText;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

typedef ShareTextCallback = Function(String text);

class InformedRichText extends HookWidget implements RichTextBase {
  const InformedRichText({
    required this.textSpan,
    required this.highlightColor,
    this.textAlign = TextAlign.start,
    this.useTextHighlight = true,
    this.maxLines,
    this.shareCallback,
    Key? key,
  })  : selectable = false,
        selectionControllers = null,
        super(key: key);

  const InformedRichText.selectable({
    required this.textSpan,
    required this.highlightColor,
    required this.selectionControllers,
    this.textAlign = TextAlign.start,
    this.useTextHighlight = true,
    this.maxLines,
    this.shareCallback,
    Key? key,
  })  : selectable = true,
        super(key: key);

  @override
  final TextSpan textSpan;

  final bool selectable;
  final bool useTextHighlight;
  final Color highlightColor;
  final TextAlign textAlign;
  final int? maxLines;
  final ShareTextCallback? shareCallback;
  final SelectionControllerBundle? selectionControllers;

  @override
  Widget build(BuildContext context) {
    final spans = useMemoized(() => textSpan.children ?? [textSpan], [textSpan]);

    return LayoutBuilder(
      builder: (context, size) => _CustomTextPainter(
        size: size,
        spans: spans,
        selectable: selectable,
        highlightColor: highlightColor,
        maxLines: maxLines,
        textAlign: textAlign,
        shareCallback: shareCallback,
        selectionControllers: selectionControllers,
        useTextHighlight: useTextHighlight,
      ),
    );
  }
}

class _CustomTextPainter extends HookWidget {
  const _CustomTextPainter({
    required this.size,
    required this.spans,
    required this.selectable,
    required this.highlightColor,
    required this.textAlign,
    this.maxLines,
    this.shareCallback,
    this.selectionControllers,
    this.useTextHighlight = true,
    Key? key,
  })  : assert(selectable && selectionControllers != null || !selectable),
        super(key: key);

  final BoxConstraints size;
  final List<InlineSpan> spans;
  final bool selectable;
  final bool useTextHighlight;
  final Color highlightColor;
  final TextAlign textAlign;
  final int? maxLines;
  final ShareTextCallback? shareCallback;
  final SelectionControllerBundle? selectionControllers;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final underlined = useMemoized(
      () => _computeUnderlinedOffsets(textScaleFactor).toList(growable: false),
      [size, spans, textScaleFactor],
    );

    final textPainter = useMemoized(
      () {
        final textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(children: spans),
          textAlign: textAlign,
          maxLines: maxLines,
          textScaleFactor: textScaleFactor,
        );

        textPainter.layout(maxWidth: size.maxWidth);

        return textPainter;
      },
      [underlined, textScaleFactor],
    );

    final spansWithoutDecoration = useMemoized(
      () {
        return spans.map(
          (span) {
            if (useTextHighlight && span is TextSpan && _isHighlighted(span)) {
              return _modifyHighlightedText(span);
            }

            return span;
          },
        ).toList();
      },
      [spans],
    );

    final controller = useTextSpanEditingController(
      key: Key('${spansWithoutDecoration.hashCode}'),
      textSpan: TextSpan(children: spansWithoutDecoration),
    );
    selectionControllers?.add(controller);

    return CustomPaint(
      size: textPainter.size,
      painter: useTextHighlight
          ? _CustomHighlightTextPainter(
              textPainter,
              underlined,
              highlightColor,
            )
          : null,
      child: selectable
          ? InformedSelectableText.rich(
              TextSpan(children: spansWithoutDecoration),
              controller: controller,
              maxLines: maxLines,
              textAlign: textAlign,
              selectionControls: createPlatformSpecific(
                [
                  shareControlData(tr(LocaleKeys.common_share), shareCallback),
                  if (Platform.isIOS) lookUpControlData(tr(LocaleKeys.common_lookUp)),
                ],
              ),
              onSelectionChanged: (_, __) => selectionControllers?.unselectAllBut(controller.key),
            )
          : Text.rich(
              TextSpan(children: spansWithoutDecoration),
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
              textAlign: textAlign,
            ),
    );
  }

  Iterable<Offset> _computeUnderlinedOffsets(double textScaleFactor) sync* {
    final computedSpans = <InlineSpan>[];

    for (final span in spans) {
      if (_isHighlighted(span)) {
        final List<InlineSpan> startSpans = _getStartSpans(computedSpans);

        final startWidth = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(children: startSpans),
          textAlign: textAlign,
          maxLines: maxLines,
          textScaleFactor: textScaleFactor,
        );
        startWidth.layout(maxWidth: size.maxWidth);
        final startPosition = _computeTextWidth(startWidth);

        computedSpans.add(span);

        final endWidth = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(children: computedSpans),
          textAlign: textAlign,
          maxLines: maxLines,
          textScaleFactor: textScaleFactor,
        );
        endWidth.layout(maxWidth: size.maxWidth);
        final endPosition = _computeTextWidth(endWidth);

        yield Offset(startPosition, endPosition);
      } else {
        computedSpans.add(span);
      }
    }
  }

  List<InlineSpan> _getStartSpans(List<InlineSpan> computedSpans) {
    if (computedSpans.isNotEmpty) {
      final lastSpan = computedSpans.last;
      final spanText = lastSpan.toPlainText();

      if (spanText.endsWithWhiteSpace) {
        final string = spanText[spanText.length - 1];
        final whiteSpaceSpan = TextSpan(
          text: string,
          style: lastSpan.style,
        );
        return [whiteSpaceSpan, ...computedSpans];
      }
    }

    return computedSpans;
  }

  bool _isHighlighted(InlineSpan span) => span.style?.fontStyle == FontStyle.italic;

  TextSpan _modifyHighlightedText(TextSpan span) {
    return TextSpan(
      text: span.text,
      style: span.style?.copyWith(
        fontStyle: FontStyle.normal,
        color: AppColors.brandPrimary,
      ),
    );
  }

  double _computeTextWidth(TextPainter textPainter) {
    final widths = textPainter.computeLineMetrics().map((lineMetrics) => lineMetrics.width);
    return widths.isEmpty ? 0.0 : widths.reduce((value, element) => value + element);
  }
}

class _CustomHighlightTextPainter extends CustomPainter {
  _CustomHighlightTextPainter(this.textPainter, this.offsets, this.highlightColor) : _paint = Paint() {
    _paint.color = highlightColor;
  }

  final TextPainter textPainter;
  final List<Offset> offsets;
  final Color highlightColor;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final lines = textPainter.computeLineMetrics();

    var totalWidth = 0.0;

    for (final line in lines) {
      for (final offset in offsets) {
        if (offset.dx >= totalWidth && offset.dx <= totalWidth + line.width) {
          final startPos = offset.dx - totalWidth;
          final endPos = min(line.width, startPos + (offset.dy - offset.dx));

          _paintHighlight(startPos, line, endPos, canvas);
        } else if (offset.dx <= totalWidth + line.width &&
            offset.dy >= totalWidth &&
            offset.dy >= totalWidth + line.width) {
          const startPos = 0.0;
          final endPos = line.width;

          _paintHighlight(startPos, line, endPos, canvas);
        } else if (offset.dx <= totalWidth + line.width && offset.dy >= totalWidth) {
          const startPos = 0.0;
          final endPos = offset.dy - totalWidth;

          _paintHighlight(startPos, line, endPos, canvas);
        }
      }

      totalWidth += line.width;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _paintHighlight(double startPos, LineMetrics line, double endPos, Canvas canvas) {
    final path = Path()
      ..moveTo(line.left + startPos - 2, line.height * 0.15 + _calculateBaselineOffset(line))
      ..lineTo(line.left + endPos + 2, line.height * 0.15 + _calculateBaselineOffset(line))
      ..lineTo(line.left + endPos + 2, line.height * 0.95 + _calculateBaselineOffset(line))
      ..lineTo(line.left + startPos - 2, line.height * 0.95 + _calculateBaselineOffset(line))
      ..close();

    canvas.drawPath(path, _paint);
  }

  double _calculateBaselineOffset(LineMetrics line) => line.baseline + line.descent - line.height;
}
