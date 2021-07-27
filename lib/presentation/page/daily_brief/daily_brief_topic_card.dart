import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DailyBriefTopicCard extends HookWidget {
  final int index;
  final Function() onPressed;

  const DailyBriefTopicCard({
    required this.index,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.s,
        top: AppDimens.xxxl,
        bottom: AppDimens.xxxl,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 16,
                color: const Color(0xFF000000).withOpacity(0.12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'image-$index',
                flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
                  final colors = [const Color(0x00282B35), const Color(0xFF282B35)];
                  final colorTween = ColorTween(begin: colors[0], end: colors[1]).animate(anim);

                  return AnimatedBuilder(
                    animation: colorTween,
                    builder: (context, child) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/image/topic_placeholder.png',
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.topLeft,
                          ),
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  colorTween.value!,
                                  const Color(0x00282B35),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Image.asset(
                  'assets/image/topic_placeholder.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppDimens.m),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                child: Hero(
                  tag: 'title-$index',
                  flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
                    final colors = [Colors.black, Colors.white];
                    final colorTween = ColorTween(begin: colors[0], end: colors[1]).animate(anim);

                    return Material(
                      color: Colors.transparent,
                      child: AnimatedBuilder(
                        animation: colorTween,
                        builder: (context, child) {
                          return Text(
                            'Title $index',
                            style: AppTypography.h1.copyWith(color: colorTween.value),
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Title $index',
                    style: AppTypography.h1,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.m),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                child: Hero(
                  tag: 'content-$index',
                  flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
                    final colors = [Colors.black, Colors.white];
                    final colorTween = ColorTween(begin: colors[0], end: colors[1]).animate(anim);

                    return Material(
                      color: Colors.transparent,
                      child: AnimatedBuilder(
                        animation: colorTween,
                        builder: (context, child) {
                          return Text(
                            'Content $index. The Chinese Communist Party has long done everything it can to erase memories of the massacre of pro-democracy protesters in Beijing\'s Tiananmen Square 32-years-ago today.',
                            style: AppTypography.primaryTextJakarta.copyWith(color: colorTween.value),
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Content $index. The Chinese Communist Party has long done everything it can to erase memories of the massacre of pro-democracy protesters in Beijing\'s Tiananmen Square 32-years-ago today.',
                    style: AppTypography.primaryTextJakarta,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
