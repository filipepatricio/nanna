import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/documents/__generated__/article_audio_file.ast.gql.dart'
    as article_audio_file;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/article_content.ast.gql.dart'
    as article_content;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/article_header.ast.gql.dart'
    as article_header;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/get_other_brief_entries.ast.gql.dart'
    as get_other_brief_entries;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/update_article_audio_position.ast.gql.dart'
    as update_article_audio_position;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/update_article_content_progress.ast.gql.dart'
    as update_article_content_progress;
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/other_brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/exception/article_exception_mapper_facade.di.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fimber/fimber.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const _contentKey = 'text';

@LazySingleton(as: ArticleApiDataSource, env: liveEnvs)
class ArticleGraphqlDataSource implements ArticleApiDataSource {
  ArticleGraphqlDataSource(
    this._client,
    this._responseResolver,
    this._articleExceptionMapperFacade,
  );

  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;
  final ArticleExceptionMapperFacade _articleExceptionMapperFacade;

  @override
  Future<ArticleContentDTO> getArticleContent(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: article_content.document,
        operationName: article_content.articleContent.name?.value,
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final content = raw[_contentKey] as Map<String, dynamic>;
        return ArticleContentDTO.fromJson(content);
      },
      rootKey: 'article',
      customMapper: _articleExceptionMapperFacade,
    );

    if (dto == null) throw Exception('ArticleContent is null');
    return dto;
  }

  @override
  Future<ArticleHeaderDTO> getArticleHeader(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: article_header.document,
        operationName: article_header.articleHeader.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => ArticleHeaderDTO.fromJson(raw),
      rootKey: 'article',
      customMapper: _articleExceptionMapperFacade,
    );

    if (dto == null) {
      throw Exception('Article is null - ${result.hasException ? result.exception : 'no API exception'}');
    }

    return dto;
  }

  @override
  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh) async {
    final result = await _client.query(
      QueryOptions(
        document: article_audio_file.document,
        operationName: article_audio_file.getArticleAudioFile.name?.value,
        fetchPolicy: forceFresh ? FetchPolicy.networkOnly : FetchPolicy.cacheAndNetwork,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        return AudioFileDTO.fromJson(raw);
      },
      rootKey: 'getArticleAudioFile',
      customMapper: _articleExceptionMapperFacade,
    );

    if (dto == null) throw Exception('AudioFile is null');
    return dto;
  }

  @override
  Future<List<OtherBriefEntryItemDTO>> getOtherBriefEntries(String articleSlug) async {
    final result = await _client.query(
      QueryOptions(
        document: get_other_brief_entries.document,
        operationName: get_other_brief_entries.getOtherBriefEntries.name?.value,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        variables: {'articleSlug': articleSlug},
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final briefEntriesRaw = raw['getOtherBriefEntries'] as List<dynamic>;
        final briefEntries = briefEntriesRaw
            .map((json) => OtherBriefEntryItemDTO.fromJson(json as Map<String, dynamic>))
            .toList(growable: false);

        return briefEntries;
      },
    );

    if (dto == null) throw Exception('Response for other brief entries is null');
    return dto;
  }

  @override
  void trackAudioPosition(String slug, int position) => _client.mutate(
        MutationOptions(
          document: update_article_audio_position.document,
          operationName: update_article_audio_position.updateArticleAudioPosition.name?.value,
          variables: {
            'slug': slug,
            'position': position,
          },
          onError: (error) => Fimber.e('Could not track audio position', ex: error),
        ),
      );

  @override
  void trackReadingProgress(String slug, int progress) => _client.mutate(
        MutationOptions(
          document: update_article_content_progress.document,
          operationName: update_article_content_progress.updateArticleContentProgress.name?.value,
          variables: {
            'slug': slug,
            'progress': progress,
          },
          onError: (error) => Fimber.e('Could not track reading progress', ex: error),
        ),
      );
}
