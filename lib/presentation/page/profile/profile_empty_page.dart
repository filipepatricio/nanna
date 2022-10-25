import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileEmptyPage extends StatelessWidget {
  const ProfileEmptyPage({
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
              text: filter.buttonText,
              onTap: filter.buttonAction(context),
            ),
          ),
        ],
      ),
    );
  }
}

extension on BookmarkFilter {
  String get infoText {
    switch (this) {
      case BookmarkFilter.topic:
      case BookmarkFilter.all:
        return tr(LocaleKeys.profile_emptyPage_noTopics);
      case BookmarkFilter.article:
        return tr(LocaleKeys.profile_emptyPage_noArticles);
    }
  }

  String get buttonText {
    switch (this) {
      case BookmarkFilter.topic:
        return tr(LocaleKeys.profile_emptyPage_topicAction);
      case BookmarkFilter.all:
      case BookmarkFilter.article:
        return tr(LocaleKeys.profile_emptyPage_articleAction);
    }
  }

  VoidCallback buttonAction(BuildContext context) {
    switch (this) {
      case BookmarkFilter.topic:
        return () {
          AutoRouter.of(context).navigate(
            const DailyBriefTabGroupRouter(
              children: [
                DailyBriefPageRoute(),
              ],
            ),
          );
        };
      case BookmarkFilter.all:
      case BookmarkFilter.article:
        return () {
          AutoRouter.of(context).navigate(
            const ExploreTabGroupRouter(
              children: [
                ExplorePageRoute(),
              ],
            ),
          );
        };
    }
  }
}
