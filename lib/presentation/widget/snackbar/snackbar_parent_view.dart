import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef SnackbarMessageListener = Function(SnackbarMessage);

const _hiddenMessageBottomMargin = -140.0;
const _messageAnimationDuration = Duration(milliseconds: 1300);
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
        Future<void> listener(SnackbarMessage message) => cubit.addMessage(message);
        controller._addListener(listener);
        return () => controller._removeListener(listener);
      },
      [controller],
    );

    var showingPosition = AppDimens.l;

    if (controller.audioPlayerResponsive) {
      final audioPlayerCubit = useCubit<AudioPlayerBannerCubit>(closeOnDispose: false);
      final audioPlayerState = useCubitBuilder(audioPlayerCubit);
      audioPlayerState.maybeMap(visible: (value) => showingPosition += AppDimens.audioBannerHeight, orElse: () {});
    }

    return Stack(
      children: [
        child,
        AnimatedPositioned(
          left: AppDimens.l,
          right: AppDimens.l,
          bottom: state.isMessageVisible() ? showingPosition : _hiddenMessageBottomMargin,
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
              dismissAction: cubit.discardMessage,
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
  SnackbarController({this.audioPlayerResponsive = false});

  final bool audioPlayerResponsive;
  final List<SnackbarMessageListener> _listeners = [];

  void showMessage(SnackbarMessage message) {
    for (final element in _listeners) {
      element(message);
    }
  }

  void _addListener(SnackbarMessageListener listener) => _listeners.add(listener);

  void _removeListener(SnackbarMessageListener listener) => _listeners.remove(listener);
}
