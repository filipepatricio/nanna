import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class PremiumArticleActionsBar extends HookWidget {
  const PremiumArticleActionsBar({
    required this.article,
    required this.fullHeight,
    required this.pageController,
    required this.snackbarController,
    required this.cubit,
    required this.articleOutputMode,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final double fullHeight;
  final PageController pageController;
  final SnackbarController snackbarController;
  final MediaItemCubit cubit;
  final ValueNotifier<ArticleOutputMode> articleOutputMode;

  @override
  Widget build(BuildContext context) {
    final hasImage = useMemoized(() => article.image != null, [article]);

    final backgroundColor = useMemoized(
      () => ValueNotifier(hasImage ? AppColors.transparent : AppColors.background),
      [hasImage],
    );

    final buttonColor = useMemoized(
      () => ValueNotifier(hasImage ? AppColors.white : AppColors.textPrimary),
      [hasImage],
    );

    final bookmarkMode = useMemoized(
      () => ValueNotifier(hasImage ? BookmarkButtonMode.image : BookmarkButtonMode.color),
      [hasImage],
    );

    void _setButtonColor(
      ValueNotifier<Color> backgroundColor,
      ValueNotifier<BookmarkButtonMode> bookmarkMode,
      ValueNotifier<Color> buttonColor,
      PageController pageController,
    ) {
      if (articleOutputMode.value == ArticleOutputMode.audio) return;

      final buttonTween = ColorTween(begin: AppColors.white, end: AppColors.textPrimary);

      var page = 0.0;
      if (pageController.positions.isNotEmpty) {
        page = pageController.page ?? 0.0;
      }

      backgroundColor.value = page == 1.0 ? AppColors.background : AppColors.transparent;
      bookmarkMode.value = page > 0.5 ? BookmarkButtonMode.color : BookmarkButtonMode.image;

      final buttonAnimValue = AlwaysStoppedAnimation(min(1.0, page));
      buttonColor.value = buttonTween.evaluate(buttonAnimValue) ?? AppColors.white;
    }

    useEffect(
      () {
        if (!hasImage) return () {};
        final listener = () {
          _setButtonColor(backgroundColor, bookmarkMode, buttonColor, pageController);
        };
        pageController.addListener(listener);
        return () => pageController.removeListener(listener);
      },
      [pageController, articleOutputMode],
    );

    useEffect(
      () {
        if (!hasImage) return () {};
        final listener = () {
          final audioMode = articleOutputMode.value == ArticleOutputMode.audio;
          if (audioMode) {
            backgroundColor.value = AppColors.transparent;
            bookmarkMode.value = BookmarkButtonMode.color;
            buttonColor.value = AppColors.textPrimary;
          } else {
            _setButtonColor(backgroundColor, bookmarkMode, buttonColor, pageController);
          }
        };
        articleOutputMode.addListener(listener);
        return () => articleOutputMode.removeListener(listener);
      },
      [pageController, articleOutputMode],
    );

    return ValueListenableBuilder(
      valueListenable: backgroundColor,
      builder: (BuildContext context, Color value, Widget? child) {
        return Container(
          color: value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.ml) +
            const EdgeInsets.only(top: AppDimens.xs + AppDimens.xxs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
              valueListenable: buttonColor,
              builder: (BuildContext context, Color value, Widget? child) {
                return IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: value,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  onPressed: () => context.popRoute(),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (article.hasAudioVersion) ...[
                  AudioButton(buttonColor: buttonColor, articleOutputMode: articleOutputMode)
                ],
                const SizedBox(width: AppDimens.sl),
                ValueListenableBuilder(
                  valueListenable: bookmarkMode,
                  builder: (BuildContext context, BookmarkButtonMode value, Widget? child) {
                    return BookmarkButton.article(
                      article: article,
                      topicId: cubit.topicId,
                      briefId: cubit.briefId,
                      mode: bookmarkMode.value,
                      snackbarController: snackbarController,
                    );
                  },
                ),
                const SizedBox(width: AppDimens.sl),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
                  child: ShareArticleButton(
                    article: article,
                    buttonBuilder: (context) => ValueListenableBuilder(
                      valueListenable: buttonColor,
                      builder: (BuildContext context, Color value, Widget? child) {
                        return SvgPicture.asset(
                          AppVectorGraphics.share,
                          color: value,
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AudioButton extends StatelessWidget {
  const AudioButton({
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
