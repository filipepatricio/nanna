import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_account_data.freezed.dart';

@freezed
class SettingsAccountData with _$SettingsAccountData {
  factory SettingsAccountData({
    required String firstName,
    required String lastName,
    required String email,
    required String? firstNameValidator,
    required String? lastNameValidator,
    required String? emailValidator,
  }) = _SettingsAccountData;
}
