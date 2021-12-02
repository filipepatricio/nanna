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
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsAccountBody extends HookWidget {
  final SettingsAccountCubit cubit;
  final SettingsAccountState state;
  final SettingsAccountData data;

  SettingsAccountBody({
    required this.cubit,
    required this.state,
    required this.data,
    Key? key,
  }) : super(key: key);

  final isFormFocused = useState(false);

  void _onDismissTextFormFocus() {
    hideKeyboard();
    isFormFocused.value = false;
  }

  void _onSaveButtonTap() {
    _onDismissTextFormFocus();
    cubit.saveAccountData();
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = useState(false);

    useCubitListener<SettingsAccountCubit, SettingsAccountState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showMessage: (message) => Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        ),
      );
    });

    return SafeArea(
      child: GestureDetector(
        onTap: _onDismissTextFormFocus,
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
                            children: [
                              Text(
                                LocaleKeys.settings_account.tr(),
                                style: AppTypography.h3Bold16,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => isEditable.value = !isEditable.value,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
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
                                      : SizedBox(
                                          width: AppDimens.settingsCancelButtonWidth,
                                          child: SvgPicture.asset(AppVectorGraphics.edit, fit: BoxFit.contain),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          label: LocaleKeys.settings_firstName.tr(),
                          initialInput: data.firstName,
                          isEditable: isEditable.value,
                          isFormFocused: isFormFocused.value,
                          onChanged: (String inputText) => cubit.updateFirstName(inputText),
                          validator: (String? value) => data.firstNameValidator,
                          onClear: () => cubit.clearNameInput(),
                          onTap: () => isFormFocused.value = true,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          label: LocaleKeys.settings_lastName.tr(),
                          initialInput: data.lastName,
                          isEditable: isEditable.value,
                          isFormFocused: isFormFocused.value,
                          onChanged: (String inputText) => cubit.updateLastName(inputText),
                          validator: (String? value) => data.lastNameValidator,
                          onClear: () => cubit.clearLastNameInput(),
                          onTap: () => isFormFocused.value = true,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          label: LocaleKeys.settings_emailAddress.tr(),
                          initialInput: data.email,
                          isEditable: isEditable.value,
                          isFormFocused: isFormFocused.value,
                          onChanged: (String inputText) => cubit.updateEmail(inputText),
                          validator: (String? value) => data.emailValidator,
                          onClear: () => cubit.clearEmailInput(),
                          onTap: () => isFormFocused.value = true,
                        ),
                        const SizedBox(height: AppDimens.l),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.l),
            AnimatedOpacity(
              opacity: isEditable.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: FilledButton(
                  text: LocaleKeys.settings_save.tr(),
                  onTap: _onSaveButtonTap,
                  isEnabled: cubit.formsAreValid(),
                  disableColor: AppColors.dividerGrey,
                  fillColor: AppColors.limeGreen,
                  textColor: AppColors.textPrimary,
                  isLoading: state.maybeWhen(updating: (data) => true, orElse: () => false),
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
