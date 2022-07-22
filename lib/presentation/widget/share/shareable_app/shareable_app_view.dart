import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/shareable_app/shareable_app_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _bottomSheetRadius = 10.0;

Future<ShareApp?> showShareableApp(BuildContext context) {
  final result = showModalBottomSheet<ShareApp?>(
    context: context,
    constraints: BoxConstraints.loose(
      Size.fromHeight(
        MediaQuery.of(context).size.height,
      ),
    ),
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          _bottomSheetRadius,
        ),
      ),
    ),
    isScrollControlled: true,
    builder: (context) {
      return const ShareableAppView();
    },
  );
  return result;
}

class ShareableAppView extends HookWidget {
  const ShareableAppView({Key? key}) : super(key: key);

  String _getText(ShareApp shareApp) {
    switch (shareApp) {
      case ShareApp.instagram:
        return LocaleKeys.social_instagram.tr();
      case ShareApp.twitter:
        return LocaleKeys.social_twitter.tr();
      case ShareApp.facebook:
        return LocaleKeys.social_facebook.tr();
      case ShareApp.whatsapp:
        return LocaleKeys.social_whatsapp.tr();
      case ShareApp.telegram:
        return LocaleKeys.social_telegram.tr();
      case ShareApp.message:
        return LocaleKeys.common_message.tr();
      case ShareApp.copyLink:
        return LocaleKeys.common_copyLink.tr();
      case ShareApp.more:
        return LocaleKeys.common_more.tr();
    }
  }

  String _getIcon(ShareApp shareApp) {
    switch (shareApp) {
      case ShareApp.instagram:
        return AppVectorGraphics.shareInstagram;
      case ShareApp.twitter:
        return AppVectorGraphics.shareTwitter;
      case ShareApp.facebook:
        return AppVectorGraphics.shareFacebook;
      case ShareApp.whatsapp:
        return AppVectorGraphics.shareWhatsapp;
      case ShareApp.telegram:
        return AppVectorGraphics.shareTelegram;
      case ShareApp.message:
        return AppVectorGraphics.shareMessage;
      case ShareApp.copyLink:
        return AppVectorGraphics.shareCopy;
      case ShareApp.more:
        return AppVectorGraphics.shareMore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareableAppCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: state.maybeMap(
          orElse: () => [
            const Padding(
              padding: EdgeInsets.all(AppDimens.l),
              child: Loader(
                strokeWidth: 3.0,
                color: AppColors.limeGreen,
              ),
            ),
          ],
          idle: (data) => [
            Text(
              LocaleKeys.common_shareVia.tr(),
              style: AppTypography.h4ExtraBold,
            ),
            const SizedBox(height: AppDimens.s),
            ...data.shareApps
                .where((element) => element != ShareApp.copyLink && element != ShareApp.more)
                .map(
                  (e) => _Button(
                    svg: _getIcon(e),
                    text: _getText(e),
                    showIcon: e == ShareApp.copyLink || e == ShareApp.more,
                    onTap: () => AutoRouter.of(context).pop(e),
                  ),
                )
                .toList(),
            const Divider(),
            ...data.shareApps
                .where((element) => element == ShareApp.copyLink || element == ShareApp.more)
                .map(
                  (e) => _Button(
                    svg: _getIcon(e),
                    text: _getText(e),
                    showIcon: e == ShareApp.copyLink || e == ShareApp.more,
                    onTap: () => AutoRouter.of(context).pop(e),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.svg,
    required this.text,
    required this.onTap,
    this.showIcon = false,
    Key? key,
  }) : super(key: key);

  final String svg;
  final String text;
  final bool showIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
        child: SizedBox(
          height: 32,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showIcon) ...[
                SvgPicture.asset(
                  svg,
                  width: AppDimens.xl,
                  height: AppDimens.xl,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(width: AppDimens.s),
              ],
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.h4Medium.copyWith(height: 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
