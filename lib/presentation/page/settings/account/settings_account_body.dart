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
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class SettingsAccountBody extends HookWidget {
  final SettingsAccountCubit cubit;
  final SettingsAccountData data;

  SettingsAccountBody({
    required this.cubit,
    required this.data,
    Key? key,
  }) : super(key: key);

  final isFormFocused = useState(false);
  final isEditable = useState(false);

  void onDismissTextFormFocus(){
    hideKeyboard();
    isFormFocused.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder<SettingsAccountCubit, SettingsAccountState>(cubit);
    final isEmailEditable = useState(false);

    return SafeArea(
      child:GestureDetector(
        onTap: () => onDismissTextFormFocus(),
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
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                            label: LocaleKeys.settings_firstName.tr(),
                            initialInput: data.firstName,
                            isEditable: true,
                            isFormFocused: isFormFocused.value,
                            onChanged: (String inputText) => cubit.updateFirstName(inputText),
                            validator: (String? value) => data.firstNameValidator,
                            onClear: () => cubit.clearNameInput(),
                            onTap: () => isFormFocused.value = true
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                            label: LocaleKeys.settings_lastName.tr(),
                            initialInput: data.lastName,
                            isEditable: true,
                            isFormFocused: isFormFocused.value,
                            onChanged: (String inputText) => cubit.updateLastName(inputText),
                            validator: (String? value) => data.lastNameValidator,
                            onClear: () => cubit.clearLastNameInput(),
                            onTap: () => isFormFocused.value = true
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                            label: LocaleKeys.settings_emailAddress.tr(),
                            initialInput: data.email,
                            isEditable: isEmailEditable.value,
                            isFormFocused: isFormFocused.value,
                            onChanged: (String inputText) => cubit.updateEmail(inputText),
                            validator: (String? value) => data.emailValidator,
                            onClear: () => cubit.clearEmailInput(),
                            onTap: () => isFormFocused.value = true
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
                      updating: (data) => const SizedBox(
                          height: AppDimens.m,
                          width: AppDimens.m,
                          child: CircularProgressIndicator(color: AppColors.textPrimary, strokeWidth: AppDimens.xxs)
                      ),
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
      ),
    );
  }
}
