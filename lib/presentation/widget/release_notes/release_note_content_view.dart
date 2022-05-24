import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReleaseNoteContentView extends StatelessWidget {
  const ReleaseNoteContentView({
    required this.releaseNote,
    required this.showCloseButton,
    Key? key,
  }) : super(key: key);

  final ReleaseNote releaseNote;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.xs,
                  horizontal: AppDimens.s,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.pastelPurple,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimens.xs),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(AppVectorGraphics.productUpdate),
                    const SizedBox(width: AppDimens.xs),
                    Text(
                      LocaleKeys.releaseNotes_updateLabel.tr(),
                      style: AppTypography.caption2Medium.copyWith(color: AppColors.black),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                DateFormatUtil.formatFullMonthNameDayYear(releaseNote.date),
                style: AppTypography.b2MediumLora.copyWith(color: AppColors.textGrey),
              ),
              if (showCloseButton) ...[
                const SizedBox(width: AppDimens.m),
                IconButton(
                  onPressed: () => context.popRoute(),
                  icon: SvgPicture.asset(AppVectorGraphics.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    maxHeight: AppDimens.l,
                    maxWidth: AppDimens.l,
                  ),
                  splashRadius: AppDimens.l,
                ),
              ],
            ],
          ),
          if (context.isSmallDevice) const SizedBox(height: AppDimens.s) else const SizedBox(height: AppDimens.l),
          Text(
            releaseNote.headline,
            style: context.isSmallDevice ? AppTypography.subtitle1Bold : AppTypography.h5Bold,
          ),
          if (context.isSmallDevice) const SizedBox(height: AppDimens.zero) else const SizedBox(height: AppDimens.l),
          Text(
            releaseNote.content,
            style: AppTypography.b1Medium,
          ),
        ],
      ),
    );
  }
}
