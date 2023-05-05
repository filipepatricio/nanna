import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article_text_scale_factor_notifier.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class ArticleTextScaleFactorSelector extends StatelessWidget {
  const ArticleTextScaleFactorSelector({
    required this.onChangeEnd,
    this.labelStyle = AppTypography.sansTextSmallLausanne,
  });

  final Function(double) onChangeEnd;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.article_textSize,
                style: labelStyle,
              ),
              Text(
                '${context.watch<ArticleTextScaleFactorNotifier>().textScaleFactor * 100 ~/ 1}%',
                style: AppTypography.b2Medium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.m),
        Slider(
          min: AppDimens.minScaleFactor,
          max: AppDimens.maxScaleFactor,
          value: context.watch<ArticleTextScaleFactorNotifier>().textScaleFactor,
          thumbColor: AppColors.stateTextSecondary,
          activeColor: AppColors.of(context).textPrimary,
          inactiveColor: AppColors.of(context).backgroundSecondary,
          onChanged: context.read<ArticleTextScaleFactorNotifier>().updateTextScaleFactor,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}
