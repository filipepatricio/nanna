import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class SettingsPolicyTermsPage extends HookWidget {
  final bool isPolicy;

  const SettingsPolicyTermsPage({required this.isPolicy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          LocaleKeys.settings_settingsOverview.tr(),
          style: AppTypography.subH1Medium,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO: change for proper texts, or fetch from api
                    Text(
                      isPolicy ? LocaleKeys.settings_privacyPolicy.tr() : LocaleKeys.settings_termsOfService.tr(),
                      style: AppTypography.h3Bold,
                    ),
                    const SizedBox(height: AppDimens.l),
                    Text(
                      isPolicy ? LocaleKeys.settings_privacyPolicyContent.tr() : LocaleKeys.settings_termsContent.tr(),
                      style: AppTypography.b1Medium,
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.m),
            SvgPicture.asset(
              AppVectorGraphics.informedLogoDark,
              width: AppDimens.l,
              height: AppDimens.l,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
