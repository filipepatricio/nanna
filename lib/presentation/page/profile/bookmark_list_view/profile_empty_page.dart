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
          SvgPicture.asset(AppVectorGraphics.bookmarkOutline),
          const SizedBox(height: AppDimens.m),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr(LocaleKeys.profile_emptyPage_title),
                  style: AppTypography.b2Medium,
                ),
                TextSpan(
                  text: filter.infoText,
                  style: AppTypography.b2Medium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.xl),
          Center(
            child: FilledButton.black(
              text: LocaleKeys.profile_emptyPage_action.tr(),
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
  String get infoText {
    switch (this) {
      case BookmarkFilter.all:
        return tr(LocaleKeys.profile_emptyPage_noAll);
      case BookmarkFilter.topic:
        return tr(LocaleKeys.profile_emptyPage_noTopics);
      case BookmarkFilter.article:
        return tr(LocaleKeys.profile_emptyPage_noArticles);
    }
  }
}
