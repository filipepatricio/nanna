import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class TopicVerticalDragManager {
  final ScrollController modalController;
  final ScrollController generalViewController;

  Drag? _drag;
  ScrollController? _activeController;

  TopicVerticalDragManager({
    required this.modalController,
    required this.generalViewController,
  });

  void handleDragStart(DragStartDetails details) {
    _activeController = generalViewController;
    _drag = generalViewController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final primaryDelta = details.primaryDelta ?? 0;

    if (_isPullingDownBottomSheet(primaryDelta)) {
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
}
