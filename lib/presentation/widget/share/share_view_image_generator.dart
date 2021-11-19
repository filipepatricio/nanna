import 'dart:ui';

import 'package:better_informed_mobile/presentation/widget/share/base_share.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef WidgetFactory = BaseShare Function();

class ShareViewImageGenerator {
  final WidgetFactory widgetFactory;

  ShareViewImageGenerator(this.widgetFactory);

  Future<ByteData?> generate() async {
    final repaintBoundary = RenderRepaintBoundary();
    final shareWidget = widgetFactory();
    final renderView = _createRenderView(shareWidget.size, repaintBoundary);

    await _renderShareWidget(shareWidget, renderView, repaintBoundary);

    final image = await repaintBoundary.toImage();
    return image.toByteData(format: ImageByteFormat.png);
  }

  RenderView _createRenderView(Size viewSize, RenderRepaintBoundary repaintBoundary) {
    final renderPosition = RenderPositionedBox(alignment: Alignment.topCenter, child: repaintBoundary);
    final renderViewConfig = ViewConfiguration(size: viewSize);
    return RenderView(configuration: renderViewConfig, window: window, child: renderPosition);
  }

  Future<void> _renderShareWidget(
    BaseShare shareWidget,
    RenderView renderView,
    RenderRepaintBoundary repaintBoundary,
  ) async {
    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: shareWidget.size.height,
          width: shareWidget.size.width,
          child: shareWidget,
        ),
      ),
    );
    final element = rootElement.attachToRenderTree(buildOwner);

    buildOwner.buildScope(element);

    if (shareWidget is BaseShareCompletable) {
      try {
        await shareWidget.viewReadyCompleter.future;
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
