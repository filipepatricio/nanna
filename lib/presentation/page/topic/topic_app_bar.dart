import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class TopicAppBar extends StatelessWidget {
  final Topic topic;
  final double backgroundAnimationFactor;
  final double foregroundAnimationFactor;
  final double elevation;

  const TopicAppBar({
    required this.topic,
    required this.backgroundAnimationFactor,
    required this.foregroundAnimationFactor,
    this.elevation = 3.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final whiteToBlack = ColorTween(begin: AppColors.white, end: AppColors.textPrimary);
    final transparentToWhite = ColorTween(begin: AppColors.transparent, end: AppColors.background);
    final transparentToBlack = ColorTween(begin: AppColors.transparent, end: AppColors.black);

    return AppBar(
      backgroundColor: transparentToWhite.transform(backgroundAnimationFactor),
      elevation: elevation,
      shadowColor: AppColors.black.withOpacity(0.4),
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: backgroundAnimationFactor >= 0.5 ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      title: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: AppDimens.backArrowSize,
            color: whiteToBlack.transform(foregroundAnimationFactor),
            onPressed: () => AutoRouter.of(context).pop(),
          ),
          const Spacer(),
          InformedMarkdownBody(
            markdown: topic.title.length > 20 ? '${topic.title.substring(0, 20)}...' : topic.title,
            textAlignment: TextAlign.center,
            highlightColor: AppColors.transparent,
            baseTextStyle: AppTypography.h4Bold.copyWith(
              height: 1,
              color: transparentToBlack.transform(foregroundAnimationFactor),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => shareReadingList(context, topic),
            padding: const EdgeInsets.only(right: AppDimens.s),
            icon: SvgPicture.asset(
              AppVectorGraphics.share,
              color: whiteToBlack.transform(foregroundAnimationFactor),
            ),
          ),
        ],
      ),
    );
  }
}
