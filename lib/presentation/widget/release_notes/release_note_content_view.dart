import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

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
                  horizontal: AppDimens.sl,
                ),
                decoration: BoxDecoration(
                  color: AppColors.of(context).backgroundSecondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(70),
                  ),
                ),
                child: Text(
                  context.l10n.releaseNotes_updateLabel,
                  style: AppTypography.caption1Regular,
                ),
              ),
              const Spacer(),
              Text(
                DateFormatUtil.formatFullMonthNameDayYear(releaseNote.date),
                style: AppTypography.b3Medium.copyWith(
                  color: AppColors.of(context).textTertiary,
                ),
              ),
              if (showCloseButton) ...[
                const SizedBox(width: AppDimens.m),
                PaddingTapWidget(
                  onTap: () => context.popRoute(),
                  tapPadding: const EdgeInsets.all(AppDimens.m),
                  child: const InformedSvg(
                    AppVectorGraphics.closeBackground,
                    colored: false,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimens.m),
          Text(
            releaseNote.headline,
            style: AppTypography.h0Medium,
          ),
          const SizedBox(height: AppDimens.s),
          Text(
            releaseNote.content,
            style: AppTypography.b2Medium.copyWith(color: AppColors.of(context).textSecondary),
          ),
        ],
      ),
    );
  }
}
