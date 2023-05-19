import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_text_scale_factor_selector.dart';
import 'package:flutter/material.dart';

class ArticleTextScaleFactorSelectorPage extends StatelessWidget {
  const ArticleTextScaleFactorSelectorPage({
    required this.onChangeEnd,
  });

  final Function(double) onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimens.bottomSheetRadius),
          topRight: Radius.circular(AppDimens.bottomSheetRadius),
        ),
        child: Material(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppDimens.m,
              bottom: AppDimens.xl + bottomPadding,
            ),
            child: ArticleTextScaleFactorSelector(
              labelStyle: AppTypography.b2Medium,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ),
      ),
    );
  }
}
