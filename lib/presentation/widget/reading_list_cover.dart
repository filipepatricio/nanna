import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReadingListCover extends StatelessWidget {
  const ReadingListCover({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage('url'),  // TODO will be coming from API
        //     fit: BoxFit.cover,
        //     alignment: Alignment.center,
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppDimens.l),
              child: _AuthorRow(),
            ),
            const Expanded(
              child: Align(
                alignment: Alignment(0.0, 0.1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: Text(
                    'Climate forward', // TODO will be coming from API
                    style: AppTypography.h0SemiBold,
                  ),
                ),
              ),
            ),
            Container(
              height: 1.0,
              color: AppColors.textPrimary,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.readingList_articleCount.tr(args: ['7']),
                    style: AppTypography.metadata1Regular,
                  ),
                  const Spacer(),
                  const ReadMoreLabel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppRasterGraphics.editorSample),
        const SizedBox(width: AppDimens.s),
        Text(
          'By Editorial Team', // TODO probably will be coming from API
          style: AppTypography.metadata2Bold.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
