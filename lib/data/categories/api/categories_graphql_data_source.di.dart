import 'package:better_informed_mobile/data/categories/api/categories_data_source.dart';
import 'package:better_informed_mobile/data/categories/api/documents/__generated__/get_category.ast.gql.dart'
    as get_category;
import 'package:better_informed_mobile/data/categories/api/documents/__generated__/get_category_preferences.ast.gql.dart'
    as get_category_preferences;
import 'package:better_informed_mobile/data/categories/api/documents/__generated__/get_featured_categories.ast.gql.dart'
    as get_featured_categories;
import 'package:better_informed_mobile/data/categories/api/documents/__generated__/get_onboarding_categories.ast.gql.dart'
    as get_onboarding_categories;
import 'package:better_informed_mobile/data/categories/dto/categories_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_preference_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesDataSource, env: liveEnvs)
class CategoriesGraphqlDataSource implements CategoriesDataSource {
  const CategoriesGraphqlDataSource(
    this._client,
    this._responseResolver,
  );

  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  @override
  Future<CategoriesDTO> getOnboardingCategories() async {
    final result = await _client.query(
      QueryOptions(
        document: get_onboarding_categories.document,
        operationName: get_onboarding_categories.getOnboardingCategories.name?.value,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final categoriesRaw = raw['getOnboardingCategories'] as List<dynamic>;
        final categories =
            categoriesRaw.map((json) => CategoryDTO.fromJson(json as Map<String, dynamic>)).toList(growable: false);
        return CategoriesDTO(categories);
      },
    );

    if (dto == null) throw Exception('Response for onboarding categories is null');
    return dto;
  }

  @override
  Future<List<CategoryPreferenceDTO>> getCategoryPreferences() async {
    final result = await _client.query(
      QueryOptions(
        document: get_category_preferences.document,
        operationName: get_category_preferences.getCategoryPreferences.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final categoriesPreferenceRaw = raw['getCategoryPreferences'] as List<dynamic>;
        final categoriesPreference = categoriesPreferenceRaw
            .map((json) => CategoryPreferenceDTO.fromJson(json as Map<String, dynamic>))
            .toList(growable: false);

        return categoriesPreference;
      },
    );

    if (dto == null) throw Exception('Response for category preferences is null');
    return dto;
  }

  @override
  Future<CategoriesDTO> getFeaturedCategories() async {
    final result = await _client.query(
      QueryOptions(
        document: get_featured_categories.document,
        operationName: get_featured_categories.getFeaturedCategories.name?.value,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final categoriesRaw = raw['getFeaturedCategories'] as List<dynamic>;
        final categories =
            categoriesRaw.map((json) => CategoryDTO.fromJson(json as Map<String, dynamic>)).toList(growable: false);
        return CategoriesDTO(categories);
      },
    );

    if (dto == null) throw Exception('Response for featured categories is null');
    return dto;
  }

  @override
  Future<CategoryDTO> getPaginatedCategory(String slug, int limit, int offset) async {
    final result = await _client.query(
      QueryOptions(
        document: get_category.document,
        operationName: get_category.getCategory.name?.value,
        variables: {
          'slug': slug,
          'limit': limit,
          'offset': offset,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => CategoryDTO.fromJson(raw),
      rootKey: 'getCategory',
    );

    if (dto == null) throw Exception('Response for get category is null');
    return dto;
  }
}
