import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/free_article/free_article_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

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

    useEffect(
      () {
        cubit.initialize(article, slug, topicId, topicSlug, briefId);
      },
      [cubit],
    );

    useEffect(
      () => () {
        final imageCache = PaintingBinding.instance.imageCache;
        imageCache.clear();
        imageCache.clearLiveImages();
      },
      [],
    );

    return Scaffold(
      body: SnackbarParentView(
        audioPlayerResponsive: true,
        child: InformedAnimatedSwitcher(
          child: state.maybeMap(
            loading: (data) => _LoadingContent(color: data.color),
            idleFree: (data) => FreeArticleView(
              article: data.header,
              briefId: briefId,
              topicId: topicId,
            ),
            idlePremium: (data) => PremiumArticleView(
              article: data.article,
              articleOutputMode: articleOutputMode,
              briefId: briefId,
              topicId: topicId,
              topicSlug: topicSlug,
            ),
            error: (data) => _ErrorContent(
              article: data.article,
              onTryAgain: () {
                cubit.initialize(article, slug, topicId, topicSlug, briefId);
              },
            ),
            emptyError: (_) => _ErrorContent(
              onTryAgain: () {
                cubit.initialize(article, slug, topicId, topicSlug, briefId);
              },
            ),
            offline: (data) => _ErrorNoConnection(
              article: data.article,
              onTryAgain: () {
                cubit.initialize(article, slug, topicId, topicSlug, briefId);
              },
            ),
            geoblocked: (_) => const _ErrorGeoblocked(),
            orElse: Container.new,
          ),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const InformedAppBar(
        backgroundColor: AppColors.transparent,
      ),
      body: color != null
          ? LoadingShimmer(mainColor: color!.withOpacity(.8), baseColor: color!)
          : const LoadingShimmer.defaultColor(),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.onTryAgain,
    this.article,
  });

  final MediaItemArticle? article;
  final VoidCallback onTryAgain;

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } else {
      Fimber.e('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = this.article;

    return Scaffold(
      appBar: const InformedAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.xxxc),
        child: Center(
          child: ErrorView(
            title: LocaleKeys.article_error_title.tr(),
            content: LocaleKeys.article_error_body.tr(),
            action: article != null ? LocaleKeys.article_openSourceUrl.tr() : LocaleKeys.common_tryAgain.tr(),
            retryCallback: () {
              article == null ? onTryAgain.call() : openUrl(article.sourceUrl);
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorGeoblocked extends StatelessWidget {
  const _ErrorGeoblocked();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InformedAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: ErrorView(
            title: LocaleKeys.article_geoblockedError_title.tr(),
            content: LocaleKeys.article_geoblockedError_content.tr(),
            action: LocaleKeys.article_geoblockedError_action.tr(),
            retryCallback: context.popRoute,
          ),
        ),
      ),
    );
  }
}

class _ErrorNoConnection extends StatelessWidget {
  const _ErrorNoConnection({
    required this.onTryAgain,
    this.article,
  });

  final VoidCallback onTryAgain;
  final MediaItemArticle? article;

  @override
  Widget build(BuildContext context) {
    final article = this.article;

    return Scaffold(
      appBar: article != null ? ArticleAppBar(article: article) : const InformedAppBar() as PreferredSizeWidget,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: ErrorView.offline(
            retryCallback: onTryAgain,
          ),
        ),
      ),
    );
  }
}
