import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

typedef OnPurchasePressed = void Function(SubscriptionPlan plan);

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    required this.plan,
    required this.isLoading,
    required this.onPurchasePressed,
    Key? key,
  }) : super(key: key);

  final SubscriptionPlan plan;
  final bool isLoading;
  final OnPurchasePressed onPurchasePressed;

  @override
  Widget build(BuildContext context) {
    final text = plan.hasTrial ? LocaleKeys.subscription_tryForFreeAction.tr() : LocaleKeys.subscription_subscribe.tr();

    return FilledButton(
      text: text,
      onTap: () => onPurchasePressed(plan),
      isLoading: isLoading,
    );
  }
}
