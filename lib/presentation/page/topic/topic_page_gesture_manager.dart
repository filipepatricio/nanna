import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class TopicPageGestureManager {
  final ScrollController modalController;
  final ScrollController generalViewController;
  final BuildContext context;

  Drag? _drag;
  ScrollController? _activeController;

  TopicPageGestureManager({
    required this.context,
    required this.modalController,
    required this.generalViewController,
  });

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
    _activeController = generalViewController;
    _drag = generalViewController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final primaryDelta = details.primaryDelta ?? 0;

    if (_isPullingDownBottomSheet(primaryDelta)) {
      _detachViewFromPrimaryController();
      _activeController = modalController;
      _drag?.cancel();
      _drag = modalController.position.drag(
        DragStartDetails(globalPosition: details.globalPosition, localPosition: details.localPosition),
        disposeDrag,
      );
    } else if (_isBottomOverscrollingPageView(primaryDelta)) {
      _activeController = generalViewController;
      _drag?.cancel();
      _drag = generalViewController.position.drag(
        DragStartDetails(globalPosition: details.globalPosition, localPosition: details.localPosition),
        disposeDrag,
      );
    }

    _drag?.update(details);
  }

  void handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
    if (_activeController != modalController) {
      _attachViewFromPrimaryController();
    }
  }

  void handleDragCancel() {
    _drag?.cancel();
  }

  void disposeDrag() {
    _drag = null;
  }

  void resetScrollVelocity() {
    if (_activeController == generalViewController) {
      _activeController?.position.jumpTo(_activeController?.position.pixels ?? 0);
    }
  }

  bool _isPullingDownBottomSheet(double primaryDelta) {
    return _activeController == generalViewController &&
        primaryDelta > 0 &&
        _activeController?.position.pixels == _activeController?.position.minScrollExtent;
  }

  bool _isBottomOverscrollingPageView(double primaryDelta) {
    return _activeController == generalViewController &&
        primaryDelta < 0 &&
        (_activeController?.position.pixels ?? 0.0) >= (_activeController?.position.maxScrollExtent ?? 0.0);
  }

  /// Necessary for the [modalController] ([PrimaryScrollController]) to affect the modal sheet.
  /// It seems that when the [PrimaryScrollController] has multiple attached positions,
  /// the drag actions don't affect modal sheets - even when specifically pointing to the corresponding [ScrollPosition]
  void _detachViewFromPrimaryController() {
    if (modalController.positions.contains(generalViewController.position)) {
      modalController.detach(generalViewController.position);
    }
  }

  /// Necessary to achieve the return-to-top feature on iOS
  void _attachViewFromPrimaryController() {
    if (!modalController.positions.contains(generalViewController.position)) {
      modalController.attach(generalViewController.position);
    }
  }

  void animateViewTo(double offset) {
    _attachViewFromPrimaryController();
    generalViewController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }
}
