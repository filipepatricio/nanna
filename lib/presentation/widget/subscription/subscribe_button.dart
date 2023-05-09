import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

typedef OnPurchasePressed = void Function(SubscriptionPlan plan);

enum SubscriptionButtonContentType { lite, full }

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    required this.selectedPlan,
    required this.isLoading,
    required this.onPurchasePressed,
    this.isEnabled = true,
    this.currentPlan,
  });

  final SubscriptionPlan? currentPlan;
  final SubscriptionPlan selectedPlan;
  final bool isLoading;
  final bool isEnabled;
  final OnPurchasePressed onPurchasePressed;

  @override
  Widget build(BuildContext context) {
    final text = currentPlan != null
        ? context.l10n.subscription_change_confirm
        : selectedPlan.hasTrial
            ? context.l10n.subscription_button_trialText
            : context.l10n.subscription_button_standard;

    return InformedFilledButton.primary(
      context: context,
      text: text,
      isLoading: isLoading,
      isEnabled: isEnabled,
      onTap: () => onPurchasePressed(selectedPlan),
    );
  }
}
