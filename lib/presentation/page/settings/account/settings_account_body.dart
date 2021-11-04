import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_input_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class SettingsAccountBody extends HookWidget {
  final SettingsAccountCubit cubit;
  final SettingsAccountData data;

  const SettingsAccountBody({
    required this.cubit,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder<SettingsAccountCubit, SettingsAccountState>(cubit);
    final isEditable = useState(true);
    final isEmailEditable = useState(false);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimens.l),
                      Container(
                        height: AppDimens.settingsItemHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.settings_account.tr(),
                              style: AppTypography.h3Bold,
                            ),
                            GestureDetector(
                              onTap: () => isEditable.value = !isEditable.value,
                              child: isEditable.value
                                  ? Container(
                                width: AppDimens.settingsCancelButtonWidth,
                                height: AppDimens.settingsCancelButtonHeight,
                                decoration: const BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(AppDimens.m)),
                                ),
                                child: Center(
                                  child: Text(
                                    LocaleKeys.common_cancel.tr(),
                                    textAlign: TextAlign.center,
                                    style: AppTypography.metadata1Medium.copyWith(height: AppDimens.one),
                                  ),
                                ),
                              )
                                  : SvgPicture.asset(AppVectorGraphics.edit, fit: BoxFit.contain),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.l),
                      SettingsInputItem(
                        label: LocaleKeys.settings_firstName.tr(),
                        initialInput: data.firstName,
                        isEditable: isEditable.value,
                        onChanged: (String inputText) => cubit.updateFirstName(inputText),
                        validator: (String? value) => data.firstNameValidator,
                        onClear: () => cubit.clearNameInput(),
                      ),
                      const SizedBox(height: AppDimens.l),
                      SettingsInputItem(
                        label: LocaleKeys.settings_lastName.tr(),
                        initialInput: data.lastName,
                        isEditable: isEditable.value,
                        onChanged: (String inputText) => cubit.updateLastName(inputText),
                        validator: (String? value) => data.lastNameValidator,
                        onClear: () => cubit.clearLastNameInput(),
                      ),
                      const SizedBox(height: AppDimens.l),
                      SettingsInputItem(
                        label: LocaleKeys.settings_emailAddress.tr(),
                        initialInput: data.email,
                        isEditable: isEmailEditable.value,
                        onChanged: (String inputText) => cubit.updateEmail(inputText),
                        validator: (String? value) => data.emailValidator,
                        onClear: () => cubit.clearEmailInput(),
                      ),
                      const SizedBox(height: AppDimens.l),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: GestureDetector(
              onTap: () => cubit.saveAccountData(),
              child: Container(
                height: AppDimens.xxl,
                decoration: const BoxDecoration(
                  color: AppColors.limeGreen,
                  borderRadius: BorderRadius.all(Radius.circular(AppDimens.s)),
                ),
                child: Center(
                  child: state.maybeWhen(
                    updating: (data) => const CircularProgressIndicator(color: AppColors.textPrimary),
                    idle: (data) => Text(
                      LocaleKeys.settings_save.tr(),
                      style: AppTypography.buttonBold,
                    ),
                    orElse: () => const SizedBox(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.s),
        ],
      ),
    );
  }
}
