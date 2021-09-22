import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyReadsListItem extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
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
                  child: Container(
                    color: AppColors.limeGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.m),
          //TODO: implement Stacked cards, fix resizing
          // ReadingListStackedCards(
          //   coverSize: Size(
          //     // MediaQuery.of(context).size.width * 0.42,
          //     // MediaQuery.of(context).size.height * 0.32,
          //   ),
          //   child: const ReadingListCover(),
          // ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: AppDimens.xs,
                  percent: 5/7,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: AppColors.grey.withOpacity(0.44),
                  progressColor: AppColors.limeGreen,
                ),
                const SizedBox(height: AppDimens.s),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '5',
                        style: AppTypography.systemText.copyWith(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: '/7 articles read',
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
}
