import 'package:auto_route/auto_route.dart';
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
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.articleOutputMode = ArticleOutputMode.read,
    Key? key,
  }) : super(key: key);

  final String? slug;
  final String? topicSlug;
  final MediaItemArticle? article;
  final String? topicId;
  final String? briefId;
  final ArticleOutputMode articleOutputMode;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MediaItemCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController(audioPlayerResponsive: true));

    useEffect(
      () {
        cubit.initialize(article, slug, topicId, topicSlug, briefId);
      },
      [cubit],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: InformedAnimatedSwitcher(
        child: state.maybeMap(
          loading: (_) => const _LoadingContent(),
          idleFree: (data) => FreeArticleView(
            article: data.header,
            snackbarController: snackbarController,
            briefId: briefId,
            topicId: topicId,
          ),
          idlePremium: (data) => PremiumArticleView(
            article: data.article,
            snackbarController: snackbarController,
            articleOutputMode: articleOutputMode,
            briefId: briefId,
            topicId: topicId,
            topicSlug: topicSlug,
          ),
          error: (data) => _ErrorContent(article: data.article),
          emptyError: (_) => _ErrorContent(
            onTryAgain: () {
              cubit.initialize(article, slug, topicId, topicSlug, briefId);
            },
          ),
          geoblocked: (_) => const _ErrorGeoblocked(),
          orElse: Container.new,
        ),
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
    return const Scaffold(
      appBar: _BaseAppBar(),
      body: LoadingShimmer.defaultColor(),
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

    return Scaffold(
      appBar: const _BaseAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            )
          else
            Center(
              child: SizedBox(
                width: _tryAgainButtonWidth,
                child: FilledButton.black(
                  text: LocaleKeys.common_tryAgain.tr(),
                  onTap: () {
                    onTryAgain?.call();
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _ErrorGeoblocked extends StatelessWidget {
  const _ErrorGeoblocked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _BaseAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: GeneralErrorView(
          title: LocaleKeys.article_geoblockedError_title.tr(),
          content: LocaleKeys.article_geoblockedError_content.tr(),
          action: LocaleKeys.article_geoblockedError_action.tr(),
          retryCallback: context.popRoute,
        ),
      ),
    );
  }
}

class _BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _BaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        color: AppColors.textPrimary,
        iconSize: AppDimens.backArrowSize,
        onPressed: context.popRoute,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
