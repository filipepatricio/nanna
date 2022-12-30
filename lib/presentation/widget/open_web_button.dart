import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenWebButton extends StatelessWidget {
  const OpenWebButton({
    required this.url,
    required this.buttonLabel,
    this.withIcon = true,
    this.padding = EdgeInsets.zero,
    this.launchExternalApp = false,
    Key? key,
  }) : super(key: key);
  final String url;
  final bool withIcon;
  final String buttonLabel;
  final EdgeInsets padding;
  final bool launchExternalApp;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: launchExternalApp ? LaunchMode.externalApplication : LaunchMode.platformDefault,
            );
          } else {
            Fimber.e('Could not launch $url');
          }
        },
        child: Padding(
          padding: padding,
          child: Container(
            height: AppDimens.buttonHeight,
            decoration: BoxDecoration(
              color: AppColors.of(context).buttonPrimaryBackground,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.defaultRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (withIcon) ...[
                  const InformedSvg(
                    AppVectorGraphics.openWeb,
                    fit: BoxFit.contain,
                    height: AppDimens.m,
                  ),
                  const SizedBox(width: AppDimens.sl),
                ],
                Text(
                  buttonLabel,
                  style: AppTypography.buttonBold.copyWith(
                    color: AppColors.of(context).buttonPrimaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
