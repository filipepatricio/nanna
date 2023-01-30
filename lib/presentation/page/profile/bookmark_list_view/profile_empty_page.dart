part of 'bookmark_list_view.dart';

class _BookmarkEmptyView extends StatelessWidget {
  const _BookmarkEmptyView({
    required this.filter,
    Key? key,
  }) : super(key: key);

  final BookmarkFilter filter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const InformedSvg(AppVectorGraphics.bookmarkOutline),
          const SizedBox(height: AppDimens.m),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: tr(LocaleKeys.profile_emptyPage_title),
                  style: AppTypography.b2Medium,
                ),
                TextSpan(
                  text: filter.emptyBodyText,
                  style: AppTypography.b2Regular,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.xl),
          Center(
            child: InformedFilledButton.primary(
              context: context,
              text: filter.buttonText,
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
    );
  }
}

extension Texts on BookmarkFilter {
  String get emptyBodyText {
    switch (this) {
      case BookmarkFilter.all:
        return LocaleKeys.profile_emptyPage_noAll.tr();
      case BookmarkFilter.topic:
        return LocaleKeys.profile_emptyPage_noTopics.tr();
      case BookmarkFilter.article:
        return LocaleKeys.profile_emptyPage_noArticles.tr();
    }
  }

  String get buttonText {
    switch (this) {
      case BookmarkFilter.all:
        return LocaleKeys.profile_emptyPage_noAllAction.tr();
      case BookmarkFilter.topic:
        return LocaleKeys.profile_emptyPage_noTopicsAction.tr();
      case BookmarkFilter.article:
        return LocaleKeys.profile_emptyPage_noArticlesAction.tr();
    }
  }
}
