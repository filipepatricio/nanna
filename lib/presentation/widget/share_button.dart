import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    required this.onTap,
    Color? backgroundColor,
    Key? key,
  })  : backgroundColor = backgroundColor ?? AppColors.white,
        super(key: key);

  final Function(ShareOptions?) onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => onTap(await showShareOptions(context)),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.xs),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: SvgPicture.asset(AppVectorGraphics.share),
      ),
    );
  }
}
