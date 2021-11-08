import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopicIntroduction extends StatelessWidget {
  final String introduction;

  const TopicIntroduction({required this.introduction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      introduction,
      textScaleFactor: 1,
      style: AppTypography.h5MediumSmall.copyWith(
        height: 1.12,
        fontFamily: fontFamilyLora,
      ),
    );
  }
}
