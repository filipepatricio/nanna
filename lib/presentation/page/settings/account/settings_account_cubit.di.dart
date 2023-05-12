import 'package:better_informed_mobile/domain/auth/use_case/sign_out_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/reset_user_categories_store_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/general/is_email_valid_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/reset_user_subscription_store_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/use_case/delete_account_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/update_user_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsAccountCubit extends Cubit<SettingsAccountState> {
  SettingsAccountCubit(
    this._getUserUseCase,
    this._updateUserUseCase,
    this._isEmailValidUseCase,
    this._signOutUseCase,
    this._deleteAccountUseCase,
    this._resetUserCategoriesStoreUseCase,
    this._resetUserSubscriptionStoreUseCase,
    this._isGuestModeUseCase,
  ) : super(const SettingsAccountState.loading());

  final IsGuestModeUseCase _isGuestModeUseCase;
  final IsEmailValidUseCase _isEmailValidUseCase;
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final SignOutUseCase _signOutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final ResetUserCategoriesStoreUseCase _resetUserCategoriesStoreUseCase;
  final ResetUserSubscriptionStoreUseCase _resetUserSubscriptionStoreUseCase;

  late SettingsAccountData _originalData;
  SettingsAccountData _modifiedData = SettingsAccountData.empty();

  late AppLocalizations _l10n;

  Future<void> initialize(AppLocalizations l10n) async {
    try {
      if (await _isGuestModeUseCase()) {
        emit(const SettingsAccountState.guest());

        return;
      }

      _l10n = l10n;
      final user = await _getUserUseCase();
      await _setAccountData(user);
    } on NoInternetConnectionException {
      emit(const SettingsAccountState.offline());
    } catch (e, s) {
      emit(const SettingsAccountState.error());
      Fimber.e('Querying user failed', ex: e, stacktrace: s);
    }
  }

  bool formsAreValid() {
    return _modifiedData.firstNameValidator == null &&
        _modifiedData.lastNameValidator == null &&
        _modifiedData.emailValidator == null &&
        _originalData != _modifiedData;
  }

  Future<void> saveAccountData() async {
    if (formsAreValid()) {
      emit(SettingsAccountState.updating(_originalData, _modifiedData));
      final user = await _updateUserUseCase(_modifiedData);
      await _setAccountData(user);
      emit(SettingsAccountState.showMessage(_l10n.settings_accountInfoSavedSuccessfully));
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (await _deleteAccountUseCase()) {
        await _resetUserCategoriesStoreUseCase();
        await _resetUserSubscriptionStoreUseCase();
        return await _signOutUseCase();
      }

      emit(SettingsAccountState.showMessage(_l10n.common_error_body));
    } catch (e, s) {
      Fimber.e('Deleting account failed', ex: e, stacktrace: s);
    } finally {
      emit(SettingsAccountState.idle(_originalData, _modifiedData));
    }
  }

  void updateFirstName(String inputText) {
    _modifiedData = _modifiedData.copyWith(firstName: inputText, firstNameValidator: _validateFirstName(inputText));
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  void updateLastName(String inputText) {
    _modifiedData = _modifiedData.copyWith(lastName: inputText, lastNameValidator: _validateLastName(inputText));
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  void updateEmail(String inputText) {
    _modifiedData = _modifiedData.copyWith(email: inputText, emailValidator: _validateEmail(inputText));
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  Future<void> _setAccountData(User user) async {
    _originalData = SettingsAccountData.fromUser(user);
    _modifiedData = _modifiedData.copyWithUser(user);
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  void clearNameInput() {
    _modifiedData = _modifiedData.copyWith(firstName: '', firstNameValidator: _validateFirstName(''));
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  void clearLastNameInput() {
    _modifiedData = _modifiedData.copyWith(lastName: '', lastNameValidator: _validateLastName(''));
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  void clearEmailInput() {
    _modifiedData = _modifiedData.copyWith(email: '', emailValidator: _validateEmail(''));
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  void cancelEdit() {
    _modifiedData = _originalData.copyWith();
    emit(SettingsAccountState.idle(_originalData, _modifiedData));
  }

  String? _validateFirstName(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return _l10n.settings_wrongFirstNameInput;
  }

  String? _validateLastName(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return _l10n.settings_wrongLastNameInput;
  }

  String? _validateEmail(String email) {
    if (_isEmailValidUseCase(email)) {
      return null;
    }
    return _l10n.settings_wrongEmailInput;
  }
}
