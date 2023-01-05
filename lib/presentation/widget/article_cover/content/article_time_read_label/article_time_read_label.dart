import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_time_read_label/article_time_read_label_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/visited_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleTimeReadLabel extends HookWidget {
  const ArticleTimeReadLabel({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ArticleTimeReadLabelCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize(article);
      },
      [cubit, article],
    );

    return state.map(
      initializing: (_) => const SizedBox.shrink(),
      idle: (state) => state.progressState == ArticleProgressState.finished
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
              child: state.timeToRead == null
                  ? const SizedBox()
                  : Text(
                      LocaleKeys.article_readMinutes.tr(args: [state.timeToRead.toString()]),
                      style: AppTypography.sansTextNanoLausanne.copyWith(
                        color: AppColors.of(context).textSecondary,
                      ),
                      textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                    ),
            ),
    );
  }
}
