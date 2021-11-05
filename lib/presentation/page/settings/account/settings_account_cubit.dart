import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.dart';
import 'package:better_informed_mobile/domain/user/use_case/update_user_use_case.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_state.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SettingsAccountCubit extends Cubit<SettingsAccountState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  SettingsAccountData _accountData = SettingsAccountData(
    firstName: '',
    lastName: '',
    email: '',
    lastNameValidator: null,
    firstNameValidator: null,
    emailValidator: null,
  );

  SettingsAccountCubit(this._getUserUseCase, this._updateUserUseCase) : super(const SettingsAccountState.loading());

  Future<void> initialize() async {
    try {
      final user = await _getUserUseCase();
      await setAccountData(user);
    } catch (e, s) {
      Fimber.e('Querying user failed', ex: e, stacktrace: s);
    }
  }

  Future<void> saveAccountData() async {
    if (_accountData.firstNameValidator == null &&
        _accountData.lastNameValidator == null &&
        _accountData.emailValidator == null) {
      emit(SettingsAccountState.updating(_accountData));
      final user = await _updateUserUseCase(_accountData);
      await setAccountData(user);
      await Fluttertoast.showToast(
          msg: 'Your information was saved successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
      hideKeyboard();
    }
  }

  Future<void> setAccountData(User user) async {
    _accountData = _accountData.copyWith(
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
    );
    emit(SettingsAccountState.idle(_accountData));
  }

  void updateFirstName(String inputText) {
    _accountData = _accountData.copyWith(firstName: inputText, firstNameValidator: _validateFirstName(inputText));
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

  String? _validateFirstName(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }
    return 'Wrong first name input!';
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
    _accountData = _accountData.copyWith(firstName: '', firstNameValidator: _validateFirstName(''));
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
