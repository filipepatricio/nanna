import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_section/article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _itemHeight = 250.0;

class ArticleSeeAllPage extends StatelessWidget {
  final String title;
  final List<MediaItemArticle> entries;

  const ArticleSeeAllPage({
    required this.title,
    required this.entries,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          centerTitle: false,
          elevation: 0,
          title: Hero(
            tag: HeroTag.exploreArticleTitle,
            child: Text(
              tr(LocaleKeys.explore_title),
              style: AppTypography.h3bold,
            ),
          ),
          leading: IconButton(
            onPressed: () => AutoRouter.of(context).pop(),
            icon: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                AppVectorGraphics.arrowRight,
                height: AppDimens.backArrowSize,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.xc),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Hero(
                // TODO change to some ID or UUID if available
                tag: HeroTag.exploreArticleTitle(title.hashCode),
                child: InformedMarkdownBody(
                  markdown: title,
                  highlightColor: AppColors.transparent,
                  baseTextStyle: AppTypography.h1,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.m),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppDimens.l),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: _itemHeight,
                  crossAxisSpacing: AppDimens.m,
                  mainAxisSpacing: AppDimens.xl,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return ArticleListItem(
                        entry: entries[index],
                        themeColor: AppColors.background,
                        height: _itemHeight,
                        width: null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
