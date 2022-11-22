import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/documents/__generated__/delete_account.ast.gql.dart'
    as delete_account;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/follow_category.ast.gql.dart'
    as follow_category;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/get_category_preference.ast.gql.dart'
    as get_category_preference;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/get_category_preferences.ast.gql.dart'
    as get_category_preferences;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/query_user.ast.gql.dart' as query_user;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/unfollow_category.ast.gql.dart'
    as unfollow_category;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/update_preferred_categories.ast.gql.dart'
    as update_preferred_categories;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/update_user.ast.gql.dart' as update_user;
import 'package:better_informed_mobile/data/user/api/dto/category_preference_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserDataSource, env: liveEnvs)
class UserGraphqlDataSource implements UserDataSource {
  UserGraphqlDataSource(this._client, this._responseResolver);
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  @override
  Future<UserDTO> getUser() async {
    final result = await _client.query(
      QueryOptions(
        document: query_user.document,
        operationName: query_user.queryUser.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => UserDTO.fromJson(raw),
      rootKey: 'me',
    );

    return dto ?? (throw Exception('User can not be null'));
  }

  @override
  Future<UserDTO> updateUser(UserMetaDTO userMetaDto) async {
    final result = await _client.mutate(
      MutationOptions(
        document: update_user.document,
        operationName: update_user.updateUserMeta.name?.value,
        variables: {
          'firstName': userMetaDto.firstName,
          'lastName': userMetaDto.lastName,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => UserDTO.fromJson(raw),
      rootKey: 'updateUserMeta',
    );

    return dto ?? (throw Exception('User can not be null'));
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
  Future<SuccessfulResponseDTO> updatePreferredCategories(List<String> categoryIds) async {
    final result = await _client.mutate(
      MutationOptions(
        document: update_preferred_categories.document,
        operationName: update_preferred_categories.updatePreferredCategories.name?.value,
        variables: {
          'categoryIDs': categoryIds,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => SuccessfulResponseDTO.fromJson(raw),
      rootKey: 'updatePreferredCategories',
    );

    return dto ?? SuccessfulResponseDTO(false);
  }

  @override
  Future<SuccessfulResponseDTO> deleteAccount() async {
    final result = await _client.mutate(
      MutationOptions(
        document: delete_account.document,
        operationName: delete_account.deleteAccount.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => SuccessfulResponseDTO.fromJson(raw),
      rootKey: 'deleteAccount',
    );

    return dto ?? SuccessfulResponseDTO(false);
  }

  @override
  Future<SuccessfulResponseDTO> followCategory(String id) async {
    final result = await _client.mutate(
      MutationOptions(
        document: follow_category.document,
        operationName: follow_category.followCategory.name?.value,
        variables: {
          'categoryId': id,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => SuccessfulResponseDTO.fromJson(raw),
      rootKey: 'preferCategory',
    );

    return dto ?? SuccessfulResponseDTO(false);
  }

  @override
  Future<SuccessfulResponseDTO> unfollowCategory(String id) async {
    final result = await _client.mutate(
      MutationOptions(
        document: unfollow_category.document,
        operationName: unfollow_category.unfollowCategory.name?.value,
        variables: {
          'categoryId': id,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => SuccessfulResponseDTO.fromJson(raw),
      rootKey: 'unpreferCategory',
    );

    return dto ?? SuccessfulResponseDTO(false);
  }

  @override
  Future<CategoryPreferenceDTO> getCategoryPreference(String id) async {
    final result = await _client.query(
      QueryOptions(
        document: get_category_preference.document,
        operationName: get_category_preference.getCategoryPreference.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'categoryId': id,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => CategoryPreferenceDTO.fromJson(raw),
      rootKey: 'getCategoryPreference',
    );

    if (dto == null) throw Exception('Response for category preference is null');
    return dto;
  }
}
