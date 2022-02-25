// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:better_informed_mobile/presentation/widget/text_selection_controls/text_selection_control_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// Read off from the output on iOS 12. This color does not vary with the
// application's theme color.
const double _kSelectionHandleOverlap = 1.5;
// Extracted from https://developer.apple.com/design/resources/.
const double _kSelectionHandleRadius = 6;

// Minimal padding from tip of the selection toolbar arrow to horizontal edges of the
// screen. Eyeballed value.
const double _kArrowScreenPadding = 26.0;

// Generates the child that's passed into CupertinoTextSelectionToolbar.
class _CupertinoTextSelectionControlsToolbar extends StatefulWidget {
  const _CupertinoTextSelectionControlsToolbar({
    required this.clipboardStatus,
    required this.endpoints,
    required this.globalEditableRegion,
    required this.selectionMidpoint,
    required this.textLineHeight,
    required this.controls,
    Key? key,
  }) : super(key: key);

  final ClipboardStatusNotifier? clipboardStatus;
  final List<TextSelectionPoint> endpoints;
  final Rect globalEditableRegion;
  final Offset selectionMidpoint;
  final double textLineHeight;
  final List<TextSelectionControlData> controls;

  @override
  _CupertinoTextSelectionControlsToolbarState createState() => _CupertinoTextSelectionControlsToolbarState();
}

class _CupertinoTextSelectionControlsToolbarState extends State<_CupertinoTextSelectionControlsToolbar> {
  ClipboardStatusNotifier? _clipboardStatus;

  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void didUpdateWidget(_CupertinoTextSelectionControlsToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clipboardStatus != widget.clipboardStatus) {
      if (_clipboardStatus != null) {
        _clipboardStatus!.removeListener(_onChangedClipboardStatus);
        _clipboardStatus!.dispose();
      }
      _clipboardStatus = widget.clipboardStatus ?? ClipboardStatusNotifier();
      _clipboardStatus!.addListener(_onChangedClipboardStatus);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // When used in an Overlay, this can be disposed after its creator has
    // already disposed _clipboardStatus.
    if (_clipboardStatus != null && !_clipboardStatus!.disposed) {
      _clipboardStatus!.removeListener(_onChangedClipboardStatus);
      if (widget.clipboardStatus == null) {
        _clipboardStatus!.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controls.isEmpty) {
      return const SizedBox.shrink();
    }

    assert(debugCheckHasMediaQuery(context));
    final mediaQuery = MediaQuery.of(context);

    // The toolbar should appear below the TextField when there is not enough
    // space above the TextField to show it, assuming there's always enough
    // space at the bottom in this case.
    final anchorX = (widget.selectionMidpoint.dx + widget.globalEditableRegion.left).clamp(
      _kArrowScreenPadding + mediaQuery.padding.left,
      mediaQuery.size.width - mediaQuery.padding.right - _kArrowScreenPadding,
    );

    // The y-coordinate has to be calculated instead of directly quoting
    // selectionMidpoint.dy, since the caller
    // (TextSelectionOverlay._buildToolbar) does not know whether the toolbar is
    // going to be facing up or down.
    final anchorAbove = Offset(
      anchorX,
      widget.endpoints.first.point.dy - widget.textLineHeight + widget.globalEditableRegion.top,
    );
    final anchorBelow = Offset(
      anchorX,
      widget.endpoints.last.point.dy + widget.globalEditableRegion.top,
    );

    final items = <Widget>[];
    final Widget onePhysicalPixelVerticalDivider = SizedBox(width: 1.0 / MediaQuery.of(context).devicePixelRatio);

    void addToolbarButton(
      TextSelectionControlData control,
    ) {
      if (items.isNotEmpty) {
        items.add(onePhysicalPixelVerticalDivider);
      }

      items.add(
        CupertinoTextSelectionToolbarButton.text(
          onPressed: control.action,
          text: control.label,
        ),
      );
    }

    widget.controls.forEach(addToolbarButton);

    // If there is no option available, build an empty widget.
    if (items.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return CupertinoTextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      children: items,
    );
  }
}

/// Draws a single text selection handle with a bar and a ball.
class _TextSelectionHandlePainter extends CustomPainter {
  const _TextSelectionHandlePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const halfStrokeWidth = 1.0;
    final paint = Paint()..color = color;
    final circle = Rect.fromCircle(
      center: const Offset(_kSelectionHandleRadius, _kSelectionHandleRadius),
      radius: _kSelectionHandleRadius,
    );
    final line = Rect.fromPoints(
      const Offset(
        _kSelectionHandleRadius - halfStrokeWidth,
        2 * _kSelectionHandleRadius - _kSelectionHandleOverlap,
      ),
      Offset(_kSelectionHandleRadius + halfStrokeWidth, size.height),
    );
    final path = Path()
      ..addOval(circle)
      // Draw line so it slightly overlaps the circle.
      ..addRect(line);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TextSelectionHandlePainter oldPainter) => color != oldPainter.color;
}

/// iOS Cupertino styled text selection controls.
class CupertinoTextSelectionControls extends TextSelectionControls {
  CupertinoTextSelectionControls(this.controlList);

  final List<DelegateTextSelectionControlData> controlList;

  /// Returns the size of the Cupertino handle.
  @override
  Size getHandleSize(double textLineHeight) {
    return Size(
      _kSelectionHandleRadius * 2,
      textLineHeight + _kSelectionHandleRadius * 2 - _kSelectionHandleOverlap,
    );
  }

  /// Builder for iOS-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    final localizations = CupertinoLocalizations.of(context);
    final additionalControls = controlList.mapToSelectionData(delegate, clipboardStatus);

    return _CupertinoTextSelectionControlsToolbar(
      clipboardStatus: clipboardStatus,
      endpoints: endpoints,
      globalEditableRegion: globalEditableRegion,
      selectionMidpoint: selectionMidpoint,
      textLineHeight: textLineHeight,
      controls: [
        if (canCut(delegate))
          TextSelectionControlData(
            localizations.cutButtonLabel,
            () => handleCut(delegate, clipboardStatus),
          ),
        if (canCopy(delegate))
          TextSelectionControlData(
            localizations.copyButtonLabel,
            () => handleCopy(delegate, clipboardStatus),
          ),
        if (canSelectAll(delegate))
          TextSelectionControlData(
            localizations.selectAllButtonLabel,
            () => handleSelectAll(delegate),
          ),
        ...additionalControls,
      ],
    );
  }

  /// Builder for iOS text selection edges.
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    // iOS selection handles do not respond to taps.

    // We want a size that's a vertical line the height of the text plus a 18.0
    // padding in every direction that will constitute the selection drag area.
    final finalStartGlyphHeight = startGlyphHeight ?? textLineHeight;
    final finalEndGlyphHeight = endGlyphHeight ?? textLineHeight;

    final Size desiredSize;
    final Widget handle;

    final Widget customPaint = CustomPaint(
      painter: _TextSelectionHandlePainter(CupertinoTheme.of(context).primaryColor),
    );

    // [buildHandle]'s widget is positioned at the selection cursor's bottom
    // baseline. We transform the handle such that the SizedBox is superimposed
    // on top of the text selection endpoints.
    switch (type) {
      case TextSelectionHandleType.left:
        desiredSize = getHandleSize(finalStartGlyphHeight);
        handle = SizedBox.fromSize(
          size: desiredSize,
          child: customPaint,
        );
        return handle;
      case TextSelectionHandleType.right:
        desiredSize = getHandleSize(finalEndGlyphHeight);
        handle = SizedBox.fromSize(
          size: desiredSize,
          child: customPaint,
        );
        return Transform(
          transform: Matrix4.identity()
            ..translate(desiredSize.width / 2, desiredSize.height / 2)
            ..rotateZ(math.pi)
            ..translate(-desiredSize.width / 2, -desiredSize.height / 2),
          child: handle,
        );
      // iOS doesn't draw anything for collapsed selections.
      case TextSelectionHandleType.collapsed:
        return const SizedBox();
    }
  }

  /// Gets anchor for cupertino-style text selection handles.
  ///
  /// See [TextSelectionControls.getHandleAnchor].
  @override
  Offset getHandleAnchor(
    TextSelectionHandleType type,
    double textLineHeight, [
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    final finalStartGlyphHeight = startGlyphHeight ?? textLineHeight;
    final finalEndGlyphHeight = endGlyphHeight ?? textLineHeight;

    final Size handleSize;

    switch (type) {
      // The circle is at the top for the left handle, and the anchor point is
      // all the way at the bottom of the line.
      case TextSelectionHandleType.left:
        handleSize = getHandleSize(finalStartGlyphHeight);
        return Offset(
          handleSize.width / 2,
          handleSize.height,
        );
      // The right handle is vertically flipped, and the anchor point is near
      // the top of the circle to give slight overlap.
      case TextSelectionHandleType.right:
        handleSize = getHandleSize(finalEndGlyphHeight);
        return Offset(
          handleSize.width / 2,
          handleSize.height - 2 * _kSelectionHandleRadius + _kSelectionHandleOverlap,
        );
      // A collapsed handle anchors itself so that it's centered.
      case TextSelectionHandleType.collapsed:
        handleSize = getHandleSize(textLineHeight);
        return Offset(
          handleSize.width / 2,
          textLineHeight + (handleSize.height - textLineHeight) / 2,
        );
    }
  }
}
