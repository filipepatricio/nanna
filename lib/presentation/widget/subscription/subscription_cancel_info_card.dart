import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class SubscriptionCancelInfoCard extends StatelessWidget {
  const SubscriptionCancelInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.m),
      decoration: BoxDecoration(
        color: AppColors.of(context).backgroundSecondary,
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.modalRadius)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.subscription_info_cancelTitle,
            style: AppTypography.sansTextSmallLausanne.w550,
          ),
          Text(
            context.l10n.subscription_info_cancelDescription,
            style: AppTypography.sansTextSmallLausanne.copyWith(color: AppColors.of(context).textSecondary),
          ),
        ],
      ),
    );
  }
}
