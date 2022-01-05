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
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsAccountBody extends HookWidget {
  final SettingsAccountCubit cubit;
  final SettingsAccountState state;
  final SettingsAccountData originalData;
  final SettingsAccountData modifiedData;

  const SettingsAccountBody({
    required this.cubit,
    required this.state,
    required this.originalData,
    required this.modifiedData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEditable = useState(false);
    final isFormFocused = useState(false);

    useCubitListener<SettingsAccountCubit, SettingsAccountState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showMessage: (message) {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
        },
      );
    });

    final nameController = useTextEditingController(text: originalData.firstName);
    final lastNameController = useTextEditingController(text: originalData.lastName);
    final emailController = useTextEditingController(text: originalData.email);

    return SafeArea(
      child: GestureDetector(
        onTap: () => _onDismissTextFormFocus(isFormFocused),
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
                              _EditButton(
                                isEditable: isEditable.value,
                                onEditModeChange: (editable) {
                                  isEditable.value = editable;
                                  if (!editable) {
                                    nameController.text = originalData.firstName;
                                    lastNameController.text = originalData.lastName;
                                    emailController.text = originalData.email;

                                    cubit.cancelEdit();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          controller: nameController,
                          label: LocaleKeys.settings_firstName.tr(),
                          initialInput: originalData.firstName,
                          isEditable: isEditable.value,
                          isFormFocused: isFormFocused.value,
                          onChanged: (String inputText) => cubit.updateFirstName(inputText),
                          validator: (String? value) => modifiedData.firstNameValidator,
                          onClear: () => cubit.clearNameInput(),
                          onTap: () => isFormFocused.value = true,
                          textCapitalization: TextCapitalization.words,
                          onSubmitted: () => cubit.saveAccountData(),
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          controller: lastNameController,
                          label: LocaleKeys.settings_lastName.tr(),
                          initialInput: originalData.lastName,
                          isEditable: isEditable.value,
                          isFormFocused: isFormFocused.value,
                          onChanged: (String inputText) => cubit.updateLastName(inputText),
                          validator: (String? value) => modifiedData.lastNameValidator,
                          onClear: () => cubit.clearLastNameInput(),
                          onTap: () => isFormFocused.value = true,
                          textCapitalization: TextCapitalization.words,
                          onSubmitted: () => cubit.saveAccountData(),
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          controller: emailController,
                          label: LocaleKeys.settings_emailAddress.tr(),
                          initialInput: originalData.email,
                          isEditable: isEditable.value,
                          isFormFocused: isFormFocused.value,
                          onChanged: (String inputText) => cubit.updateEmail(inputText),
                          validator: (String? value) => modifiedData.emailValidator,
                          onClear: () => cubit.clearEmailInput(),
                          onTap: () => isFormFocused.value = true,
                          onSubmitted: () => cubit.saveAccountData(),
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
              duration: const Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: FilledButton(
                  text: LocaleKeys.settings_save.tr(),
                  onTap: () => _onSaveButtonTap(isEditable, isFormFocused),
                  isEnabled: cubit.formsAreValid(),
                  disableColor: AppColors.dividerGrey,
                  fillColor: AppColors.limeGreen,
                  textColor: AppColors.textPrimary,
                  isLoading: state.maybeMap(updating: (_) => true, orElse: () => false),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.s),
          ],
        ),
      ),
    );
  }

  void _onDismissTextFormFocus(ValueNotifier<bool> isFormFocused) {
    hideKeyboard();
    isFormFocused.value = false;
  }

  void _onSaveButtonTap(ValueNotifier<bool> isEditable, ValueNotifier<bool> isFormFocused) {
    _onDismissTextFormFocus(isFormFocused);
    cubit.saveAccountData();
    isEditable.value = false;
  }
}

class _EditButton extends StatelessWidget {
  final bool isEditable;
  final Function(bool isEditable) onEditModeChange;

  const _EditButton({
    required this.isEditable,
    required this.onEditModeChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onEditModeChange(!isEditable),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: isEditable
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
    );
  }
}
