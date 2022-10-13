import 'dart:math';

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
    required this.onBackPressed,
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
  final VoidCallback onBackPressed;

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

    final bookmarkColor = useMemoized(
      () => ValueNotifier(
        hasImage && articleOutputModeNotifier.value == ArticleOutputMode.read ? AppColors.white : AppColors.textPrimary,
      ),
      [hasImage],
    );

    void setButtonColor(
      ValueNotifier<Color> backgroundColor,
      ValueNotifier<Color> bookmarkColor,
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

      final buttonAnimValue = AlwaysStoppedAnimation(min(1.0, page));
      buttonColor.value = buttonTween.evaluate(buttonAnimValue) ?? AppColors.white;
      bookmarkColor.value = buttonTween.evaluate(buttonAnimValue) ?? AppColors.white;
    }

    useEffect(
      () {
        if (!hasImage) return () {};
        void listener() {
          setButtonColor(backgroundColor, bookmarkColor, buttonColor, pageController);
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
            bookmarkColor.value = AppColors.textPrimary;
            buttonColor.value = AppColors.textPrimary;
            systemUiOverlayStyle.value = AppTheme.systemUIOverlayStyleDark;
          } else {
            setButtonColor(backgroundColor, bookmarkColor, buttonColor, pageController);
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
                              style: AppTypography.subH1Medium.copyWith(color: color),
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
                      onPressed: onBackPressed,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (article.metadata.hasAudioVersion) ...[
                        ArticleOutputModeToggleButton(
                          buttonColor: buttonColor,
                          articleOutputMode: articleOutputModeNotifier,
                          enabled: article.metadata.availableInSubscription,
                        )
                      ],
                      const SizedBox(width: AppDimens.m),
                      ValueListenableBuilder<Color>(
                        valueListenable: bookmarkColor,
                        builder: (context, color, child) => BookmarkButton.article(
                          article: article.metadata,
                          topicId: topicId,
                          briefId: briefId,
                          color: color,
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
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<Color> buttonColor;
  final ValueNotifier<ArticleOutputMode> articleOutputMode;
  final bool enabled;

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
                onTap: enabled
                    ? () {
                        switch (value) {
                          case ArticleOutputMode.read:
                            articleOutputMode.value = ArticleOutputMode.audio;
                            break;
                          case ArticleOutputMode.audio:
                            articleOutputMode.value = ArticleOutputMode.read;
                            break;
                        }
                      }
                    : null,
                child: SvgPicture.asset(
                  value == ArticleOutputMode.read ? AppVectorGraphics.headphones : AppVectorGraphics.lines,
                  color: enabled ? colorValue : colorValue.withOpacity(0.4),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
