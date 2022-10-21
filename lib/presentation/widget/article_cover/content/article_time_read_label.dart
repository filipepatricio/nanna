import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/visited_check.dart';
import 'package:flutter/material.dart';

class ArticleTimeReadLabel extends StatelessWidget {
  const ArticleTimeReadLabel({
    required this.visited,
    required this.timeToRead,
    Key? key,
  }) : super(key: key);

  final bool visited;
  final int? timeToRead;

  @override
  Widget build(BuildContext context) {
    return visited
        ? Row(
            children: [
              const VisitedCheck(),
              const SizedBox(width: AppDimens.s),
              Text(
                LocaleKeys.article_read.tr(),
                style: AppTypography.caption1Medium.copyWith(
                  height: 1.2,
                  color: AppColors.textGrey,
                ),
              )
            ],
          )
        : Container(
            child: timeToRead == null
                ? const SizedBox()
                : Text(
                    LocaleKeys.article_readMinutes.tr(args: [timeToRead.toString()]),
                    style: AppTypography.caption1Medium.copyWith(
                      height: 1.2,
                      color: AppColors.textGrey,
                    ),
                  ),
          );
  }
}
