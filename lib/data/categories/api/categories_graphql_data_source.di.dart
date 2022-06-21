import 'package:better_informed_mobile/data/categories/api/categories_data_source.dart';
import 'package:better_informed_mobile/data/categories/api/documents/__generated__/get_onboarding_categories.ast.gql.dart'
    as get_onboarding_categories;
import 'package:better_informed_mobile/data/categories/dto/onboarding_categories_response_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesDataSource, env: liveEnvs)
class OnboardingGraphqlDataSource implements CategoriesDataSource {
  const OnboardingGraphqlDataSource(
    this._client,
    this._responseResolver,
  );

  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  @override
  Future<OnboardingCategoriesResponseDTO> getOnboardingCategories() async {
    final result = await _client.query(
      QueryOptions(
        document: get_onboarding_categories.document,
        operationName: get_onboarding_categories.getOnboardingCategories.name?.value,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => OnboardingCategoriesResponseDTO.fromJson(raw),
    );

    if (dto == null) throw Exception('Response for onboarding categories is null');
    return dto;
  }
}
