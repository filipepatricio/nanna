import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class ArticlePage extends HookWidget {
  final ArticleHeader article;

  const ArticlePage({required this.article});

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ArticleCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.initialize(article);
    }, [cubit]);

    final scrollController = useScrollController(keepScrollOffset: true);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          article.type == ArticleType.premium
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
        backgroundColor: article.type == ArticleType.premium ? AppColors.limeGreen : AppColors.white,
      ),
      backgroundColor: AppColors.lightGrey,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: state.maybeMap(
          loading: (state) => _LoadingContent(
            header: state.header,
            controller: scrollController,
          ),
          idle: (state) => _IdleContent(
            header: state.header,
            content: state.content,
            controller: scrollController,
            cubit: cubit,
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

class _IdleContent extends StatelessWidget {
  final ArticleHeader header;
  final ArticleContent content;
  final ScrollController controller;
  final ArticleCubit cubit;

  const _IdleContent({
    required this.header,
    required this.content,
    required this.controller,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          final scrollProgress = controller.offset / controller.position.maxScrollExtent;
          cubit.updateReadingBannerState(scrollProgress, controller.offset);
        }
        return true;
      },
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ArticleHeaderView(article: header),
                ArticleContentView(article: header, content: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleHeaderView extends HookWidget {
  final ArticleHeader article;

  const ArticleHeaderView({required this.article});

  @override
  Widget build(BuildContext context) {
    final imageId = article.image?.publicId;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.55,
          child: imageId != null
              ? Image.network(
                  CloudinaryImageExtension.withPublicId(imageId).url,
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

class ArticleContentView extends HookWidget {
  final ArticleHeader article;
  final ArticleContent content;

  const ArticleContentView({
    required this.article,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(article.title, style: AppTypography.h1Bold),
          const SizedBox(height: AppDimens.l),
          Divider(
            height: AppDimens.one,
            color: AppColors.textPrimary.withOpacity(0.14),
          ),
          const SizedBox(height: AppDimens.s),
          Text(
            LocaleKeys.article_articleBy.tr(args: ['David david']), // TODO missing data in object - author name
            style: AppTypography.metadata1Medium,
          ),
          const SizedBox(height: AppDimens.articleItemMargin),
          Row(
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
                article.timeToRead.toString(),
                style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
              ),
              const VerticalDivider(),
              Text(
                article.publicationDate,
                style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.xl),
          if (content.type == ArticleContentType.markdown)
            _ArticleContentMarkdown(markdown: content.content)
          else if (content.type == ArticleContentType.html)
            _ArticleContentHtml(html: content.content),
        ],
      ),
    );
  }
}

class _ArticleContentMarkdown extends StatelessWidget {
  final String markdown;

  const _ArticleContentMarkdown({
    required this.markdown,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformedMarkdownBody(
      markdown: markdown,
      baseTextStyle: AppTypography.b2MediumSerif,
      selectable: true,
    );
  }
}

class _ArticleContentHtml extends StatelessWidget {
  final String html;

  const _ArticleContentHtml({
    required this.html,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO displaying html with styles, probably opening WebView with local server (so CSS can be loaded)
    return SelectableText(
      html,
      style: AppTypography.b2MediumSerif,
    );
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
