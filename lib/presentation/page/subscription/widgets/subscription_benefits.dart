import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionBenefits extends StatelessWidget {
  const SubscriptionBenefits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...[
          _SubscriptionBenefitLine(text: LocaleKeys.subscription_benefit_access.tr()),
          _SubscriptionBenefitLine(text: LocaleKeys.subscription_benefit_fresh.tr()),
          _SubscriptionBenefitLine(text: LocaleKeys.subscription_benefit_read.tr()),
        ].withDividers(
          divider: const SizedBox(height: AppDimens.m),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(AppVectorGraphics.checkmark),
        const SizedBox(width: AppDimens.s),
        Text(
          text,
          style: AppTypography.subH1Medium,
        ),
      ],
    );
  }
}
