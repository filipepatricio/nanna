import 'dart:async';

import 'package:better_informed_mobile/data/categories/api/categories_data_source.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_with_items_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/categories/categories_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl(
    this._categoriesDataSource,
    this._categoryDTOMapper,
    this._categoryWithItemsDTOMapper,
  );

  final CategoriesDataSource _categoriesDataSource;
  final CategoryDTOMapper _categoryDTOMapper;
  final CategoryWithItemsDTOMapper _categoryWithItemsDTOMapper;
  final StreamController<List<Category>> _categoryStreamController = BehaviorSubject<List<Category>>.seeded([]);

  @override
  Future<List<Category>> getOnboardingCategories() async {
    final dto = await _categoriesDataSource.getOnboardingCategories();
    return dto.categories.map<Category>(_categoryDTOMapper).toList();
  }

  @override
  Future<List<Category>> getFeaturedCategories() async {
    final dto = await _categoriesDataSource.getFeaturedCategories();
    return dto.categories.map<Category>(_categoryDTOMapper).toList();
  }

  @override
  Stream<List<Category>> get categoriesStream => _categoryStreamController.stream.asBroadcastStream();

  @override
  void setSelectedCategories(List<Category> categories) => _categoryStreamController.add(categories);

  @override
  Future<CategoryWithItems> getPaginatedCategory(String slug, int limit, int offset) async {
    final dto = await _categoriesDataSource.getPaginatedCategory(slug, limit, offset);
    return _categoryWithItemsDTOMapper(dto);
  }
}
