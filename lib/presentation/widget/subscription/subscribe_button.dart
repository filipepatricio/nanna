import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

typedef OnPurchasePressed = void Function(SubscriptionPlan plan);

class SubscribeButton extends StatelessWidget {
  const SubscribeButton._({
    required this.plan,
    required this.isLoading,
    required this.onPurchasePressed,
    required this.mode,
    Key? key,
  }) : super(key: key);

  factory SubscribeButton.light({
    required SubscriptionPlan plan,
    required bool isLoading,
    required OnPurchasePressed onPurchasePressed,
  }) =>
      SubscribeButton._(
        plan: plan,
        isLoading: isLoading,
        onPurchasePressed: onPurchasePressed,
        mode: Brightness.light,
      );

  factory SubscribeButton.dark({
    required SubscriptionPlan plan,
    required bool isLoading,
    required OnPurchasePressed onPurchasePressed,
  }) =>
      SubscribeButton._(
        plan: plan,
        isLoading: isLoading,
        onPurchasePressed: onPurchasePressed,
        mode: Brightness.dark,
      );

  final Brightness mode;
  final SubscriptionPlan plan;
  final bool isLoading;
  final OnPurchasePressed onPurchasePressed;

  @override
  Widget build(BuildContext context) {
    final text = plan.hasTrial ? LocaleKeys.subscription_tryForFreeAction.tr() : LocaleKeys.subscription_subscribe.tr();

    if (mode == Brightness.dark) {
      return FilledButton.black(
        text: text,
        onTap: () => onPurchasePressed(plan),
        isLoading: isLoading,
      );
    }

    return FilledButton.green(
      text: text,
      onTap: () => onPurchasePressed(plan),
      isLoading: isLoading,
    );
  }
}
