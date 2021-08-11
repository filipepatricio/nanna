import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_account_data.freezed.dart';

@freezed
class SettingsAccountData with _$SettingsAccountData {
  factory SettingsAccountData({
    required String name,
    required String lastName,
    required String email,
    required String? nameValidator,
    required String? lastNameValidator,
    required String? emailValidator,
  }) = _SettingsAccountData;
}
