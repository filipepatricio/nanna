import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SettingsAccountCubit extends Cubit<SettingsAccountState> {
  final GetUserUseCase _getUserUseCase;

  SettingsAccountData _accountData = SettingsAccountData(
    name: '',
    lastName: '',
    email: '',
    lastNameValidator: null,
    nameValidator: null,
    emailValidator: null,
  );

  SettingsAccountCubit(this._getUserUseCase) : super(const SettingsAccountState.loading());

  Future<void> initialize() async {
    try {
      final user = await _getUserUseCase();
      _accountData = _accountData.copyWith(
        name: user.firstName,
        lastName: user.lastName,
        email: user.email,
      );
      emit(SettingsAccountState.idle(_accountData));
    } catch (e, s) {
      Fimber.e('Querying user failed', ex: e, stacktrace: s);
    }
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
