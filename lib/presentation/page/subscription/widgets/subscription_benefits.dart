import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class SubscriptionBenefits extends StatelessWidget {
  const SubscriptionBenefits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...[
          _SubscriptionBenefitLine(text: context.l10n.subscription_benefit_one),
          _SubscriptionBenefitLine(text: context.l10n.subscription_benefit_two),
          _SubscriptionBenefitLine(text: context.l10n.subscription_benefit_three),
        ].withDividers(
          divider: const SizedBox(height: AppDimens.xs),
        )
      ],
    );
  }
}

class _SubscriptionBenefitLine extends StatelessWidget {
  const _SubscriptionBenefitLine({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: AppDimens.xxs),
          child: InformedSvg(
            AppVectorGraphics.checkmark,
            height: AppDimens.ml,
            width: AppDimens.ml,
          ),
        ),
        const SizedBox(width: AppDimens.s),
        Expanded(
          child: Text(
            text,
            style: AppTypography.sansTextSmallLausanne,
          ),
        ),
      ],
    );
  }
}
