// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class MediaItemPageGestureManager {
  MediaItemPageGestureManager({
    required this.context,
    required this.articleViewController,
    required this.mainViewController,
  });

  final BuildContext context;
  final ScrollController articleViewController;
  final ScrollController mainViewController;

  Drag? _drag;
  DragUpdateDetails? _lastDragUpdateDetails;
  ScrollController? _activeController;

  MapEntry<Type, GestureRecognizerFactory<GestureRecognizer>> get tapGestureRecognizer => MapEntry(
        TapGestureRecognizer,
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer instance) {
            instance.onTapDown = (_) => resetScrollVelocity();
          },
        ),
      );

  MapEntry<Type, GestureRecognizerFactory<GestureRecognizer>> get dragGestureRecognizer => MapEntry(
        VerticalDragGestureRecognizer,
        GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
          (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = handleDragStart
              ..onUpdate = handleDragUpdate
              ..onEnd = handleDragEnd
              ..onCancel = handleDragCancel;
          },
        ),
      );

  void handleDragStart(DragStartDetails details) {
    if (_isOnArticlePart()) {
      _activeController = articleViewController;
      _drag = articleViewController.position.drag(details, disposeDrag);
      return;
    }

    _activeController = mainViewController;
    _drag = mainViewController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    _lastDragUpdateDetails = details;

    final nextSectionController = getNextController();

    if (nextSectionController != null) {
      switchControllers(nextSectionController);
    }

    _drag?.update(details);
  }

  ScrollController? getNextController() {
    final primaryDelta = _lastDragUpdateDetails?.primaryDelta ?? 0;

    if (_isTopOverscrollingAdditionalContent(primaryDelta)) {
      return articleViewController;
    } else if (_isBottomOverscrollingArticleView(primaryDelta)) {
      return mainViewController;
    }
    return null;
  }

  void switchControllers(ScrollController to) {
    if (_activeController == to) {
      return;
    }
    final ScrollController? from = _activeController;
    _activeController = to;
    final drag = _drag;
    final lastDetails = _lastDragUpdateDetails;

    if (drag != null && lastDetails != null) {
      drag.cancel();
      _drag = to.position.drag(
        DragStartDetails(
          globalPosition: lastDetails.globalPosition,
          localPosition: lastDetails.localPosition,
        ),
        disposeDrag,
      );
    } else {
      final activity = to.position.activity;
      final delegate = activity?.delegate;

      delegate?.goBallistic(
        from?.position.activity?.velocity ?? 0.0,
      );
    }
  }

  void handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void handleDragCancel() {
    _drag?.cancel();
  }

  void disposeDrag() {
    _drag = null;
  }

  void resetScrollVelocity() {
    _activeController?.position.jumpTo(_activeController?.position.pixels ?? 0);
  }

  bool _isOnArticlePart() => mainViewController.position.pixels <= 0;

  bool _isBottomOverscrollingArticleView(double primaryDelta) {
    return _activeController == articleViewController && _isDragDirectionDown(primaryDelta) && _isScrollAtEnd;
  }

  bool _isTopOverscrollingAdditionalContent(double primaryDelta) {
    return _activeController == mainViewController &&
        _isDragDirectionTop(primaryDelta) &&
        _activeController?.position.pixels == _activeController?.position.minScrollExtent;
  }

  bool get _isScrollAtEnd =>
      (_activeController?.position.pixels ?? 0.0) >= (_activeController?.position.maxScrollExtent ?? 0.0);

  bool _isDragDirectionTop(double primaryDelta) => primaryDelta > 0;

  bool _isDragDirectionDown(double primaryDelta) => primaryDelta < 0;
}
