import 'package:better_informed_mobile/exports.dart' hide TextDirection;
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/custom_hooks.dart';
import 'package:better_informed_mobile/presentation/util/platform_util.dart';
import 'package:better_informed_mobile/presentation/util/selection_controller_bundle.dart';
import 'package:better_informed_mobile/presentation/widget/informed_selectable_text.dart';
import 'package:better_informed_mobile/presentation/widget/text_selection_controls/platform_text_selection_controls.dart';
import 'package:flutter/foundation.dart';
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

    return selectable
        ? InformedSelectableText.rich(
            TextSpan(children: spansWithoutDecoration),
            controller: controller,
            maxLines: maxLines,
            textAlign: textAlign,
            selectionControls: createPlatformSpecific(
              [
                shareControlData(tr(LocaleKeys.common_share), shareCallback),
                if (defaultTargetPlatform.isApple) lookUpControlData(tr(LocaleKeys.common_lookUp)),
              ],
            ),
            onSelectionChanged: (_, __) => selectionControllers?.unselectAllBut(controller.key),
          )
        : Text.rich(
            TextSpan(children: spansWithoutDecoration),
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
            textAlign: textAlign,
          );
  }

  bool _isHighlighted(InlineSpan span) => span.style?.fontStyle == FontStyle.italic;

  TextSpan _modifyHighlightedText(TextSpan span) {
    return TextSpan(
      text: span.text,
      style: span.style?.copyWith(
        fontStyle: FontStyle.normal,
        color: AppColors.light.textPrimary,
        backgroundColor: highlightColor,
      ),
    );
  }
}
