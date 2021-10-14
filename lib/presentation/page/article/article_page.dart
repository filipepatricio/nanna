import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_cubit.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page_data.dart';
import 'package:better_informed_mobile/presentation/page/article/article_state.dart';
import 'package:better_informed_mobile/presentation/page/article/content/article_content_html.dart';
import 'package:better_informed_mobile/presentation/page/article/content/article_content_markdown.dart';
import 'package:better_informed_mobile/presentation/page/article/pull_up_indicator_action/pull_up_indicator_action.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

typedef ArticleNavigationCallback = void Function(int index);

const _loadNextArticleIndicatorHeight = 150.0;

class ArticlePage extends HookWidget {
  final double? readArticleProgress;
  final int index;
  final List<ArticleHeader> articleList;
  final ArticleNavigationCallback? navigationCallback;

  ArticlePage({
    required ArticlePageData pageData,
    Key? key,
  })  : index = _getIndex(pageData),
        articleList = _getArticles(pageData),
        navigationCallback = pageData.navigationCallback,
        readArticleProgress = pageData.readArticleProgress,
        super(key: key);

  static int _getIndex(ArticlePageData pageData) => pageData.map(
        singleArticle: (data) => 0,
        multipleArticles: (data) => data.index,
      );

  static List<ArticleHeader> _getArticles(ArticlePageData pageData) => pageData.map(
        singleArticle: (data) => [data.article],
        multipleArticles: (data) => data.articleList,
      );

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ArticleCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener<ArticleCubit, ArticleState>(cubit, (cubit, state, context) {
      state.mapOrNull(nextPageLoaded: (state) {
        navigationCallback?.call(state.index);
      });
    });

    final articleType = state.mapOrNull(
      loading: (state) => state.header.type,
      idleSingleArticle: (state) => state.header.type,
      idleMultiArticles: (state) => state.header.type,
    );

    useEffect(() {
      cubit.initialize(articleList, index);
    }, [cubit]);

    final scrollController = useScrollController(keepScrollOffset: true);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          articleType == ArticleType.premium
              ? LocaleKeys.article_appBar_premium.tr()
              : LocaleKeys.article_appBar_freemium.tr(),
          style: AppTypography.h5BoldSmall,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.l),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(AppVectorGraphics.share, color: AppColors.textPrimary),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: articleType == ArticleType.premium ? AppColors.limeGreen : AppColors.white,
      ),
      backgroundColor: AppColors.lightGrey,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: state.maybeMap(
          loading: (state) => _LoadingContent(
            header: state.header,
            controller: scrollController,
          ),
          idleMultiArticles: (state) => _IdleContent(
            header: state.header,
            content: state.content,
            hasNextArticle: state.hasNext,
            multipleArticles: true,
            controller: scrollController,
            cubit: cubit,
            readArticleProgress: readArticleProgress,
          ),
          idleSingleArticle: (state) => _IdleContent(
            header: state.header,
            content: state.content,
            hasNextArticle: false,
            multipleArticles: false,
            controller: scrollController,
            cubit: cubit,
            readArticleProgress: readArticleProgress,
          ),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  final ArticleHeader header;
  final ScrollController controller;

  const _LoadingContent({
    required this.header,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ArticleHeaderView(article: header),
              const SizedBox(height: AppDimens.l),
              const Loader(),
            ],
          ),
        ),
      ],
    );
  }
}

class _IdleContent extends HookWidget {
  final ArticleHeader header;
  final ArticleContent content;
  final ArticleCubit cubit;
  final ScrollController controller;
  final bool hasNextArticle;
  final bool multipleArticles;
  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();
  final double? readArticleProgress;

  _IdleContent({
    required this.header,
    required this.content,
    required this.hasNextArticle,
    required this.multipleArticles,
    required this.controller,
    required this.cubit,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadedState = useState(false);

    useEffect(
      () {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          loadedState.value = false;
        });
      },
      [content],
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      calculateArticleContentOffset();
    });

    return LayoutBuilder(
      builder: (context, constrains) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              var readScrollOffset = controller.offset - cubit.scrollData.contentOffset;
              if (readScrollOffset < 0) {
                readScrollOffset = constrains.maxHeight - (cubit.scrollData.contentOffset - controller.offset);
              }

              cubit.updateScrollData(
                readScrollOffset,
                controller.position.maxScrollExtent,
              );
            }
            return true;
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            key: _articlePageKey,
            controller: controller,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ArticleHeaderView(article: header),
                    ArticleContentView(
                      article: header,
                      content: content,
                      cubit: cubit,
                      controller: controller,
                      articleContentKey: _articleContentKey,
                      scrollToPosition: () => scrollToPosition(readArticleProgress),
                      onLoaded: () {
                        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                          loadedState.value = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (loadedState.value)
                if (hasNextArticle)
                  SliverPullUpIndicatorAction(
                    builder: (context, factor) => _LoadingNextArticleIndicator(factor: factor),
                    fullExtentHeight: _loadNextArticleIndicatorHeight,
                    triggerExtent: _loadNextArticleIndicatorHeight,
                    triggerFunction: (completer) => cubit.loadNextArticle(completer),
                  )
                else if (multipleArticles)
                  const SliverToBoxAdapter(
                    child: _AllArticlesRead(),
                  ),
            ],
          ),
        );
      },
    );
  }

  void calculateArticleContentOffset() {
    final globalContentOffset = _calculateGlobalOffset(_articleContentKey) ?? 0;
    final globalPageOffset = _calculateGlobalOffset(_articlePageKey) ?? 0;
    cubit.setupScrollData(globalContentOffset, globalPageOffset);
  }

  void scrollToPosition(double? readArticleProgress) {
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
}

class _LoadingNextArticleIndicator extends StatelessWidget {
  final double factor;

  const _LoadingNextArticleIndicator({
    required this.factor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(factor),
      child: ScaleTransition(
        scale: AlwaysStoppedAnimation(factor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SvgPicture.asset(
                AppVectorGraphics.loadNextArticle,
              ),
            ),
            const SizedBox(height: AppDimens.s),
            Text(
              LocaleKeys.article_loadingNext.tr(),
              style: AppTypography.b3Regular.copyWith(height: 1.8),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AllArticlesRead extends StatelessWidget {
  const _AllArticlesRead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          Center(
            child: SvgPicture.asset(AppVectorGraphics.noNextArticle),
          ),
          const SizedBox(height: AppDimens.s),
          Text(
            LocaleKeys.article_allArticlesRead.tr(),
            style: AppTypography.b3Regular.copyWith(height: 1.8),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.xl),
          FilledButton(
            text: LocaleKeys.article_goBackToTopic.tr(),
            fillColor: AppColors.textPrimary,
            textColor: AppColors.white,
            onTap: () => AutoRouter.of(context).pop(),
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}

class ArticleHeaderView extends HookWidget {
  final ArticleHeader article;

  const ArticleHeaderView({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.55,
          child: imageId != null
              ? Image.network(
                  cloudinaryProvider.withPublicId(imageId).url,
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                )
              : Container(color: Colors.white),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.gradientOverlayStartColor,
                  AppColors.gradientOverlayEndColor,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(AppVectorGraphics.info),
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                Text(
                  article.title, // TODO missing data in object
                  style: AppTypography.b1Medium.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArticleContentView extends StatelessWidget {
  final ArticleHeader article;
  final ArticleContent content;
  final ArticleCubit cubit;
  final ScrollController controller;
  final Key articleContentKey;
  final Function() scrollToPosition;
  final Function() onLoaded;

  const ArticleContentView({
    required this.article,
    required this.content,
    required this.cubit,
    required this.controller,
    required this.articleContentKey,
    required this.scrollToPosition,
    required this.onLoaded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final author = article.author;

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.l),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(article.title, style: AppTypography.h1Bold),
                  const SizedBox(height: AppDimens.l),
                  Divider(
                    height: AppDimens.one,
                    color: AppColors.textPrimary.withOpacity(0.14),
                  ),
                  if (author != null) ...[
                    const SizedBox(height: AppDimens.s),
                    Text(
                      LocaleKeys.article_articleBy.tr(args: [author]),
                      style: AppTypography.metadata1Medium,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimens.articleItemMargin),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppVectorGraphics.notifications,
                    width: AppDimens.m,
                    height: AppDimens.m,
                  ),
                  const SizedBox(width: AppDimens.xs),
                  Text(
                    article.publisher.name,
                    style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
                  ),
                  const VerticalDivider(),
                  Text(
                    LocaleKeys.article_readMinutes.tr(args: [article.timeToRead.toString()]),
                    style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
                  ),
                  const VerticalDivider(),
                  Text(
                    DateFormatUtil.formatFullMonthNameDayYear(article.publicationDate),
                    style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.xl),
          ],
        ),
        Container(
          key: articleContentKey,
          child: getArticleContentType(
            content.type,
            onLoaded,
          ),
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }

  Widget? getArticleContentType(ArticleContentType type, Function() onLoaded) {
    if (type == ArticleContentType.markdown) {
      return ArticleContentMarkdown(
        markdown: content.content,
        scrollToPosition: scrollToPosition,
        onLoaded: onLoaded,
      );
    } else if (type == ArticleContentType.html) {
      return ArticleContentHtml(
        html: content.content,
        cubit: cubit,
        scrollToPosition: scrollToPosition,
        onLoaded: onLoaded,
      );
    }
    return null;
  }
}

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppDimens.articleItemMargin),
        Text('|', style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont)),
        const SizedBox(width: AppDimens.articleItemMargin),
      ],
    );
  }
}
