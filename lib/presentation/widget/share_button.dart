import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_view.dart';
import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    required this.onTap,
    this.iconColor,
    this.enabled = true,
    super.key,
  });

  final Function(ShareOption?) onTap;
  final Color? iconColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => onTap(enabled ? await showShareOptions(context) : null),
      child: SizedBox.square(
        dimension: 32.0,
        child: Center(
          child: InformedSvg(
            AppVectorGraphics.share,
            color: iconColor ?? Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
