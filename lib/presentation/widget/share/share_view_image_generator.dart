import 'dart:ui';

import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef WidgetFactory = Widget Function();

const _defaultViewHeight = 3840.0;
const _defaultViewWidth = 2160.0;

class ShareViewImageGenerator {
  final WidgetFactory widgetFactory;

  ShareViewImageGenerator(this.widgetFactory);

  Future<ByteData?> generate() async {
    final repaintBoundary = RenderRepaintBoundary();
    final renderView = _createRenderView(repaintBoundary);

    await _renderShareWidget(renderView, repaintBoundary);

    final image = await repaintBoundary.toImage();
    return image.toByteData(format: ImageByteFormat.png);
  }

  RenderView _createRenderView(RenderRepaintBoundary repaintBoundary) {
    final renderPosition = RenderPositionedBox(alignment: Alignment.topCenter, child: repaintBoundary);
    const renderViewConfig = ViewConfiguration(
      size: Size(_defaultViewWidth, _defaultViewHeight),
    );
    return RenderView(configuration: renderViewConfig, window: window, child: renderPosition);
  }

  Future<void> _renderShareWidget(RenderView renderView, RenderRepaintBoundary repaintBoundary) async {
    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final shareWidget = widgetFactory();
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: _defaultViewHeight,
          width: _defaultViewWidth,
          child: shareWidget,
        ),
      ),
    );
    final element = rootElement.attachToRenderTree(buildOwner);

    buildOwner.buildScope(element);

    if (shareWidget is BaseShareCompletable) {
      try {
        await (shareWidget as BaseShareCompletable).viewReadyCompleter.future;
      } catch (e, s) {
        Fimber.e('Waiting for share widget to complete loading failed', ex: e, stacktrace: s);
      }

      buildOwner.buildScope(element);
    }

    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();
  }
}
