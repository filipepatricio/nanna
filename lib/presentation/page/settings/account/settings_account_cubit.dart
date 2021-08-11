import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SettingsAccountCubit extends Cubit<SettingsAccountState> {
  SettingsAccountData _accountData = SettingsAccountData(
    name: '',
    lastName: '',
    email: '',
    lastNameValidator: null,
    nameValidator: null,
    emailValidator: null,
  );

  SettingsAccountCubit() : super(const SettingsAccountState.loading()) {
    //TODO: REPLACE WITH USER DATA WHEN AVAILABLE
    _accountData = SettingsAccountData(
      name: 'satoshi',
      lastName: 'Kaminski',
      email: 'john.appleseed@gmail.com',
      lastNameValidator: null,
      nameValidator: null,
      emailValidator: null,
    );
    emit(SettingsAccountState.idle(_accountData));
  }

  Future<void> saveAccountData() async {
    if (_accountData.nameValidator == null &&
        _accountData.lastNameValidator == null &&
        _accountData.emailValidator == null) {
      //TODO: UPDATE ACC DATA
    }
  }

  void updateName(String inputText) {
    _accountData = _accountData.copyWith(name: inputText, nameValidator: _validateName(inputText));
    emit(SettingsAccountState.idle(_accountData));
  }

  void updateLastName(String inputText) {
    _accountData = _accountData.copyWith(lastName: inputText, lastNameValidator: _validateLastName(inputText));
    emit(SettingsAccountState.idle(_accountData));
  }

  void updateEmail(String inputText) {
    _accountData = _accountData.copyWith(email: inputText, emailValidator: _validateEmail(inputText));
    emit(SettingsAccountState.idle(_accountData));
  }

  String? _validateName(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return 'Wrong name input!';
  }

  String? _validateLastName(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return 'Wrong last name input!';
  }

  String? _validateEmail(String? value) {
    //TODO: Do proper email validation
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return 'Wrong email input!';
  }

  void clearNameInput() {
    _accountData = _accountData.copyWith(name: '', nameValidator: _validateName(''));
    emit(SettingsAccountState.idle(_accountData));
  }

  void clearLastNameInput() {
    _accountData = _accountData.copyWith(lastName: '', lastNameValidator: _validateLastName(''));
    emit(SettingsAccountState.idle(_accountData));
  }

  void clearEmailInput() {
    _accountData = _accountData.copyWith(email: '', emailValidator: _validateEmail(''));
    emit(SettingsAccountState.idle(_accountData));
  }
}
