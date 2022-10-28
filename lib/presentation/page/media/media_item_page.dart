import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/free_article/free_article_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_cupertino_app_bar.dart';
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
          geoblocked: (_) => const _ErrorGeoBlocked(),
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: InformedCupertinoAppBar(
        backLabel: LocaleKeys.common_back.tr(),
        backgroundColor: AppColors.transparent,
        brightness: Brightness.light,
      ),
      body: const LoadingShimmer.defaultColor(),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.onTryAgain,
    this.article,
    Key? key,
  }) : super(key: key);

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
      appBar: InformedCupertinoAppBar(
        brightness: Brightness.light,
        backLabel: LocaleKeys.common_back.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.xxxc),
        child: Center(
          child: GeneralErrorView(
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

class _ErrorGeoBlocked extends StatelessWidget {
  const _ErrorGeoBlocked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InformedCupertinoAppBar(
        brightness: Brightness.light,
        backLabel: LocaleKeys.common_back.tr(),
      ),
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
