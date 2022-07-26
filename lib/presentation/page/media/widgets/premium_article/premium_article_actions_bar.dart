import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class PremiumArticleActionsBar extends HookWidget {
  const PremiumArticleActionsBar({
    required this.article,
    required this.pageController,
    required this.snackbarController,
    required this.articleOutputModeNotifier,
    this.briefId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  final Article article;
  final PageController pageController;
  final SnackbarController snackbarController;
  final String? topicId;
  final String? briefId;
  final ValueNotifier<ArticleOutputMode> articleOutputModeNotifier;

  bool get fromTopic => topicId != null;

  @override
  Widget build(BuildContext context) {
    final hasImage = useMemoized(() => article.hasImage, [article]);

    final systemUiOverlayStyle = useMemoized(
      () => ValueNotifier(
        hasImage ? AppTheme.systemUIOverlayStyleLight : AppTheme.systemUIOverlayStyleDark,
      ),
      [hasImage],
    );

    final backgroundColor = useMemoized(
      () => ValueNotifier(
        hasImage ? AppColors.transparent : AppColors.background,
      ),
      [hasImage],
    );

    final buttonColor = useMemoized(
      () => ValueNotifier(
        hasImage && articleOutputModeNotifier.value == ArticleOutputMode.read ? AppColors.white : AppColors.textPrimary,
      ),
      [hasImage],
    );

    final bookmarkMode = useMemoized(
      () => ValueNotifier(
        hasImage && articleOutputModeNotifier.value == ArticleOutputMode.read
            ? BookmarkButtonMode.image
            : BookmarkButtonMode.color,
      ),
      [hasImage],
    );

    void _setButtonColor(
      ValueNotifier<Color> backgroundColor,
      ValueNotifier<BookmarkButtonMode> bookmarkMode,
      ValueNotifier<Color> buttonColor,
      PageController pageController,
    ) {
      if (articleOutputModeNotifier.value == ArticleOutputMode.audio) return;

      final buttonTween = ColorTween(begin: AppColors.white, end: AppColors.textPrimary);

      var page = 0.0;
      if (pageController.positions.isNotEmpty) {
        page = pageController.page ?? 0.0;
      }

      systemUiOverlayStyle.value = page == 1.0 ? AppTheme.systemUIOverlayStyleDark : AppTheme.systemUIOverlayStyleLight;
      backgroundColor.value = page == 1.0 ? AppColors.background : AppColors.transparent;
      bookmarkMode.value = page > 0.5 ? BookmarkButtonMode.color : BookmarkButtonMode.image;

      final buttonAnimValue = AlwaysStoppedAnimation(min(1.0, page));
      buttonColor.value = buttonTween.evaluate(buttonAnimValue) ?? AppColors.white;
    }

    useEffect(
      () {
        if (!hasImage) return () {};
        void listener() {
          _setButtonColor(backgroundColor, bookmarkMode, buttonColor, pageController);
        }

        pageController.addListener(listener);
        return () => pageController.removeListener(listener);
      },
      [pageController, articleOutputModeNotifier],
    );

    useEffect(
      () {
        if (!hasImage) return () {};
        void listener() {
          final audioMode = articleOutputModeNotifier.value == ArticleOutputMode.audio;
          if (audioMode) {
            backgroundColor.value = AppColors.transparent;
            bookmarkMode.value = BookmarkButtonMode.color;
            buttonColor.value = AppColors.textPrimary;
            systemUiOverlayStyle.value = AppTheme.systemUIOverlayStyleDark;
          } else {
            _setButtonColor(backgroundColor, bookmarkMode, buttonColor, pageController);
          }
        }

        articleOutputModeNotifier.addListener(listener);
        return () => articleOutputModeNotifier.removeListener(listener);
      },
      [pageController, articleOutputModeNotifier],
    );

    return ValueListenableBuilder(
      valueListenable: systemUiOverlayStyle,
      builder: (BuildContext context, SystemUiOverlayStyle value, Widget? child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: value,
          child: ValueListenableBuilder<Color>(
            valueListenable: backgroundColor,
            builder: (context, color, child) => Container(
              color: color,
              child: child,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: AppDimens.s,
                right: AppDimens.s,
                top: MediaQuery.of(context).padding.top,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<Color>(
                    valueListenable: buttonColor,
                    builder: (context, color, child) => TextButton.icon(
                      label: fromTopic
                          ? Text(
                              LocaleKeys.article_topicOverview.tr(),
                              style: AppTypography.subH1Medium.copyWith(
                                color: color,
                                height: 1,
                              ),
                            )
                          : const SizedBox.shrink(),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(
                            right: AppDimens.s,
                            left: fromTopic ? AppDimens.sl : AppDimens.zero,
                          ),
                        ),
                        foregroundColor: MaterialStateProperty.all(color),
                      ),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: AppDimens.backArrowSize,
                      ),
                      onPressed: () => context.popRoute(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (article.metadata.hasAudioVersion) ...[
                        ArticleOutputModeToggleButton(
                          buttonColor: buttonColor,
                          articleOutputMode: articleOutputModeNotifier,
                        )
                      ],
                      const SizedBox(width: AppDimens.m),
                      ValueListenableBuilder<BookmarkButtonMode>(
                        valueListenable: bookmarkMode,
                        builder: (context, mode, child) => BookmarkButton.article(
                          article: article.metadata,
                          topicId: topicId,
                          briefId: briefId,
                          mode: mode,
                          snackbarController: snackbarController,
                        ),
                      ),
                      const SizedBox(width: AppDimens.m),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
                        child: ShareArticleButton(
                          article: article.metadata,
                          snackbarController: snackbarController,
                          buttonBuilder: (context) => ValueListenableBuilder<Color>(
                            valueListenable: buttonColor,
                            builder: (context, color, child) => SvgPicture.asset(
                              AppVectorGraphics.share,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArticleOutputModeToggleButton extends StatelessWidget {
  const ArticleOutputModeToggleButton({
    required this.buttonColor,
    required this.articleOutputMode,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<Color> buttonColor;
  final ValueNotifier<ArticleOutputMode> articleOutputMode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: buttonColor,
      builder: (BuildContext context, Color colorValue, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: articleOutputMode,
          builder: (BuildContext context, ArticleOutputMode value, Widget? child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
              child: GestureDetector(
                onTap: () {
                  switch (value) {
                    case ArticleOutputMode.read:
                      articleOutputMode.value = ArticleOutputMode.audio;
                      break;
                    case ArticleOutputMode.audio:
                      articleOutputMode.value = ArticleOutputMode.read;
                      break;
                  }
                },
                child: SvgPicture.asset(
                  value == ArticleOutputMode.read ? AppVectorGraphics.headphones : AppVectorGraphics.lines,
                  color: colorValue,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
