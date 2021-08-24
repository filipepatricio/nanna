import 'dart:math';
import 'dart:ui';

import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomRichText extends HookWidget {
  final TextSpan textSpan;
  final bool selectable;

  const CustomRichText({
    required this.textSpan,
    this.selectable = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spans = useMemoized(() => textSpan.children ?? [textSpan], [textSpan]);

    return LayoutBuilder(
      builder: (context, size) => _CustomTextPainter(
        size: size,
        spans: spans,
        selectable: selectable,
      ),
    );
  }
}

class _CustomTextPainter extends HookWidget {
  final BoxConstraints size;
  final List<InlineSpan> spans;
  final bool selectable;

  const _CustomTextPainter({
    required this.size,
    required this.spans,
    required this.selectable,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final underlined = useMemoized(() {
      final underlined = <Offset>[];
      final computedSpans = <InlineSpan>[];
      var totalLength = 0.0;

      for (final span in spans) {
        computedSpans.add(span);

        final textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(children: computedSpans),
          textAlign: TextAlign.left,
        );
        textPainter.layout(maxWidth: size.maxWidth);

        final width = textPainter
            .computeLineMetrics()
            .map((lineMetrics) => lineMetrics.width)
            .reduce((value, element) => value + element);

        if (span.style?.decoration?.contains(TextDecoration.underline) == true) {
          final start = totalLength;
          final end = width;
          underlined.add(Offset(start, end));
        }

        totalLength = width;
      }

      return underlined;
    }, [size, spans]);

    final textPainter = useMemoized(() {
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(children: spans),
        textAlign: TextAlign.left,
      );

      textPainter.layout(maxWidth: size.maxWidth);

      return textPainter;
    }, [underlined]);

    final spansWithoutDecoration = useMemoized(() {
      return spans.map(
        (span) {
          if (span is TextSpan && span.style?.decoration?.contains(TextDecoration.underline) == true) {
            return TextSpan(
              text: span.text,
              style: span.style?.copyWith(decoration: TextDecoration.none),
            );
          }

          return span;
        },
      ).toList();
    }, [spans]);

    return CustomPaint(
      size: textPainter.size,
      painter: _CustomHighlightTextPainter(textPainter, underlined),
      child: selectable
          ? SelectableText.rich(
              TextSpan(children: spansWithoutDecoration),
            )
          : RichText(
              text: TextSpan(children: spansWithoutDecoration),
            ),
    );
  }
}

class _CustomHighlightTextPainter extends CustomPainter {
  final TextPainter textPainter;
  final List<Offset> offsets;

  _CustomHighlightTextPainter(this.textPainter, this.offsets);

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
      ..moveTo(startPos - 2, line.height * 0.60 + _calculateBaselineOffset(line))
      ..lineTo(endPos * 1.0, line.height * 0.55 + _calculateBaselineOffset(line))
      ..lineTo(endPos * 1.01, line.height * 0.95 + _calculateBaselineOffset(line))
      ..lineTo(startPos, line.height * 0.92 + _calculateBaselineOffset(line))
      ..close();

    if (_isVisualGlitch(path)) {
      return;
    }

    canvas.drawPath(path, Paint()..color = AppColors.limeGreen);
  }

  double _calculateBaselineOffset(LineMetrics line) => line.baseline + line.descent - line.height;

  bool _isVisualGlitch(Path path) => path.getBounds().width < 3.0;
}
