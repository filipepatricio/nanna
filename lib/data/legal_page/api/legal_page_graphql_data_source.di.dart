import 'package:better_informed_mobile/data/legal_page/api/documents/__generated__/get_page.ast.gql.dart' as get_page;
import 'package:better_informed_mobile/data/legal_page/api/legal_page_data_source.dart';
import 'package:better_informed_mobile/data/legal_page/dto/legal_page_dto.dt.dart';
import 'package:better_informed_mobile/data/networking/dato_cms_gql_client_factory.di.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const _privacyPolicyPageSlug = 'privacy-policy';
const _termsOfServicePageSlug = 'terms-of-service';

@LazySingleton(as: LegalPageDataSource, env: defaultEnvs)
class LegalPageGraphqlDataSource implements LegalPageDataSource {
  LegalPageGraphqlDataSource(
    @Named(legalPagesClientName) this._client,
    this._resolver,
  );

  final GraphQLClient _client;
  final GraphQLResponseResolver _resolver;

  @override
  Future<LegalPageDTO> getPrivacyPolicyPage() {
    return _getLegalPage(_privacyPolicyPageSlug);
  }

  @override
  Future<LegalPageDTO> getTermsOfServicePage() {
    return _getLegalPage(_termsOfServicePageSlug);
  }

  Future<LegalPageDTO> _getLegalPage(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: get_page.document,
        operationName: get_page.getPage.name?.value,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _resolver.resolve<LegalPageDTO>(
      result,
      (raw) => LegalPageDTO.fromJson(raw),
      rootKey: 'legalPage',
    );

    if (dto == null) throw Exception('Legal page $slug is null');

    return dto;
  }
}
