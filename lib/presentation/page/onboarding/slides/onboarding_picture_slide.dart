import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPictureSlide extends StatelessWidget {
  final String title, descriptionHeader, description, imageAsset;

  const OnboardingPictureSlide({
    required this.title,
    required this.descriptionHeader,
    required this.description,
    required this.imageAsset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimens.xxl),
        Expanded(
          flex: 3,
          child: SvgPicture.asset(imageAsset, fit: BoxFit.contain),
        ),
        const SizedBox(height: AppDimens.c),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.xl,
              right: AppDimens.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descriptionHeader,
                  style: AppTypography.h0Bold.copyWith(height: 1.14, fontSize: 34),
                ),
                const SizedBox(height: AppDimens.m),
                Text(
                  description,
                  style: AppTypography.b1Regular,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
