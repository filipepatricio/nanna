import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const dailyBriefHeroTag = 'dailyBriefHeroTag';

class DailyBriefTitleHero extends StatelessWidget {
  const DailyBriefTitleHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: dailyBriefHeroTag,
      flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
        final colors = [Colors.black, Colors.white];
        final colorTween = ColorTween(begin: colors[0], end: colors[1]).animate(anim);

        return Material(
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: colorTween,
            builder: (context, child) {
              return Text(
                LocaleKeys.dailyBrief_title.tr(),
                style: AppTypography.title.copyWith(color: colorTween.value),
              );
            },
          ),
        );
      },
      child: Text(
        LocaleKeys.dailyBrief_title.tr(),
        style: AppTypography.title.copyWith(color: Colors.black),
      ),
    );
  }
}
