import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:flutter/material.dart';

class TodaysTopicsTitleHero extends StatelessWidget {
  final String title;

  const TodaysTopicsTitleHero({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = kIsSmallDevice ? 16.0 : null;

    return Hero(
      tag: HeroTag.dailyBriefTitle,
      flightShuttleBuilder: (context, anim, direction, from, to) {
        Color fromColor;
        Color toColor;

        if (direction == HeroFlightDirection.push) {
          fromColor = ((from.widget as Hero).child as Text).style?.color ?? AppColors.black;
          toColor = ((to.widget as Hero).child as Text).style?.color ?? AppColors.black;
        } else {
          fromColor = ((to.widget as Hero).child as Text).style?.color ?? AppColors.black;
          toColor = ((from.widget as Hero).child as Text).style?.color ?? AppColors.black;
        }

        final colorTween = ColorTween(begin: fromColor, end: toColor).animate(anim);

        return Material(
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: colorTween,
            builder: (context, child) {
              return Text(
                title,
                style: AppTypography.h1Bold.copyWith(color: colorTween.value, fontSize: fontSize),
              );
            },
          ),
        );
      },
      child: Text(
        title,
        style: AppTypography.h1Bold.copyWith(color: AppColors.textPrimary, fontSize: fontSize),
      ),
    );
  }
}
