import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/visited_check.dart';
import 'package:flutter/material.dart';

class ArticleTimeReadLabel extends StatelessWidget {
  const ArticleTimeReadLabel({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    return article.finished
        ? Row(
            children: [
              const VisitedCheck(),
              const SizedBox(width: AppDimens.s),
              Text(
                LocaleKeys.article_read.tr(),
                style: AppTypography.sansTextNanoLausanne.copyWith(
                  color: AppColors.of(context).textSecondary,
                ),
                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
              )
            ],
          )
        : Container(
            child: article.timeToRead == null
                ? const SizedBox()
                : Text(
                    LocaleKeys.article_readMinutes.tr(args: [article.timeToRead.toString()]),
                    style: AppTypography.sansTextNanoLausanne.copyWith(
                      color: AppColors.of(context).textSecondary,
                    ),
                    textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                  ),
          );
  }
}
