import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubscriptionSectionView extends StatelessWidget {
  const SubscriptionSectionView({
    required this.onManageSubscriptionPressed,
    super.key,
  });

  final VoidCallback onManageSubscriptionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.subscription_section_subscription,
          style: AppTypography.subH1Medium.copyWith(
            color: AppColors.of(context).textTertiary,
            height: 2.1,
          ),
        ),
        const SizedBox(height: AppDimens.xs),
        GestureDetector(
          onTap: onManageSubscriptionPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.subscription_manageSubscription,
                    style: AppTypography.b2Regular,
                  ),
                ),
                const SizedBox(width: AppDimens.m),
                SvgPicture.asset(
                  AppVectorGraphics.subscriptionManage,
                  color: AppColors.of(context).iconPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
