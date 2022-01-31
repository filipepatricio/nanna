import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef SnackbarMessageListener = Function(SnackbarMessage);

const _hiddenMessageBottomMaring = -128.0;
const _messageAnimationDuration = Duration(milliseconds: 1200);
const _dragMinDistance = 6.0;

class SnackbarParentView extends HookWidget {
  const SnackbarParentView({
    required this.controller,
    required this.child,
    Key? key,
  }) : super(key: key);

  final SnackbarController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SnackbarParentViewCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        final listener = (SnackbarMessage message) => cubit.addMessage(message);
        controller._addListener(listener);
        return () => controller._removeListener(listener);
      },
      [controller],
    );

    return Stack(
      children: [
        child,
        AnimatedPositioned(
          left: state.isMessageVisible() ? AppDimens.l : AppDimens.s,
          right: state.isMessageVisible() ? AppDimens.l : AppDimens.s,
          bottom: state.isMessageVisible() ? AppDimens.l : _hiddenMessageBottomMaring,
          duration: _messageAnimationDuration,
          curve: Curves.elasticOut,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (_isDraggingDown(details) && details.delta.distance > _dragMinDistance) {
                cubit.discardMessage();
              }
            },
            child: SnackbarView(
              message: state.nullableMessage,
            ),
          ),
        ),
      ],
    );
  }

  bool _isDraggingDown(DragUpdateDetails details) {
    return details.delta.direction > 0 && details.delta.direction < pi;
  }
}

class SnackbarController {
  final List<SnackbarMessageListener> _listeners = [];

  void showMessage(SnackbarMessage message) {
    for (final element in _listeners) {
      element(message);
    }
  }

  void _addListener(SnackbarMessageListener listener) => _listeners.add(listener);

  void _removeListener(SnackbarMessageListener listener) => _listeners.remove(listener);
}
