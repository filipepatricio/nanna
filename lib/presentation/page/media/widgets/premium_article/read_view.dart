import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image_view.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/use_automatic_keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReadView extends HookWidget {
  ReadView({
    required this.article,
    required this.content,
    required this.modalController,
    required this.controller,
    required this.pageController,
    required this.snackbarController,
    required this.cubit,
    required this.fullHeight,
    required this.fromTopic,
    required this.readProgress,
    required this.showBackToTopicButton,
    this.readArticleProgress,
    this.articleOutputMode,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ArticleContent content;
  final ScrollController modalController;
  final ScrollController controller;
  final PageController pageController;
  final SnackbarController snackbarController;
  final MediaItemCubit cubit;
  final double fullHeight;
  final bool fromTopic;
  final ValueNotifier<double> readProgress;
  final ValueNotifier<bool> showBackToTopicButton;
  final double? readArticleProgress;
  final ValueNotifier<ArticleOutputMode>? articleOutputMode;

  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();

  bool get articleWithImage => article.image != null;

  void calculateArticleContentOffset() {
    final globalContentOffset = _calculateGlobalOffset(_articleContentKey) ?? 0;
    final globalPageOffset = _calculateGlobalOffset(_articlePageKey) ?? 0;
    cubit.setupScrollData(globalContentOffset, globalPageOffset);
  }

  void _scrollToPosition(double? readArticleProgress) {
    if (readArticleProgress != null && readArticleProgress != 1.0) {
      final scrollPosition = cubit.scrollData.contentOffset +
          ((controller.position.maxScrollExtent - cubit.scrollData.contentOffset) * readArticleProgress);
      controller.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  double? _calculateGlobalOffset(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return position?.dy;
  }

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);
    final footerHeight = MediaQuery.of(context).size.height / 3;

    useEffect(
      () {
        WidgetsBinding.instance?.addPostFrameCallback((_) => calculateArticleContentOffset());
      },
      [],
    );

    return PageView(
      physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      controller: pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (page) {
        showBackToTopicButton.value = false;
      },
      children: [
        if (articleWithImage)
          ArticleImageView(
            article: article,
            controller: pageController,
            fullHeight: fullHeight,
          ),
        Row(
          children: [
            Expanded(
              child: NoScrollGlow(
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(
                    parent: BottomBouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                  ),
                  controller: controller,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          ArticleContentView(
                            article: article,
                            content: content,
                            cubit: cubit,
                            controller: controller,
                            articleContentKey: _articleContentKey,
                            scrollToPosition: () => _scrollToPosition(readArticleProgress),
                          ),
                        ],
                      ),
                    ),
                    if (article.credits.isNotEmpty) ...[
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          top: AppDimens.xl,
                          left: AppDimens.l,
                          right: AppDimens.l,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _Credits(
                            article: article,
                          ),
                        ),
                      ),
                    ],
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: footerHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _ArticleProgressBar(readProgress: readProgress),
          ],
        ),
      ],
    );
  }
}

class _Credits extends StatelessWidget {
  const _Credits({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: article.credits,
      styleSheet: MarkdownStyleSheet(
        p: AppTypography.articleTextRegular.copyWith(
          color: AppColors.textGrey,
          fontStyle: FontStyle.italic,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          openInAppBrowser(href);
        }
      },
    );
  }
}

class _ArticleProgressBar extends HookWidget {
  final ValueNotifier<double> readProgress;

  const _ArticleProgressBar({
    required this.readProgress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: RotatedBox(
        quarterTurns: 1,
        child: ValueListenableBuilder(
          valueListenable: readProgress,
          builder: (BuildContext context, double value, Widget? child) {
            return LinearProgressIndicator(
              value: readProgress.value,
              backgroundColor: AppColors.transparent,
              valueColor: const AlwaysStoppedAnimation(AppColors.limeGreenVivid),
              minHeight: 6,
            );
          },
        ),
      ),
    );
  }
}
