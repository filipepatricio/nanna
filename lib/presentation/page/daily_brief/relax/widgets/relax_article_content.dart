part of '../relax_view.dart';

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        _ArticleHeadline(),
        SizedBox(height: AppDimens.l),
        _ArticleFooter(),
      ],
    );
  }
}

class _ArticleHeadline extends StatelessWidget {
  const _ArticleHeadline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InformedMarkdownBody(
          markdown: "_${LocaleKeys.article_relatedContent_cantGetEnough.tr()}_",
          baseTextStyle: AppTypography.h2Medium,
          highlightColor: AppColors.limeGreen,
          textAlignment: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.sl),
        Text(
          LocaleKeys.article_relatedContent_thereAreManyMore.tr(),
          style: AppTypography.b2Medium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ArticleFooter extends StatelessWidget {
  const _ArticleFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton.black(
      onTap: context.goToExplore,
      text: LocaleKeys.explore_exploreNow.tr(),
    );
  }
}
