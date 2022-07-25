import 'package:better_informed_mobile/domain/categories/data/category.dt.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';

abstract class UserRepository {
  Future<User> getUser();

  Future<User> updateUser(SettingsAccountData settingsAccountData);

  Future<bool> updatePreferredCategories(List<Category> categories);

  Future<bool> deleteAccount();
}
