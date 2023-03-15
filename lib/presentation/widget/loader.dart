import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/theme_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
    this.color,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: kIsTest ? .5 : null,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation(color ?? AppColors.of(context).borderTertiary),
      ),
    );
  }
}

class LoaderLogo extends StatelessWidget {
  const LoaderLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InformedSvg(
        Theme.of(context).isDark ? AppVectorGraphics.launcherLogoInformedDark : AppVectorGraphics.launcherLogoInformed,
        colored: false,
      ),
    );
  }
}
