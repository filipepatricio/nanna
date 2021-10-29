import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';
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
        child: Flexible(
          fit: FlexFit.tight,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimens.s,
              horizontal: AppDimens.l,
            ),
            decoration: const BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimens.buttonRadius),
              ),
            ),
            child: Center(child: Text(buttonLabel, style: AppTypography.buttonBold)),
          ),
        ),
      ),
    );
  }
}
