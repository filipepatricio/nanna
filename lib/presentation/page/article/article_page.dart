import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_data.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class ArticlePage extends HookWidget {
  final ArticleData article;

  const ArticlePage({required this.article});

  @override
  Widget build(BuildContext context) {
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
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ArticleHeader(article: article),
                ArticleContent(article: article),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleHeader extends HookWidget {
  final ArticleData article;

  const ArticleHeader({required this.article});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Image.asset(
            article.sourceUrl,
            fit: BoxFit.fitHeight,
            alignment: Alignment.topLeft,
          ),
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
                  article.photoText,
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

class ArticleContent extends HookWidget {
  final ArticleData article;

  const ArticleContent({required this.article});

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
          Text(LocaleKeys.article_articleBy.tr(args: [article.authorName]), style: AppTypography.metadata1Medium),
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
                article.publisherName,
                style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
              ),
              const VerticalDivider(),
              Text(
                article.timeToRead,
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
          Text(
            article.content + article.content + article.content,
            style: AppTypography.b2MediumSerif,
          ),
        ],
      ),
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
