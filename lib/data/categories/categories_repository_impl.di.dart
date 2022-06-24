import 'dart:async';

import 'package:better_informed_mobile/data/categories/api/categories_data_source.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_mapper.di.dart';
import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl(
    this._categoriesDataSource,
    this._categoryMapper,
  );

  final CategoriesDataSource _categoriesDataSource;
  final CategoryMapper _categoryMapper;
  final StreamController<List<Category>> _categoryStreamController = StreamController<List<Category>>();

  @override
  Future<List<Category>> getOnboardingCategories() async {
    final dto = await _categoriesDataSource.getOnboardingCategories();
    return dto.categories.map<Category>(_categoryMapper.to).toList();
  }

  @override
  Stream<List<Category>> get categoriesStream => _categoryStreamController.stream.asBroadcastStream();

  @override
  void setSelectedCategories(List<Category> categories) => _categoryStreamController.add(categories);
}