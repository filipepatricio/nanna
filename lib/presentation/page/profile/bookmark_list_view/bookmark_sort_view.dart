import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const _borderRadius = 10.0;
const sortViewHeight = 60.0;

Future<BookmarkSortConfig?> showBookmarkSortOptionBottomSheet(
  BuildContext context,
  BookmarkSortConfig config,
) async {
  return showModalBottomSheet<BookmarkSortConfig>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(_borderRadius),
      ),
    ),
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return _BookmarkSortOptionBottomSheet(config: config);
    },
  );
}

class BookmarkSortView extends StatelessWidget {
  const BookmarkSortView({
    required this.config,
    required this.onSortConfigChange,
    Key? key,
  }) : super(key: key);

  final BookmarkSortConfig? config;
  final OnSortConfigChanged onSortConfigChange;

  @override
  Widget build(BuildContext context) {
    final enabled = config != null;

    if (enabled) {
      return GestureDetector(
        onTap: () async {
          final newConfig = await showBookmarkSortOptionBottomSheet(
            context,
            config!,
          );
          if (newConfig != null) onSortConfigChange(newConfig.type);
        },
        child: Container(
          height: sortViewHeight,
          alignment: Alignment.centerLeft,
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.l,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppVectorGraphics.sort),
              const SizedBox(width: AppDimens.s),
              Text(
                config!.type.title,
                style: AppTypography.subH1Regular.copyWith(height: 1.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: sortViewHeight,
        alignment: Alignment.centerLeft,
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.l,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppVectorGraphics.sort,
              color: AppColors.textGrey,
            ),
            const SizedBox(width: AppDimens.s),
            Text(
              tr(LocaleKeys.bookmark_sortBy),
              style: AppTypography.subH1Regular.copyWith(
                color: AppColors.textGrey,
                height: 1.0,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _BookmarkSortOptionBottomSheet extends StatelessWidget {
  const _BookmarkSortOptionBottomSheet({
    required this.config,
    Key? key,
  }) : super(key: key);

  final BookmarkSortConfig config;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(_borderRadius),
      ),
      color: AppColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.m),
              Row(
                children: [
                  const SizedBox(width: AppDimens.l),
                  Expanded(
                    child: Text(
                      tr(LocaleKeys.bookmark_sortBy),
                      style: AppTypography.b2Bold,
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(AppVectorGraphics.close),
                    onPressed: () => AutoRouter.of(context).root.pop(),
                  ),
                  const SizedBox(width: AppDimens.l),
                ],
              ),
              const SizedBox(height: AppDimens.m),
              const InformedDivider(),
              const SizedBox(height: AppDimens.l),
              ...bookmarkConfigMap.entries
                  .map(
                    (entry) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => AutoRouter.of(context).root.pop(entry.value),
                      child: Row(
                        children: [
                          const SizedBox.square(dimension: AppDimens.l),
                          if (config == entry.value)
                            SvgPicture.asset(
                              AppVectorGraphics.checkmark,
                              height: AppDimens.l,
                              width: AppDimens.l,
                            )
                          else
                            const SizedBox.square(dimension: AppDimens.l),
                          const SizedBox(width: AppDimens.s),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.l,
                              ),
                              child: Text(
                                entry.key.title,
                                style: config == entry.value ? AppTypography.b2Bold : AppTypography.b2Regular,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .expand(
                    (element) => [
                      element,
                      const SizedBox(height: AppDimens.l),
                    ],
                  )
                  .toList(growable: false),
            ],
          ),
        ),
      ),
    );
  }
}

extension on BookmarkSortConfigName {
  String get title {
    switch (this) {
      case BookmarkSortConfigName.lastUpdated:
        return tr(LocaleKeys.bookmark_bookmarkSortConfig_lastUpdated);
      case BookmarkSortConfigName.lastAdded:
        return tr(LocaleKeys.bookmark_bookmarkSortConfig_lastAdded);
      case BookmarkSortConfigName.alphabeticalAsc:
        return tr(LocaleKeys.bookmark_bookmarkSortConfig_alphabeticalAsc);
      case BookmarkSortConfigName.alphabeticalDesc:
        return tr(LocaleKeys.bookmark_bookmarkSortConfig_alphabeticalDesc);
    }
  }
}

extension on BookmarkSortConfig {
  BookmarkSortConfigName get type {
    return bookmarkConfigMap.entries
        .firstWhere(
          (element) => element.value == this,
        )
        .key;
  }
}
