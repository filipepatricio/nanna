import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        const Spacer(),
        Expanded(
          flex: 11,
          child: SvgPicture.asset(imageAsset, fit: BoxFit.fitWidth),
        ),
        const SizedBox(height: AppDimens.xl),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: AutoSizeText(
                    descriptionHeader,
                    style: AppTypography.h0Bold.copyWith(height: 1.14, fontSize: 34),
                    maxLines: 3,
                    stepGranularity: 0.1,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 10,
                  child: AutoSizeText(
                    description,
                    style: AppTypography.b2Regular,
                    maxLines: 4,
                    stepGranularity: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
