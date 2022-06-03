import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/back_to_topic_button.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';

const _finishedAnimation = 1.0;

class FreeArticleView extends HookWidget {
  const FreeArticleView({
    required this.article,
    required this.fromTopic,
    required this.snackbarController,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final bool fromTopic;
  final SnackbarController snackbarController;
  final MediaItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    final showBackToTopicButton = useState(false);
    final scrollPosition = useMemoized(() => ValueNotifier(0.0));
    final pageLoadingProgress = useMemoized(() => ValueNotifier(0.0));

    final animation = ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(_finishedAnimation);

    final webViewOptions = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(useHybridComposition: true),
      ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
    );

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.textPrimary,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppDimens.s),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            iconSize: AppDimens.backArrowSize,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            onPressed: () => context.popRoute(),
          ),
        ),
        actions: [
          BookmarkButton.article(
            article: article,
            topicId: cubit.topicId,
            briefId: cubit.briefId,
            mode: BookmarkButtonMode.color,
            snackbarController: snackbarController,
          ),
          const SizedBox(width: AppDimens.m),
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.s, top: AppDimens.s),
            child: ShareArticleButton(
              article: article,
              buttonBuilder: (context) => SvgPicture.asset(AppVectorGraphics.share),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: animation,
              builder: (context, value, child) {
                if (value == _finishedAnimation) {
                  return InAppWebView(
                    initialOptions: webViewOptions,
                    initialUrlRequest: URLRequest(url: Uri.parse(article.sourceUrl)),
                    onProgressChanged: (_, progress) {
                      pageLoadingProgress.value = progress == 100 ? 0.0 : progress / 100;
                    },
                    onScrollChanged: (controller, _, y) {
                      if (y > scrollPosition.value) {
                        scrollPosition.value = y.toDouble();
                        showBackToTopicButton.value = false;
                        return;
                      }

                      if (y < scrollPosition.value) {
                        scrollPosition.value = y.toDouble();
                        showBackToTopicButton.value = true;
                      }
                    },
                    onOverScrolled: (controller, x, y, clampedX, clampedY) {
                      if (clampedY && y > 0) {
                        showBackToTopicButton.value = true;
                      }
                    },
                    androidOnPermissionRequest: (controller, origin, resources) async {
                      return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      Fimber.d(consoleMessage.message);
                    },
                  );
                } else {
                  return const SizedBox.expand();
                }
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _PageLoadProgressBar(pageLoadingProgress: pageLoadingProgress),
            ),
            BackToTopicButton(
              showButton: showBackToTopicButton,
              fromTopic: fromTopic,
            ),
          ],
        ),
      ),
    );
  }
}

class _PageLoadProgressBar extends StatelessWidget {
  const _PageLoadProgressBar({
    required this.pageLoadingProgress,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<double> pageLoadingProgress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageLoadingProgress,
      builder: (BuildContext context, double value, Widget? child) {
        return LinearProgressIndicator(
          value: pageLoadingProgress.value,
          backgroundColor: AppColors.transparent,
          valueColor: const AlwaysStoppedAnimation(AppColors.limeGreenVivid),
          minHeight: 3,
        );
      },
    );
  }
}
