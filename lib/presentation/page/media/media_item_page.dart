import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
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
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

typedef MediaItemNavigationCallback = void Function(int index);

const appBarHeight = kToolbarHeight + AppDimens.xl;
const _tryAgainButtonWidth = 150.0;

class MediaItemPage extends HookWidget {
  const MediaItemPage({
    @PathParam('articleSlug') this.slug,
    @QueryParam('topicSlug') this.topicSlug,
    this.article,
    this.topicId,
    this.briefId,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  final String? topicId;
  final String? briefId;
  final MediaItemArticle? article;
  final String? slug;
  final String? topicSlug;

  final double? readArticleProgress;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MediaItemCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    final modalController = useMemoized(
      () => ModalScrollController.of(context) ?? ScrollController(keepScrollOffset: true),
    );

    final scrollController = useMemoized(
      () => ScrollController(keepScrollOffset: true),
    );

    final pageController = usePageController();

    useEffect(
      () {
        cubit.initialize(article, slug, topicId, topicSlug, briefId);
      },
      [cubit],
    );

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            /// This invisible scroll view is a way around to make cupertino bottom sheet work with pull down gesture
            ///
            /// As cupertino bottom sheet works on ScrollNotification
            /// instead of ScrollController itself it's the only way
            /// to make sure it will work - at least only way I found
            NoScrollGlow(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                controller: modalController,
                child: const SizedBox.shrink(),
              ),
            ),
            Expanded(
              child: _AnimatedSwitcher(
                child: state.maybeMap(
                  loading: (state) => const _LoadingContent(),
                  idleFree: (state) => FreeArticleView(
                    article: state.header,
                    cubit: cubit,
                    fromTopic: topicId != null || topicSlug != null,
                    snackbarController: snackbarController,
                  ),
                  idlePremium: (state) => PremiumArticleView(
                    article: state.header,
                    content: state.content,
                    fromTopic: topicId != null || topicSlug != null,
                    modalController: modalController,
                    controller: scrollController,
                    pageController: pageController,
                    snackbarController: snackbarController,
                    cubit: cubit,
                    fullHeight: constraints.maxHeight,
                    readArticleProgress: readArticleProgress,
                  ),
                  error: (state) => _ErrorContent(article: state.article),
                  emptyError: (_) => _ErrorContent(
                    onTryAgain: () {
                      cubit.initialize(article, slug, topicId, topicSlug, briefId);
                    },
                  ),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l, top: AppDimens.s),
          child: IconButton(
            icon: const Icon(Icons.close_rounded),
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
  final MediaItemArticle? article;
  final VoidCallback? onTryAgain;

  const _ErrorContent({
    this.article,
    this.onTryAgain,
    Key? key,
  }) : super(key: key);

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
            icon: const Icon(Icons.close_rounded),
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
              LocaleKeys.todaysTopics_oops.tr(),
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
  final Widget child;

  const _AnimatedSwitcher({required this.child, Key? key}) : super(key: key);

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