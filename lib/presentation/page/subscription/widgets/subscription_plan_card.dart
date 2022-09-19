part of '../subscription_page.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    required this.plan,
    required this.selectedPlanNotifier,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan plan;
  final VoidCallback? onTap;
  final ValueNotifier<SubscriptionPlan> selectedPlanNotifier;

  @override
  Widget build(BuildContext context) {
    const animationsDuration = Duration(milliseconds: 200);
    return GestureDetector(
      onTap: () {
        onTap?.call();
        selectedPlanNotifier.value = plan;
      },
      child: ValueListenableBuilder(
        valueListenable: selectedPlanNotifier,
        builder: (context, selectedPlan, child) => AnimatedContainer(
          duration: animationsDuration,
          padding: const EdgeInsets.all(AppDimens.m),
          decoration: BoxDecoration(
            border: Border.all(color: selectedPlan == plan ? AppColors.charcoal : AppColors.lightGrey),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.ml),
            ),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: AutoSizeText(
                  plan.title,
                  style: AppTypography.h4ExtraBold.copyWith(height: 1),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: AppDimens.xs),
              Text(
                plan.description,
                style: AppTypography.b1Medium.copyWith(color: AppColors.darkerGrey),
              ),
              const SizedBox(height: AppDimens.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan.priceString,
                    style: AppTypography.h4ExtraBold,
                  ),
                  if (plan.discountPercentage > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.xs,
                        horizontal: AppDimens.s,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.pastelPurple,
                      ),
                      child: Text(
                        LocaleKeys.subscription_off.tr(args: [('${plan.discountPercentage}')]),
                        style: AppTypography.topicOwnerLabelText,
                      ),
                    ),
                ],
              ),
              AnimatedOpacity(
                opacity: selectedPlan == plan ? 1 : 0,
                duration: animationsDuration,
                child: AnimatedSize(
                  duration: animationsDuration,
                  curve: Curves.linearToEaseOut,
                  child: selectedPlan == plan
                      ? Padding(
                          padding: const EdgeInsets.only(top: AppDimens.l),
                          child: _Timeline(plan: plan),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
