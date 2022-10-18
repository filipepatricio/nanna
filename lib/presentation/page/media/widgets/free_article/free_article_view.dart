import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/free_article/free_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/informed_tab_bar.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const _finishedAnimation = 1.0;

class FreeArticleView extends HookWidget {
  const FreeArticleView({
    required this.article,
    required this.snackbarController,
    required this.briefId,
    required this.topicId,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final SnackbarController snackbarController;
  final String? briefId;
  final String? topicId;

  @override
  Widget build(BuildContext context) {
    final showTabBar = useState(false);
    final scrollPosition = useMemoized(() => ValueNotifier(0.0));
    final pageLoadingProgress = useMemoized(() => ValueNotifier(0.0));

    final animation = ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(_finishedAnimation);

    final webViewOptions = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        contentBlockers: [
          ContentBlocker(
            trigger: ContentBlockerTrigger(urlFilter: "http://*.*"),
            action: ContentBlockerAction(
              type: ContentBlockerActionType.BLOCK,
            ),
          ),
        ],
      ),
      android: AndroidInAppWebViewOptions(useHybridComposition: true),
      ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
    );

    final cubit = useCubit<FreeArticleViewCubit>();

    useEffect(
      () {
        cubit.init(article.slug);
      },
      [cubit],
    );

    return Scaffold(
      appBar: ArticleAppBar(
        article: article,
        topicId: topicId,
        snackbarController: snackbarController,
        onBackPressed: () => context.popRoute(cubit.articleProgress),
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
                    onProgressChanged: (controller, progress) async {
                      pageLoadingProgress.value = progress == 100 ? 0.0 : progress / 100;
                      if (progress == 100) {
                        cubit.setMaxScrollOffset(await controller.getContentHeight());
                      }
                    },
                    onScrollChanged: (controller, _, y) async {
                      if (y <= 0) {
                        return;
                      }

                      if (y > scrollPosition.value) {
                        scrollPosition.value = y.toDouble();
                        showTabBar.value = false;
                        cubit.updateScrollOffset(y);
                        return;
                      }

                      if (y < scrollPosition.value) {
                        scrollPosition.value = y.toDouble();
                        showTabBar.value = true;
                      }
                    },
                    onOverScrolled: (controller, x, y, clampedX, clampedY) {
                      if (clampedY && y > 0) {
                        showTabBar.value = true;
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
            InformedTabBar.floating(show: showTabBar.value),
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
          valueColor: const AlwaysStoppedAnimation(AppColors.limeGreen),
          minHeight: 3,
        );
      },
    );
  }
}
