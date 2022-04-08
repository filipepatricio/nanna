import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BackToTopicButton extends StatelessWidget {
  const BackToTopicButton({
    required this.fromTopic,
    required this.showButton,
    Key? key,
  }) : super(key: key);

  final bool fromTopic;
  final ValueNotifier<bool> showButton;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: showButton.value ? AppDimens.l : -AppDimens.c,
      curve: Curves.elasticInOut,
      duration: const Duration(milliseconds: 500),
      child: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.s)),
        onPressed: () => context.popRoute(),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        label: Text(
          fromTopic ? tr(LocaleKeys.article_goBackToTopic) : tr(LocaleKeys.article_goBackToExplore),
          style: AppTypography.h4Bold.copyWith(height: 1.0, color: AppColors.white),
        ),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppDimens.backArrowSize,
        ),
      ),
    );
  }
}
