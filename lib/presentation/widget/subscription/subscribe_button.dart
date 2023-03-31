import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

typedef OnPurchasePressed = void Function(SubscriptionPlan plan);

enum SubscriptionButtonContentType { lite, full }

class SubscribeButton extends StatelessWidget {
  const SubscribeButton._({
    required this.plan,
    required this.mode,
    required this.isLoading,
    required this.onPurchasePressed,
    this.contentType = SubscriptionButtonContentType.full,
    Key? key,
  }) : super(key: key);

  factory SubscribeButton.light({
    required SubscriptionPlan plan,
    required bool isLoading,
    required OnPurchasePressed onPurchasePressed,
    SubscriptionButtonContentType contentType = SubscriptionButtonContentType.full,
  }) =>
      SubscribeButton._(
        plan: plan,
        isLoading: isLoading,
        onPurchasePressed: onPurchasePressed,
        contentType: contentType,
        mode: Brightness.light,
      );

  factory SubscribeButton.dark({
    required SubscriptionPlan plan,
    required bool isLoading,
    required OnPurchasePressed onPurchasePressed,
    SubscriptionButtonContentType contentType = SubscriptionButtonContentType.full,
  }) =>
      SubscribeButton._(
        plan: plan,
        isLoading: isLoading,
        onPurchasePressed: onPurchasePressed,
        contentType: contentType,
        mode: Brightness.dark,
      );

  final SubscriptionPlan plan;
  final Brightness mode;
  final bool isLoading;
  final OnPurchasePressed onPurchasePressed;
  final SubscriptionButtonContentType contentType;

  @override
  Widget build(BuildContext context) {
    final text = plan.hasTrial && contentType == SubscriptionButtonContentType.full
        ? context.l10n.subscription_button_trialText(
            context.l10n.date_daySuffix('${plan.trialDays}'),
          )
        : context.l10n.subscription_button_standard;

    if (mode == Brightness.dark) {
      return InformedFilledButton.primary(
        context: context,
        text: text,
        onTap: () => onPurchasePressed(plan),
        isLoading: isLoading,
      );
    }

    return InformedFilledButton.accent(
      context: context,
      text: text,
      onTap: () => onPurchasePressed(plan),
      isLoading: isLoading,
    );
  }
}
