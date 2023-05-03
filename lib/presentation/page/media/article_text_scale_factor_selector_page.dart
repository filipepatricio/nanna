import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_text_scale_factor_selector.dart';
import 'package:flutter/material.dart';

class ArticleTextScaleFactorSelectorPage extends StatelessWidget {
  const ArticleTextScaleFactorSelectorPage({
    required this.articleTextScaleFactorNotifier,
    required this.onChangeEnd,
  });

  final ValueNotifier<double> articleTextScaleFactorNotifier;
  final Function(double) onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.bottomSheetRadius),
        ),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppDimens.m,
              bottom: AppDimens.xl,
            ),
            child: ArticleTextScaleFactorSelector(
              labelStyle: AppTypography.b2Medium,
              articleTextScaleFactorNotifier: articleTextScaleFactorNotifier,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ),
      ),
    );
  }
}
