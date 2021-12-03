import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.dart';
import 'package:better_informed_mobile/domain/user/use_case/update_user_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SettingsAccountCubit extends Cubit<SettingsAccountState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  late SettingsAccountData _originalData;
  SettingsAccountData _modifiedData = SettingsAccountData(
    firstName: '',
    lastName: '',
    email: '',
  );

  SettingsAccountCubit(this._getUserUseCase, this._updateUserUseCase) : super(const SettingsAccountState.loading());

  Future<void> initialize() async {
    try {
      final user = await _getUserUseCase();
      await _setAccountData(user);
    } catch (e, s) {
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
      emit(SettingsAccountState.showMessage(LocaleKeys.settings_accountInfoSavedSuccessfully.tr()));
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
    return LocaleKeys.settings_wrongFirstNameInput.tr();
  }

  String? _validateLastName(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return LocaleKeys.settings_wrongLastNameInput.tr();
  }

  String? _validateEmail(String? value) {
    //TODO: Do proper email validation
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return LocaleKeys.settings_wrongEmailInput.tr();
  }
}
