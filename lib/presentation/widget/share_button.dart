import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/share/shareable_app/shareable_app_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    required this.onTap,
    this.iconColor,
    Color? backgroundColor,
    Key? key,
  })  : backgroundColor = backgroundColor ?? AppColors.white,
        super(key: key);

  final Function(ShareApp?) onTap;
  final Color backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => onTap(await showShareableApp(context)),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.s),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: SvgPicture.asset(
          AppVectorGraphics.share,
          color: iconColor,
        ),
      ),
    );
  }
}
