import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';

abstract class UserRepository {
  Future<User> getUser();

  Future<User> updateUser(SettingsAccountData settingsAccountData);

  Future<bool> deleteAccount();

  Future<bool> updatePreferredCategories(List<Category> categories);

  Future<List<CategoryPreference>> getCategoryPreferences();

  Future<bool> followCategory(Category category);

  Future<bool> unfollowCategory(Category category);

  Future<CategoryPreference> getCategoryPreference(Category category);
}
