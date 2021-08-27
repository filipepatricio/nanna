import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class TopicCustomVerticalDragManager {
  final ScrollController _listViewController;
  final PageController _pageViewController;

  Drag? _drag;
  ScrollController? _activeController;

  TopicCustomVerticalDragManager(this._listViewController, this._pageViewController);

  void handleDragStart(DragStartDetails details) {
    if (_pageViewController.hasClients) {
      final storageContext = _pageViewController.position.context.storageContext;
      final renderBox = storageContext.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final globalRect = renderBox.paintBounds.shift(renderBox.localToGlobal(Offset.zero));
        if (globalRect.top.round() == 0) {
          _activeController = _pageViewController;
          _drag = _pageViewController.position.drag(details, disposeDrag);
          return;
        }
      }
    }

    _activeController = _listViewController;
    _drag = _listViewController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final primaryDelta = details.primaryDelta ?? 0;

    if (_activeController == _pageViewController &&
        primaryDelta > 0 &&
        _activeController?.position.pixels == _activeController?.position.minScrollExtent) {
      _activeController = _listViewController;
      _drag?.cancel();
      _drag = _listViewController.position.drag(
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
}
