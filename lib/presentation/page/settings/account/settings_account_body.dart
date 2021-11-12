import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_input_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    useCubitListener<SettingsAccountCubit, SettingsAccountState>(cubit, (cubit, state, context) {
      state.whenOrNull(
          showMessage: (message) => Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0));
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
                            onTap: () => isFormFocused.value = true),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                            label: LocaleKeys.settings_lastName.tr(),
                            initialInput: data.lastName,
                            isEditable: true,
                            isFormFocused: isFormFocused.value,
                            onChanged: (String inputText) => cubit.updateLastName(inputText),
                            validator: (String? value) => data.lastNameValidator,
                            onClear: () => cubit.clearLastNameInput(),
                            onTap: () => isFormFocused.value = true),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                            label: LocaleKeys.settings_emailAddress.tr(),
                            initialInput: data.email,
                            isEditable: false,
                            isFormFocused: isFormFocused.value,
                            onChanged: (String inputText) => cubit.updateEmail(inputText),
                            validator: (String? value) => data.emailValidator,
                            onClear: () => cubit.clearEmailInput(),
                            onTap: () => isFormFocused.value = true),
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
                child: FilledButton(
                    text: LocaleKeys.settings_save.tr(),
                    onTap: _onSaveButtonTap,
                    fillColor: AppColors.limeGreen,
                    textColor: AppColors.textPrimary,
                    isLoading: state.maybeWhen(updating: (data) => true, orElse: () => false))),
            const SizedBox(height: AppDimens.s),
          ],
        ),
      ),
    );
  }
}
