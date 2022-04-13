import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_tooltip.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhotoCaption extends HookWidget {
  const PhotoCaption({
    required this.caption,
    Key? key,
  }) : super(key: key);

  final String caption;

  @override
  Widget build(BuildContext context) {
    final showPhotoCaptionTooltip = useState(false);
    return Stack(
      children: [
        if (showPhotoCaptionTooltip.value)
          Positioned(
            bottom: 96,
            right: AppDimens.m,
            left: AppDimens.m,
            child: InformedTooltip(
              text: caption,
              style: AppTypography.metadata1Regular.copyWith(height: 1.4),
              actionButtonText: LocaleKeys.topic_displayFullImage.tr(),
              onActionButtonTap: () {
                //TODO: show full width image
              },
              onDismiss: () {
                showPhotoCaptionTooltip.value = false;
              },
            ),
          ),
        Positioned(
          bottom: AppDimens.xxl,
          right: AppDimens.xxl,
          child: ExpandTapWidget(
            tapPadding: const EdgeInsets.all(AppDimens.m),
            onTap: () {
              showPhotoCaptionTooltip.value = true;
            },
            child: SvgPicture.asset(
              AppVectorGraphics.photoCaption,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
