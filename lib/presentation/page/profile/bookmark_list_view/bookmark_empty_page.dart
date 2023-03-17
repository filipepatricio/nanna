part of 'bookmark_list_view.dart';

class _BookmarkEmptyView extends StatelessWidget {
  const _BookmarkEmptyView({
    required this.filter,
  });

  final BookmarkFilter filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const InformedSvg(AppVectorGraphics.bookmarkOutline),
                const SizedBox(height: AppDimens.l),
                Text(
                  context.l10n.profile_emptyPage_title,
                  style: AppTypography.b2Medium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.l),
                Text(
                  filter.emptyBodyText(context),
                  style: AppTypography.b2Regular,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.xl),
                Center(
                  child: InformedFilledButton.primary(
                    context: context,
                    text: filter.buttonText(context),
                    onTap: () => AutoRouter.of(context).navigate(
                      const ExploreTabGroupRouter(
                        children: [
                          ExplorePageRoute(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension Texts on BookmarkFilter {
  String emptyBodyText(BuildContext context) {
    switch (this) {
      case BookmarkFilter.all:
        return context.l10n.profile_emptyPage_noAll;
      case BookmarkFilter.topic:
        return context.l10n.profile_emptyPage_noTopics;
      case BookmarkFilter.article:
        return context.l10n.profile_emptyPage_noArticles;
    }
  }

  String buttonText(BuildContext context) {
    switch (this) {
      case BookmarkFilter.all:
        return context.l10n.profile_emptyPage_noAllAction;
      case BookmarkFilter.topic:
        return context.l10n.profile_emptyPage_noTopicsAction;
      case BookmarkFilter.article:
        return context.l10n.profile_emptyPage_noArticlesAction;
    }
  }
}
