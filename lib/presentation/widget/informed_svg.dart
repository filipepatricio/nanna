import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformedSvg extends StatelessWidget {
  const InformedSvg(
    this.svg, {
    this.color,
    this.fit,
    this.height,
    this.width,
    this.colored = true,
    super.key,
  });

  final String svg;
  final Color? color;
  final BoxFit? fit;
  final double? height;
  final double? width;

  /// If false, uses the color already defined in the svg asset
  final bool colored;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      color: colored ? (color ?? Theme.of(context).iconTheme.color) : null,
    );
  }
}
