import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_account_data.dt.freezed.dart';

@freezed
class SettingsAccountData with _$SettingsAccountData {
  factory SettingsAccountData({
    required String firstName,
    required String lastName,
    required String email,
    String? firstNameValidator,
    String? lastNameValidator,
    String? emailValidator,
  }) = _SettingsAccountData;

  const SettingsAccountData._();

  factory SettingsAccountData.empty() => SettingsAccountData(
        firstName: '',
        lastName: '',
        email: '',
      );

  factory SettingsAccountData.fromUser(User user) => SettingsAccountData(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      );

  SettingsAccountData copyWithUser(User user) => copyWith(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      );
}
