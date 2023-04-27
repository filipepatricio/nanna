import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class ArticleTextScaleFactorSelector extends StatelessWidget {
  const ArticleTextScaleFactorSelector({
    required this.articleTextScaleFactorNotifier,
    required this.onChangeEnd,
    this.labelStyle = AppTypography.sansTextSmallLausanne,
  });

  final ValueNotifier<double> articleTextScaleFactorNotifier;
  final Function(double) onChangeEnd;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: articleTextScaleFactorNotifier,
      builder: (context, scale, _) => Column(
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
                  '${articleTextScaleFactorNotifier.value * 100 ~/ 1}%',
                  style: AppTypography.b2Medium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.m),
          Slider(
            min: AppDimens.minScaleFactor,
            max: AppDimens.maxScaleFactor,
            value: scale,
            thumbColor: AppColors.of(context).buttonPrimaryText,
            activeColor: AppColors.of(context).textPrimary,
            inactiveColor: AppColors.of(context).backgroundSecondary,
            onChanged: (value) => articleTextScaleFactorNotifier.value = value,
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }
}
