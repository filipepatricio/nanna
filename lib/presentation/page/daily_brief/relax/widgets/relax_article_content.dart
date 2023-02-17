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
          markdown: "_${context.l10n.article_relatedContent_cantGetEnough}_",
          baseTextStyle: AppTypography.h2Medium,
          highlightColor: AppColors.brandAccent,
          textAlignment: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.sl),
        Text(
          context.l10n.article_relatedContent_thereAreManyMore,
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
    return InformedFilledButton.primary(
      context: context,
      onTap: context.goToExplore,
      text: context.l10n.explore_exploreNow,
    );
  }
}
