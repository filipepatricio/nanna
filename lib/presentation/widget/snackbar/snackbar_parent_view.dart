import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

typedef SnackbarMessageListener = Function(SnackbarMessage?);

const _hiddenMessageBottomMargin = -140.0;
const _messageAnimationDuration = Duration(milliseconds: 1300);
const _dragMinDistance = 6.0;
const _shownMessageDefaultBottomMargin = AppDimens.m;

class SnackbarParentView extends HookWidget {
  const SnackbarParentView({
    required this.child,
    this.audioPlayerResponsive = false,
    this.controller,
    Key? key,
  }) : super(key: key);

  final SnackbarController? controller;
  final bool audioPlayerResponsive;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SnackbarParentViewCubit>();
    final state = useCubitBuilder(cubit);
    final memoizedController = useMemoized(
      () => controller ?? SnackbarController(),
      [controller],
    );
    final audioPlayerCubit = useCubit<AudioPlayerBannerCubit>(closeOnDispose: false);
    final audioPlayerState = useCubitBuilder(audioPlayerCubit);

    final showingPosition = useState(_shownMessageDefaultBottomMargin);

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    useEffect(
      () {
        final audioPlayerVisible = audioPlayerState.maybeMap(
          visible: (_) => true,
          orElse: () => false,
        );

        if (audioPlayerResponsive && audioPlayerVisible) {
          showingPosition.value = _shownMessageDefaultBottomMargin + AppDimens.audioBannerHeight + bottomPadding;
        } else {
          showingPosition.value = _shownMessageDefaultBottomMargin;
        }
      },
      [audioPlayerResponsive, audioPlayerState],
    );

    useEffect(
      () {
        Future<void> listener(SnackbarMessage? message) async {
          if (message != null) {
            await cubit.addMessage(message);
          } else {
            await cubit.discardMessage();
          }
        }

        memoizedController._addListener(listener);
        return () => memoizedController._removeListener(listener);
      },
      [memoizedController],
    );

    return Provider<SnackbarController>.value(
      value: memoizedController,
      child: Stack(
        children: [
          child,
          AnimatedPositioned(
            left: AppDimens.l,
            right: AppDimens.l,
            bottom: state.isMessageVisible() ? showingPosition.value : _hiddenMessageBottomMargin,
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
      ),
    );
  }

  bool _isDraggingDown(DragUpdateDetails details) {
    return details.delta.direction > 0 && details.delta.direction < pi;
  }
}

class SnackbarController {
  SnackbarController();

  final List<SnackbarMessageListener> _listeners = [];

  void showMessage(SnackbarMessage message) {
    for (final element in _listeners) {
      element(message);
    }
  }

  void discardMessage() {
    for (final element in _listeners) {
      element(null);
    }
  }

  void _addListener(SnackbarMessageListener listener) => _listeners.add(listener);

  void _removeListener(SnackbarMessageListener listener) => _listeners.remove(listener);
}
