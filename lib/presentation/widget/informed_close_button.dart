import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformedCloseButton extends StatelessWidget {
  const InformedCloseButton({
    this.color,
    this.onPressed,
    super.key,
  });

  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed ?? () => Navigator.pop(context),
        child: SvgPicture.asset(
          AppVectorGraphics.close,
          color: color ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
