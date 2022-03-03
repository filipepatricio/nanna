import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';

class BookmarkListTile extends StatelessWidget {
  const BookmarkListTile({
    required this.bookmark,
    Key? key,
  }) : super(key: key);

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.l,
        vertical: AppDimens.m,
      ),
      height: 240,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: 120,
            color: AppColors.beige,
          ),
          const SizedBox(width: AppDimens.xl),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  bookmark.title,
                  style: AppTypography.b1Bold,
                ),
                ...bookmark.updatedLabel,
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on Bookmark {
  String get title {
    return data.map(
      article: (data) => data.article.title,
      topic: (data) => data.topic.title,
      unknown: (_) => '',
    );
  }

  List<Widget> get updatedLabel {
    return data.mapOrNull(
          topic: (data) => [
            const SizedBox(height: AppDimens.m),
            UpdatedLabel(
              dateTime: data.topic.lastUpdatedAt,
              backgroundColor: AppColors.transparent,
            ),
          ],
        ) ??
        const [];
  }
}
