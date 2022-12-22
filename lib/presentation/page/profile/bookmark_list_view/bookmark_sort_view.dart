import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

const _borderRadius = 10.0;

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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (enabled) {
          final newConfig = await showBookmarkSortOptionBottomSheet(
            context,
            config!,
          );
          if (newConfig != null) onSortConfigChange(newConfig.type);
        }
      },
      child: InformedSvg(
        AppVectorGraphics.sort,
        color: enabled ? AppColors.of(context).iconPrimary : AppColors.of(context).iconSecondary,
        fit: BoxFit.scaleDown,
        height: AppDimens.l,
        width: AppDimens.l,
      ),
    );
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
      color: AppColors.of(context).backgroundPrimary,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.m),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tr(LocaleKeys.bookmark_sortBy),
                        style: AppTypography.b2Bold,
                      ),
                    ),
                    PaddingTapWidget(
                      alignment: AlignmentDirectional.centerEnd,
                      tapPadding: const EdgeInsets.all(AppDimens.m),
                      onTap: () => AutoRouter.of(context).root.pop(),
                      child: const InformedSvg(AppVectorGraphics.close),
                    ),
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
                            Text(
                              entry.key.title,
                              style: config == entry.value ? AppTypography.b2Bold : AppTypography.b2Regular,
                            ),
                            const Spacer(),
                            if (config == entry.value)
                              const InformedSvg(
                                AppVectorGraphics.done,
                                height: AppDimens.l,
                                width: AppDimens.l,
                                colored: false,
                              )
                            else
                              const SizedBox.shrink(),
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
