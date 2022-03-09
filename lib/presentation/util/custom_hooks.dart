import 'package:better_informed_mobile/presentation/widget/informed_selectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class _TextSpanEditingControllerHookCreator {
  const _TextSpanEditingControllerHookCreator();

  /// Creates a [TextSpanEditingController] that will be disposed automatically.
  ///
  /// The [textSpan] parameter can be used to set the initial value of the
  /// controller.
  TextSpanEditingController call({required Key key, required TextSpan textSpan, List<Object?>? keys}) {
    return use(_TextSpanEditingControllerHook(key, textSpan, keys));
  }
}

const useTextSpanEditingController = _TextSpanEditingControllerHookCreator();

class _TextSpanEditingControllerHook extends Hook<TextSpanEditingController> {
  const _TextSpanEditingControllerHook(
    this.key,
    this.textSpan, [
    List<Object?>? keys,
  ]) : super(keys: keys);

  final Key key;
  final TextSpan textSpan;

  @override
  _TextSpanEditingControllerHookState createState() {
    return _TextSpanEditingControllerHookState();
  }
}

class _TextSpanEditingControllerHookState extends HookState<TextSpanEditingController, _TextSpanEditingControllerHook> {
  late final _controller = TextSpanEditingController(key: hook.key, textSpan: hook.textSpan);

  @override
  TextSpanEditingController build(BuildContext context) => _controller;

  @override
  void dispose() => _controller.dispose();

  @override
  String get debugLabel => 'useTextSpanEditingController';
}
