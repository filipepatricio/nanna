import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class MediaItemPageGestureManager {
  final BuildContext context;
  final ScrollController modalController;
  final ScrollController generalViewController;
  final PageController pageViewController;
  final bool articleHasImage;

  Drag? _drag;
  ScrollController? _activeController;

  MediaItemPageGestureManager({
    required this.context,
    required this.modalController,
    required this.generalViewController,
    required this.pageViewController,
    required this.articleHasImage,
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
    if (_isOnImagePage()) {
      _activeController = pageViewController;
      _drag = pageViewController.position.drag(details, disposeDrag);
      return;
    }

    _activeController = generalViewController;
    _drag = generalViewController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final primaryDelta = details.primaryDelta ?? 0;

    if (_isPullingDownBottomSheet(primaryDelta)) {
      _detachPageFromPrimaryController();
      _activeController = modalController;
      _drag?.cancel();
      _drag = modalController.position.drag(
        DragStartDetails(globalPosition: details.globalPosition, localPosition: details.localPosition),
        disposeDrag,
      );
    } else if (_isTopOverscrollingGeneralView(primaryDelta)) {
      _detachViewFromPrimaryController();
      _activeController = pageViewController;
      _drag?.cancel();
      _drag = pageViewController.position.drag(
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
    if ((pageViewController.page ?? 0) == 1 || pageViewController.position.maxScrollExtent == 0) {
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
    _activeController?.position.jumpTo(_activeController?.position.pixels ?? 0);
  }

  bool _isPullingDownBottomSheet(double primaryDelta) {
    return _activeController == pageViewController &&
        primaryDelta > 0 &&
        _activeController?.position.pixels == _activeController?.position.minScrollExtent;
  }

  bool _isOnImagePage() => articleHasImage && pageViewController.hasClients && (pageViewController.page ?? 0.0) < 1.0;

  bool _isTopOverscrollingGeneralView(double primaryDelta) {
    return _activeController == generalViewController &&
        primaryDelta > 0 &&
        _activeController?.position.pixels == _activeController?.position.minScrollExtent;
  }

  bool _isBottomOverscrollingPageView(double primaryDelta) {
    return _activeController == pageViewController &&
        primaryDelta < 0 &&
        (_activeController?.position.pixels ?? 0.0) >= (_activeController?.position.maxScrollExtent ?? 0.0);
  }

  /// Necessary for the [modalController] ([PrimaryScrollController]) to affect the modal sheet.
  /// It seems that when the [PrimaryScrollController] has multiple attached positions,
  /// the drag actions don't affect modal sheets - even when specifically pointing to the corresponding [ScrollPosition]
  void _detachViewFromPrimaryController() {
    for (final position in generalViewController.positions) {
      if (modalController.positions.contains(position)) {
        modalController.detach(position);
      }
    }
  }

  void _detachPageFromPrimaryController() {
    for (final position in pageViewController.positions) {
      if (modalController.positions.contains(position)) {
        modalController.detach(position);
      }
    }
  }

  /// Necessary to achieve the return-to-top feature on iOS
  void _attachViewFromPrimaryController() {
    if (generalViewController.hasClients &&
        !modalController.positions.any((e) => generalViewController.positions.contains(e))) {
      modalController.attach(generalViewController.positions.first);
    }
  }
}
