import 'package:better_informed_mobile/domain/categories/categories_local_repository.dart';
import 'package:hive/hive.dart';

const _categoriesBoxName = 'categoriesBox';
const _addInterestsPageKey = 'addInterestsPageKey';

class CategoriesHiveLocalRepository extends CategoriesLocalRepository {
  @override
  Future<bool> isAddInterestsPageSeen(String userUuid) async {
    final box = await _openCategoriesBox(userUuid);
    final isSeen = box.get(_addInterestsPageKey);
    return isSeen ?? false;
  }

  @override
  Future<void> clear(String userUuid) async {
    final box = await _openCategoriesBox(userUuid);
    await box.clear();
  }

  @override
  Future<void> setAddInterestsPageSeen(String userUuid) async {
    final box = await _openCategoriesBox(userUuid);
    await box.put(_addInterestsPageKey, true);
  }

  Future<Box<bool>> _openCategoriesBox(String userUuid) async {
    return Hive.openBox<bool>('${userUuid}_$_categoriesBoxName');
  }
}
