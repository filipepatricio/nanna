import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _pageViewHeight = 550.0;

class ReadingListSectionView extends HookWidget {
  const ReadingListSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.xc),
        Row(
          children: [
            const Expanded(
              child: InformedMarkdownBody(
                markdown: '**Reading** list',
                baseTextStyle: AppTypography.h1,
              ),
            ),
            const SizedBox(width: AppDimens.s),
            SeeAllButton(onTap: () {}),
          ],
        ),
        const SizedBox(height: AppDimens.l),
        Container(
          height: _pageViewHeight,
          child: PageView.builder(
            controller: controller,
            itemBuilder: (context, index) => Container(color: AppColors.white),
            itemCount: 5,
          ),
        ),
        const SizedBox(height: AppDimens.l),
        PageDotIndicator(
          pageCount: 5,
          controller: controller,
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}
