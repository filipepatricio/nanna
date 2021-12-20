import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class TopicCustomVerticalDragManager {
  final ScrollController generalViewController;
  final PageController pageViewController;
  final double? topMargin;

  Drag? _drag;
  ScrollController? _activeController;

  TopicCustomVerticalDragManager({
    required this.generalViewController,
    required this.pageViewController,
    this.topMargin = 0.0,
  });

  void handleDragStart(DragStartDetails details) {
    if (pageViewController.hasClients) {
      final storageContext = pageViewController.position.context.storageContext;
      final renderBox = storageContext.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final globalRect = renderBox.paintBounds.shift(renderBox.localToGlobal(Offset.zero));
        if (globalRect.top.floor() == topMargin?.floor()) {
          _activeController = pageViewController;
          _drag = pageViewController.position.drag(details, disposeDrag);
          return;
        }
      }
    }
    _activeController = generalViewController;
    _drag = generalViewController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final primaryDelta = details.primaryDelta ?? 0;

    if (_activeController == pageViewController &&
        primaryDelta > 0 &&
        _activeController?.position.pixels == _activeController?.position.minScrollExtent) {
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

  Future<void> animateTo(double offset) async {
    await generalViewController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    _activeController = pageViewController;
  }
}
