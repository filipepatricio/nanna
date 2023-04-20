part of 'subscription_plans_view.dart';

class _SubscriptionCancelInfoCard extends StatelessWidget {
  const _SubscriptionCancelInfoCard({super.key});

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
            style: AppTypography.sansTextSmallLausanneBold,
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
