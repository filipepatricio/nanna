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
      style: AppTypography.b2RegularLora.copyWith(),
      maxLines: 6,
    );
  }
}
