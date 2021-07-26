import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingSlide extends StatelessWidget {
  final String title, descriptionHeader, description, imageAsset;

  const OnboardingSlide(
      {required this.title,
      required this.descriptionHeader,
      required this.description,
      required this.imageAsset,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: AppDimens.xxl, right: AppDimens.xxl, top: AppDimens.xxxl, bottom: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.xl),
          Text(
            title,
            textAlign: TextAlign.left,
            style: AppTypography.primaryTextJakarta?.copyWith(color: AppColors.limeGreen),
          ),
          const SizedBox(height: AppDimens.c),
          Expanded(
            flex: 2,
            child: SvgPicture.asset(imageAsset, fit: BoxFit.contain),
          ),
          const SizedBox(height: AppDimens.c),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descriptionHeader,
                  style: AppTypography.h2Jakarta?.copyWith(color: AppColors.limeGreen),
                ),
                const SizedBox(height: AppDimens.m),
                Text(
                  description,
                  style: AppTypography.primaryTextJakarta?.copyWith(color: AppColors.limeGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
