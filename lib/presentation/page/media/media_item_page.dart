import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/free_article/free_article_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _tryAgainButtonWidth = 150.0;

class MediaItemPage extends HookWidget {
  const MediaItemPage({
    @PathParam('articleSlug') this.slug,
    @QueryParam('topicSlug') this.topicSlug,
    this.article,
    this.topicId,
    this.briefId,
    this.readArticleProgress,
    this.articleOutputMode = ArticleOutputMode.read,
    Key? key,
  }) : super(key: key);

  final String? slug;
  final String? topicSlug;
  final MediaItemArticle? article;
  final String? topicId;
  final String? briefId;
  final double? readArticleProgress;
  final ArticleOutputMode articleOutputMode;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MediaItemCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    useEffect(
      () {
        cubit.initialize(article, slug, topicId, topicSlug, briefId);
      },
      [cubit],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: _AnimatedSwitcher(
              child: state.maybeMap(
                loading: (state) => const _LoadingContent(),
                idleFree: (state) => FreeArticleView(
                  article: state.header,
                  cubit: cubit,
                  snackbarController: snackbarController,
                ),
                idlePremium: (state) => PremiumArticleView(
                  article: state.article,
                  snackbarController: snackbarController,
                  readArticleProgress: readArticleProgress,
                  articleOutputMode: articleOutputMode,
                  briefId: briefId,
                  topicId: topicId,
                  topicSlug: topicSlug,
                ),
                error: (state) => _ErrorContent(article: state.article),
                emptyError: (_) => _ErrorContent(
                  onTryAgain: () {
                    cubit.initialize(article, slug, topicId, topicSlug, briefId);
                  },
                ),
                geoblocked: (_) => const _ErrorGeoblocked(),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppDimens.l,
            top: MediaQuery.of(context).padding.top + AppDimens.s,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.textPrimary,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            onPressed: () => context.popRoute(),
          ),
        ),
        const Expanded(
          child: Center(
            child: Loader(),
          ),
        ),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    this.article,
    this.onTryAgain,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle? article;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final article = this.article;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l, top: AppDimens.m),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.black,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            onPressed: () => context.popRoute(),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimens.l),
            SvgPicture.asset(AppVectorGraphics.articleError),
            const SizedBox(height: AppDimens.m),
            Text(
              LocaleKeys.dailyBrief_oops.tr(),
              style: AppTypography.h3bold,
              textAlign: TextAlign.center,
            ),
            Text(
              LocaleKeys.article_loadError.tr(),
              style: AppTypography.h3Normal,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.xl),
            if (article != null)
              OpenWebButton(
                url: article.sourceUrl,
                buttonLabel: LocaleKeys.article_openSourceUrl.tr(),
              )
            else
              Center(
                child: SizedBox(
                  width: _tryAgainButtonWidth,
                  child: FilledButton(
                    text: LocaleKeys.common_tryAgain.tr(),
                    fillColor: AppColors.textPrimary,
                    textColor: AppColors.white,
                    onTap: () {
                      onTryAgain?.call();
                    },
                  ),
                ),
              )
          ],
        ),
        const SizedBox(height: AppDimens.xxxl + AppDimens.l),
      ],
    );
  }
}

class _AnimatedSwitcher extends StatelessWidget {
  const _AnimatedSwitcher({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return kIsTest
        ? child
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: child,
          );
  }
}

class _ErrorGeoblocked extends StatelessWidget {
  const _ErrorGeoblocked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: GeneralErrorView(
        title: LocaleKeys.article_geoblockedError_title.tr(),
        content: LocaleKeys.article_geoblockedError_content.tr(),
        action: LocaleKeys.article_geoblockedError_action.tr(),
        retryCallback: () => context.popRoute(),
      ),
    );
  }
}
