import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/material.dart';

const _bottomSheetRadius = 10.0;

Future<bool> showSwitchAudioPopup(BuildContext context) async {
  final result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    constraints: BoxConstraints.loose(
      Size.fromHeight(
        MediaQuery.of(context).size.height,
      ),
    ),
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          _bottomSheetRadius,
        ),
      ),
    ),
    builder: (context) {
      return const SwitchAudioPopup();
    },
  );

  return result == true;
}

class SwitchAudioPopup extends StatelessWidget {
  const SwitchAudioPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xl),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr(LocaleKeys.audio_switchAudio_title),
                  style: AppTypography.b2Bold,
                ),
                TextSpan(
                  text: tr(LocaleKeys.audio_switchAudio_info),
                  style: AppTypography.b2Regular,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.l),
          FilledButton.black(
            text: tr(LocaleKeys.audio_switchAudio_deny),
            onTap: () => Navigator.pop(context, false),
          ),
          const SizedBox(height: AppDimens.m),
          FilledButton.white(
            text: LocaleKeys.audio_switchAudio_approve.tr(),
            withOutline: true,
            onTap: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: AppDimens.c),
        ],
      ),
    );
  }
}
