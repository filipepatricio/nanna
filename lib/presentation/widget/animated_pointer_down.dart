import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedPointerDown extends HookWidget {
  final Color arrowColor;
  final Function()? onTap;

  const AnimatedPointerDown({required this.arrowColor, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: const Duration(seconds: 1));
    final animation = Tween(begin: Offset.zero, end: const Offset(0.0, 0.25))
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(animationController);

    useEffect(() {
      animationController.repeat(reverse: true);
    }, []);

    return ExpandTapWidget(
      tapPadding: const EdgeInsets.all(AppDimens.m),
      onTap: onTap ?? () {},
      child: SlideTransition(
        position: animation,
        child: SvgPicture.asset(
          AppVectorGraphics.arrowDown,
          color: arrowColor,
        ),
      ),
    );
  }
}
