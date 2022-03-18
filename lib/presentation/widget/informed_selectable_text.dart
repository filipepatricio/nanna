import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const int iOSHorizontalOffset = -2;

class InformedSelectableText extends StatefulWidget {
  /// Version of [SelectableText.rich] with the added possibility to set a custom [TextSpanEditingController]
  const InformedSelectableText.rich(
    this.textSpan, {
    required this.controller,
    this.textAlign,
    this.maxLines,
    this.selectionControls,
    this.onSelectionChanged,
    Key? key,
  }) : super(key: key);

  final TextSpan textSpan;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextSelectionControls? selectionControls;
  final SelectionChangedCallback? onSelectionChanged;
  final TextSpanEditingController? controller;

  @override
  State<InformedSelectableText> createState() => _InformedSelectableTextState();
}

class _InformedSelectableTextState extends State<InformedSelectableText>
    implements TextSelectionGestureDetectorBuilderDelegate {
  EditableTextState? get _editableText => editableTextKey.currentState;

  late TextSpanEditingController _controller;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode => _focusNode ??= FocusNode(skipTraversal: true);

  bool _showSelectionHandles = false;

  late _SelectableTextSelectionGestureDetectorBuilder _selectionGestureDetectorBuilder;

  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  late bool forcePressEnabled;

  @override
  final GlobalKey<EditableTextState> editableTextKey = GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled => true;

  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder = _SelectableTextSelectionGestureDetectorBuilder(state: this);
    _controller = widget.controller ??
        TextSpanEditingController(
          key: Key('${widget.textSpan.hashCode}'),
          textSpan: widget.textSpan,
        );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(InformedSelectableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textSpan != oldWidget.textSpan) {
      _controller.removeListener(_onControllerChanged);
      _controller = TextSpanEditingController(
        key: Key('${widget.textSpan.hashCode}'),
        textSpan: widget.textSpan,
      );
      _controller.addListener(_onControllerChanged);
    }
    if (_effectiveFocusNode.hasFocus && _controller.selection.isCollapsed) {
      _showSelectionHandles = false;
    } else {
      _showSelectionHandles = true;
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final showSelectionHandles = !_effectiveFocusNode.hasFocus || !_controller.selection.isCollapsed;
    if (showSelectionHandles == _showSelectionHandles) {
      return;
    }
    setState(() {
      _showSelectionHandles = showSelectionHandles;
    });
  }

  TextSelection? _lastSeenTextSelection;

  void _handleSelectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    final willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }
    if (widget.onSelectionChanged != null && _lastSeenTextSelection != selection) {
      widget.onSelectionChanged!(selection, cause);
    }
    _lastSeenTextSelection = selection;

    if (Theme.of(context).platform == TargetPlatform.iOS && cause == SelectionChangedCause.longPress) {
      _editableText?.bringIntoView(selection.base);
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_controller.selection.isCollapsed) {
      _editableText!.toggleToolbar();
    }
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) return false;

    if (_controller.selection.isCollapsed) return false;

    if (cause == SelectionChangedCause.keyboard) return false;

    if (cause == SelectionChangedCause.longPress) return true;

    if (_controller.text.isNotEmpty) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasDirectionality(context));
    final theme = Theme.of(context);
    final selectionTheme = TextSelectionTheme.of(context);
    final focusNode = _effectiveFocusNode;

    var textSelectionControls = widget.selectionControls ?? materialTextSelectionControls;
    var paintCursorAboveText = false;
    var cursorOpacityAnimates = false;
    var cursorColor = selectionTheme.cursorColor ?? theme.colorScheme.primary;
    var selectionColor = selectionTheme.selectionColor ?? theme.colorScheme.primary.withOpacity(0.40);
    forcePressEnabled = false;

    Offset? cursorOffset;
    Radius? cursorRadius;

    if (theme.platform == TargetPlatform.iOS) {
      final cupertinoTheme = CupertinoTheme.of(context);
      forcePressEnabled = true;
      textSelectionControls = widget.selectionControls ?? cupertinoTextSelectionControls;
      paintCursorAboveText = true;
      cursorOpacityAnimates = true;
      cursorColor = selectionTheme.cursorColor ?? cupertinoTheme.primaryColor;
      selectionColor = selectionTheme.selectionColor ?? cupertinoTheme.primaryColor.withOpacity(0.40);
      cursorRadius ??= const Radius.circular(2.0);
      cursorOffset = Offset(iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
    }

    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = defaultTextStyle.style;
    if (MediaQuery.boldTextOverride(context)) {
      effectiveTextStyle = effectiveTextStyle.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final Widget child = RepaintBoundary(
      child: EditableText(
        key: editableTextKey,
        style: effectiveTextStyle,
        readOnly: true,
        textWidthBasis: defaultTextStyle.textWidthBasis,
        textHeightBehavior: defaultTextStyle.textHeightBehavior,
        showSelectionHandles: _showSelectionHandles,
        controller: _controller,
        focusNode: focusNode,
        strutStyle: const StrutStyle(),
        textAlign: widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
        autofocus: false,
        forceLine: false,
        toolbarOptions: const ToolbarOptions(selectAll: true, copy: true),
        maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
        selectionColor: selectionColor,
        selectionControls: textSelectionControls,
        onSelectionChanged: _handleSelectionChanged,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        rendererIgnoresPointer: true,
        cursorWidth: 2.0,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        selectionHeightStyle: ui.BoxHeightStyle.tight,
        selectionWidthStyle: ui.BoxWidthStyle.tight,
        cursorOpacityAnimates: cursorOpacityAnimates,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,
        backgroundCursorColor: CupertinoColors.inactiveGray,
        enableInteractiveSelection: true,
        dragStartBehavior: DragStartBehavior.start,
        autofillHints: null,
      ),
    );

    return Semantics(
      onLongPress: () {
        _effectiveFocusNode.requestFocus();
      },
      child: _selectionGestureDetectorBuilder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}

class TextSpanEditingController extends TextEditingController {
  TextSpanEditingController({
    required this.key,
    required TextSpan textSpan,
  })  : _textSpan = textSpan,
        super(text: textSpan.toPlainText(includeSemanticsLabels: false));

  final Key key;
  final TextSpan _textSpan;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    // This does not care about composing.
    return TextSpan(
      style: style,
      children: <TextSpan>[_textSpan],
    );
  }
}

class _SelectableTextSelectionGestureDetectorBuilder extends TextSelectionGestureDetectorBuilder {
  _SelectableTextSelectionGestureDetectorBuilder({
    required _InformedSelectableTextState state,
  })  : _state = state,
        super(delegate: state);

  final _InformedSelectableTextState _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      renderEditable.selectWordsInRange(
        from: details.globalPosition - details.offsetFromOrigin,
        to: details.globalPosition,
        cause: SelectionChangedCause.longPress,
      );
    }
  }

  @override
  void onSingleTapUp(TapUpDetails details) {
    editableText.hideToolbar();
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
          renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
          break;
        default:
          renderEditable.selectPosition(cause: SelectionChangedCause.tap);
          break;
      }
    }
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (delegate.selectionEnabled) {
      renderEditable.selectWord(cause: SelectionChangedCause.longPress);
      Feedback.forLongPress(_state.context);
    }
  }
}
