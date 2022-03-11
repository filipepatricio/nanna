import 'dart:math';
import 'dart:ui';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/util/custom_hooks.dart';
import 'package:better_informed_mobile/presentation/util/selection_controller_bundle.dart';
import 'package:better_informed_mobile/presentation/widget/informed_selectable_text.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/platform_text_selection_controls.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart' hide SelectableText;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

typedef ShareTextCallback = Function(String text);

class InformedRichText extends HookWidget implements RichTextBase {
  @override
  final TextSpan textSpan;

  final bool selectable;
  final Color highlightColor;
  final TextAlign textAlign;
  final int? maxLines;
  final ShareTextCallback? shareCallback;
  final SelectionControllerBundle? selectionControllers;

  const InformedRichText({
    required this.textSpan,
    required this.highlightColor,
    this.textAlign = TextAlign.start,
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
    this.maxLines,
    this.shareCallback,
    Key? key,
  })  : selectable = true,
        super(key: key);

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
      ),
    );
  }
}

class _CustomTextPainter extends HookWidget {
  final BoxConstraints size;
  final List<InlineSpan> spans;
  final bool selectable;
  final Color highlightColor;
  final TextAlign textAlign;
  final int? maxLines;
  final ShareTextCallback? shareCallback;
  final SelectionControllerBundle? selectionControllers;

  const _CustomTextPainter({
    required this.size,
    required this.spans,
    required this.selectable,
    required this.highlightColor,
    required this.textAlign,
    this.maxLines,
    this.shareCallback,
    this.selectionControllers,
    Key? key,
  })  : assert(selectable && selectionControllers != null || !selectable),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final underlined = useMemoized(
      () => _computeUnderlinedOffsets().toList(growable: false),
      [size, spans],
    );

    final textPainter = useMemoized(
      () {
        final textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(children: spans),
          textAlign: textAlign,
          maxLines: maxLines,
        );

        textPainter.layout(maxWidth: size.maxWidth);

        return textPainter;
      },
      [underlined],
    );

    final spansWithoutDecoration = useMemoized(
      () {
        return spans.map(
          (span) {
            if (span is TextSpan && _isHighlighted(span)) {
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
      painter: _CustomHighlightTextPainter(
        textPainter,
        underlined,
        highlightColor,
      ),
      child: selectable
          ? InformedSelectableText.rich(
              TextSpan(children: spansWithoutDecoration),
              controller: controller,
              maxLines: maxLines,
              textAlign: textAlign,
              selectionControls: createPlatformSpecific(
                [
                  shareControlData(
                    tr(LocaleKeys.common_share),
                    shareCallback,
                  ),
                ],
              ),
              onSelectionChanged: (_, __) => selectionControllers?.unselectAllBut(controller.key),
            )
          : RichText(
              maxLines: maxLines,
              text: TextSpan(children: spansWithoutDecoration),
              overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
              textAlign: textAlign,
            ),
    );
  }

  Iterable<Offset> _computeUnderlinedOffsets() sync* {
    final computedSpans = <InlineSpan>[];

    for (final span in spans) {
      if (_isHighlighted(span)) {
        final startWidth = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(children: computedSpans),
          textAlign: textAlign,
          maxLines: maxLines,
        );
        startWidth.layout(maxWidth: size.maxWidth);
        final startPosition = _computeTextWidth(startWidth);

        computedSpans.add(span);

        final endWidth = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(children: computedSpans),
          textAlign: textAlign,
          maxLines: maxLines,
        );
        endWidth.layout(maxWidth: size.maxWidth);
        final endPosition = _computeTextWidth(endWidth);

        yield Offset(startPosition, endPosition);
      } else {
        computedSpans.add(span);
      }
    }
  }

  bool _isHighlighted(InlineSpan span) => span.style?.fontStyle == FontStyle.italic;

  TextSpan _modifyHighlightedText(TextSpan span) {
    return TextSpan(
      text: span.text,
      style: span.style?.copyWith(fontStyle: FontStyle.normal),
    );
  }

  double _computeTextWidth(TextPainter textPainter) {
    return textPainter
        .computeLineMetrics()
        .map((lineMetrics) => lineMetrics.width)
        .reduce((value, element) => value + element);
  }
}

class _CustomHighlightTextPainter extends CustomPainter {
  final TextPainter textPainter;
  final List<Offset> offsets;
  final Color highlightColor;

  _CustomHighlightTextPainter(this.textPainter, this.offsets, this.highlightColor);

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
      ..moveTo(line.left + startPos - 2, line.height * 0.30 + _calculateBaselineOffset(line))
      ..lineTo(line.left + endPos - 3, line.height * 0.35 + _calculateBaselineOffset(line))
      ..lineTo(line.left + endPos, line.height * 0.95 + _calculateBaselineOffset(line))
      ..lineTo(line.left + startPos + 2, line.height * 0.92 + _calculateBaselineOffset(line))
      ..close();

    if (_isVisualGlitch(path)) {
      return;
    }

    canvas.drawPath(path, Paint()..color = highlightColor);
  }

  double _calculateBaselineOffset(LineMetrics line) => line.baseline + line.descent - line.height;

  bool _isVisualGlitch(Path path) => path.getBounds().width < 3.0;
}
