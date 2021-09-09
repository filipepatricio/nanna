import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyReadsListItem extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: AppColors.limeGreen,
          width: MediaQuery.of(context).size.width * 0.42,
          height: MediaQuery.of(context).size.height * 0.32,
        ),
        //TODO: implement Stacked cards, fix resizing
        // ReadingListStackedCards(
        //   coverSize: Size(
        //     // MediaQuery.of(context).size.width * 0.42,
        //     // MediaQuery.of(context).size.height * 0.32,
        //   ),
        //   child: const ReadingListCover(),
        // ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: AppDimens.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  lineHeight: AppDimens.xs,
                  percent: 0.7,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: AppColors.grey.withOpacity(0.44),
                  progressColor: AppColors.limeGreen,
                ),
                const SizedBox(height: AppDimens.s),
                Row(
                  children: [
                    Text('5', style: AppTypography.systemText.copyWith(fontWeight: FontWeight.w800)),
                    Text('/7 articles read', style: AppTypography.systemText),
                  ],
                ),
                const SizedBox(height: AppDimens.xxl),
                Text(
                  'You are about to finish reading and being all informed!',
                  style: AppTypography.b3Regular.copyWith(fontSize: 16),
                ),
                const SizedBox(height: AppDimens.m),
                Container(
                  color: AppColors.limeGreenBleached,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.s),
                    child: Text(
                      'Updated 30 min Ago',
                      style: AppTypography.h5BoldSmall.copyWith(fontSize: 9),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.xxl),
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
        ),
      ],
    );
  }
}
