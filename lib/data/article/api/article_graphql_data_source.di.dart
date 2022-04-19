import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/article_gql.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const _contentKey = 'text';

@LazySingleton(as: ArticleApiDataSource, env: liveEnvs)
class ArticleGraphqlDataSource implements ArticleApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  ArticleGraphqlDataSource(this._client, this._responseResolver);

  @override
  Future<ArticleContentDTO> getArticleContent(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: ArticleGQL.articleContent(slug),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final content = raw[_contentKey] as Map<String, dynamic>;
        return ArticleContentDTO.fromJson(content);
      },
      rootKey: 'article',
    );

    if (dto == null) throw Exception('ArticleContent is null');
    return dto;
  }

  @override
  Future<ArticleHeaderDTO> getArticleHeader(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: ArticleGQL.articleHeader(slug),
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        return ArticleHeaderDTO.fromJson(raw);
      },
      rootKey: 'article',
    );

    if (dto == null) throw Exception('Article is null');
    return dto;
  }

  @override
  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh) async {
    final result = await _client.query(
      QueryOptions(
        document: ArticleGQL.articleAudioFile(slug),
        fetchPolicy: forceFresh ? FetchPolicy.networkOnly : FetchPolicy.cacheAndNetwork,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        return AudioFileDTO.fromJson(raw);
      },
      rootKey: 'getArticleAudioFile',
    );

    if (dto == null) throw Exception('AudioFile is null');
    return dto;
  }
}
