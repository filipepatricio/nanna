import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_input_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsAccountBody extends HookWidget {
  const SettingsAccountBody({
    required this.cubit,
    required this.state,
    required this.originalData,
    required this.modifiedData,
    Key? key,
  }) : super(key: key);

  final SettingsAccountCubit cubit;
  final SettingsAccountState state;
  final SettingsAccountData originalData;
  final SettingsAccountData modifiedData;

  @override
  Widget build(BuildContext context) {
    final isFirstNameFocused = useState(false);
    final isLastNameFocused = useState(false);
    final snackbarController = useSnackbarController();

    useCubitListener<SettingsAccountCubit, SettingsAccountState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showMessage: (message) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: message,
              type: SnackbarMessageType.success,
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
        onTap: () => _onDismissTextFormFocus(isFirstNameFocused, isLastNameFocused),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pageHorizontalMargin,
            vertical: AppDimens.l,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsInputItem(
                controller: nameController,
                label: LocaleKeys.settings_firstName.tr(),
                isEditable: true,
                isFormFocused: isFirstNameFocused.value,
                validator: (_) => modifiedData.firstNameValidator,
                textCapitalization: TextCapitalization.words,
                onChanged: cubit.updateFirstName,
                onClear: cubit.clearNameInput,
                onSubmitted: cubit.saveAccountData,
                onTap: () {
                  isFirstNameFocused.value = true;
                  isLastNameFocused.value = false;
                },
              ),
              const SizedBox(height: AppDimens.m),
              SettingsInputItem(
                controller: lastNameController,
                label: LocaleKeys.settings_lastName.tr(),
                isEditable: true,
                isFormFocused: isLastNameFocused.value,
                validator: (_) => modifiedData.lastNameValidator,
                textCapitalization: TextCapitalization.words,
                onChanged: cubit.updateLastName,
                onClear: cubit.clearLastNameInput,
                onSubmitted: cubit.saveAccountData,
                onTap: () {
                  isFirstNameFocused.value = false;
                  isLastNameFocused.value = true;
                },
              ),
              const SizedBox(height: AppDimens.m),
              SettingsInputItem(
                controller: emailController,
                label: LocaleKeys.settings_emailAddress.tr(),
                isEditable: false,
                validator: (_) => modifiedData.emailValidator,
                onChanged: cubit.updateEmail,
                onClear: cubit.clearEmailInput,
                onSubmitted: cubit.saveAccountData,
              ),
              const SizedBox(height: AppDimens.m),
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 250),
                child: InformedFilledButton.primary(
                  context: context,
                  text: LocaleKeys.settings_save.tr(),
                  onTap: () => _onSaveButtonTap(isFirstNameFocused, isLastNameFocused),
                  isEnabled: cubit.formsAreValid(),
                  isLoading: state.maybeMap(updating: (_) => true, orElse: () => false),
                ),
              ),
              const SizedBox(height: AppDimens.l),
              LinkLabel(
                label: LocaleKeys.settings_deleteAccount_button.tr(),
                decoration: TextDecoration.none,
                onTap: () => _onDeleteAccountLinkTap(context),
              ),
              const Spacer(),
              const AudioPlayerBannerPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountLinkTap(BuildContext context) async {
    final deleteAccountConfirmed = await InformedDialog.showDeleteAccount(context);
    if (deleteAccountConfirmed == true) {
      await cubit.deleteAccount();
    }
  }

  void _onDismissTextFormFocus(
    ValueNotifier<bool> isFirstNameFocused,
    ValueNotifier<bool> isLastNameFocused,
  ) {
    hideKeyboard();
    isFirstNameFocused.value = false;
    isLastNameFocused.value = false;
  }

  void _onSaveButtonTap(
    ValueNotifier<bool> isFirstNameFocused,
    ValueNotifier<bool> isLastNameFocused,
  ) {
    _onDismissTextFormFocus(isFirstNameFocused, isLastNameFocused);
    cubit.saveAccountData();
  }
}
