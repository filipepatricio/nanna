import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenWebButton extends StatelessWidget {
  final String url;
  final String buttonLabel;

  const OpenWebButton({
    required this.url,
    required this.buttonLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            Fimber.e('Could not launch $url');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimens.sl,
              horizontal: AppDimens.l,
            ),
            decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimens.buttonRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppVectorGraphics.openWeb,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppDimens.sl),
                Text(
                  buttonLabel,
                  style: AppTypography.buttonBold.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
