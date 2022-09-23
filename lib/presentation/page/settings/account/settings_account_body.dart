import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_input_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsAccountBody extends HookWidget {
  const SettingsAccountBody({
    required this.cubit,
    required this.state,
    required this.originalData,
    required this.modifiedData,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final SettingsAccountCubit cubit;
  final SettingsAccountState state;
  final SettingsAccountData originalData;
  final SettingsAccountData modifiedData;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    final isFormFocused = useState(false);

    useCubitListener<SettingsAccountCubit, SettingsAccountState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showMessage: (message) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: message,
              type: SnackbarMessageType.negative,
            ),
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
                physics: getPlatformScrollPhysics(),
                padding: const EdgeInsets.all(AppDimens.l),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimens.l),
                        Text(
                          LocaleKeys.settings_account.tr(),
                          style: AppTypography.h4Bold,
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          controller: nameController,
                          label: LocaleKeys.settings_firstName.tr(),
                          initialInput: originalData.firstName,
                          isEditable: true,
                          isFormFocused: isFormFocused.value,
                          validator: (_) => modifiedData.firstNameValidator,
                          textCapitalization: TextCapitalization.words,
                          onChanged: cubit.updateFirstName,
                          onClear: cubit.clearNameInput,
                          onSubmitted: cubit.saveAccountData,
                          onTap: () => isFormFocused.value = true,
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          controller: lastNameController,
                          label: LocaleKeys.settings_lastName.tr(),
                          initialInput: originalData.lastName,
                          isEditable: true,
                          isFormFocused: isFormFocused.value,
                          validator: (_) => modifiedData.lastNameValidator,
                          textCapitalization: TextCapitalization.words,
                          onChanged: cubit.updateLastName,
                          onClear: cubit.clearLastNameInput,
                          onSubmitted: cubit.saveAccountData,
                          onTap: () => isFormFocused.value = true,
                        ),
                        const SizedBox(height: AppDimens.l),
                        SettingsInputItem(
                          controller: emailController,
                          label: LocaleKeys.settings_emailAddress.tr(),
                          initialInput: originalData.email,
                          isEditable: false,
                          isFormFocused: isFormFocused.value,
                          validator: (_) => modifiedData.emailValidator,
                          onChanged: cubit.updateEmail,
                          onClear: cubit.clearEmailInput,
                          onSubmitted: cubit.saveAccountData,
                          onTap: () => isFormFocused.value = true,
                        ),
                        const SizedBox(height: AppDimens.l),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: AppDimens.m),
                      child: LinkLabel(
                        label: LocaleKeys.settings_deleteAccount_button.tr(),
                        onTap: () => _onDeleteAccountLinkTap(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.m),
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: FilledButton(
                  text: LocaleKeys.settings_save.tr(),
                  onTap: () => _onSaveButtonTap(isFormFocused),
                  isEnabled: cubit.formsAreValid(),
                  disableColor: AppColors.dividerGrey,
                  fillColor: AppColors.limeGreen,
                  textColor: AppColors.textPrimary,
                  isLoading: state.maybeMap(updating: (_) => true, orElse: () => false),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.m),
            const AudioPlayerBannerPlaceholder(),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountLinkTap(BuildContext context) async {
    if (await InformedDialog.showDeleteAccount(context) == true) {
      await cubit.deleteAccount();
    }
  }

  void _onDismissTextFormFocus(ValueNotifier<bool> isFormFocused) {
    hideKeyboard();
    isFormFocused.value = false;
  }

  void _onSaveButtonTap(ValueNotifier<bool> isFormFocused) {
    _onDismissTextFormFocus(isFormFocused);
    cubit.saveAccountData();
  }
}
