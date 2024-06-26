import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/exports.dart' hide TextDirection;
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnFilterTabChange = Function(BookmarkFilter filter);

const _tabHeight = 46.0;
const _tabIndicatorWeight = 2.0;
const _filterList = [
  BookmarkFilter.all,
  BookmarkFilter.topic,
  BookmarkFilter.article,
];

class SavedFilterTabBar extends StatelessWidget {
  const SavedFilterTabBar({
    required this.controller,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final TabController controller;
  final OnFilterTabChange onChange;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
      ),
      child: TabBar(
        onTap: (index) {
          final filter = _filterList[index];
          onChange(filter);
        },
        controller: controller,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: AppColors.of(context).textPrimary,
        isScrollable: true,
        unselectedLabelStyle: AppTypography.h4Medium,
        labelStyle: AppTypography.h4Medium,
        indicatorWeight: _tabIndicatorWeight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
        labelPadding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
        splashFactory: NoSplash.splashFactory,
        tabs: List.generate(
          _filterList.length,
          (index) => _filterList[index].tab(context),
        ),
      ),
    );
  }
}

/// Removes ugly tab resizing glitch on tab change (as text was getting bold)
class _TextFixedSizeTab extends HookWidget {
  const _TextFixedSizeTab({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final width = useMemoized(
      () {
        final textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(text: text, style: AppTypography.h4Medium),
          textAlign: TextAlign.left,
          maxLines: 1,
        );
        textPainter.layout(maxWidth: double.infinity);
        return textPainter.width;
      },
      [text],
    );

    return SizedBox(
      width: width,
      child: Tab(
        height: _tabHeight,
        text: text,
      ),
    );
  }
}

extension on BookmarkFilter {
  Widget tab(BuildContext context) {
    switch (this) {
      case BookmarkFilter.all:
        return _TextFixedSizeTab(
          text: context.l10n.profile_filter_all,
        );
      case BookmarkFilter.topic:
        return _TextFixedSizeTab(
          text: context.l10n.profile_filter_topics,
        );
      case BookmarkFilter.article:
        return _TextFixedSizeTab(
          text: context.l10n.profile_filter_articles,
        );
    }
  }
}
