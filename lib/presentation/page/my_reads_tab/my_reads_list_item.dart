import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/my_reads/data/my_reads_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover_small.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

const _rowHeight = 261.0;

class MyReadsListItem extends HookWidget {
  final MyReadsItem item;

  const MyReadsListItem({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _rowHeight,
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.only(left: AppDimens.s),
                child: ReadingListStackedCards(
                  coverSize: Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  ),
                  child: ReadingListCoverSmall(
                    topic: item.topic,
                    onTap: () => _onTap(context),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: AppDimens.xs,
                  percent: item.finishedArticlesCount / item.articlesCount,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: AppColors.grey.withOpacity(0.44),
                  progressColor: AppColors.limeGreen,
                ),
                const SizedBox(height: AppDimens.s),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: item.finishedArticlesCount.toString(),
                        style: AppTypography.systemText.copyWith(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: LocaleKeys.myReads_articlesRead.tr(args: [item.articlesCount.toString()]),
                        style: AppTypography.systemText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                Expanded(
                  child: Center(
                    child: Text(
                      'You are about to finish reading and being all informed!',
                      style: AppTypography.b3Regular.copyWith(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.m),
                UpdatedLabel(
                  text: 'Updated 30 min ago'.toUpperCase(),
                  backgroundColor: AppColors.pastelGreen,
                ),
                const SizedBox(height: AppDimens.l),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: AppDimens.xxl,
                      width: AppDimens.xxl,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: SvgPicture.asset(AppVectorGraphics.share, color: AppColors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.m),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Object?> _onTap(BuildContext context) {
    return AutoRouter.of(context).push(
      SingleTopicPageRoute(
        topic: item.topic,
      ),
    );
  }
}
