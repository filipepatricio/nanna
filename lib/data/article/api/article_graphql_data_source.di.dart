import 'dart:async';

import 'package:better_informed_mobile/data/article/api/article_api_data_source.dart';
import 'package:better_informed_mobile/data/article/api/documents/__generated__/article_audio_file.ast.gql.dart'
    as article_audio_file;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/article_content.ast.gql.dart'
    as article_content;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/article_header.ast.gql.dart'
    as article_header;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/full_article.ast.gql.dart'
    as full_article;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/get_offline_articles.ast.gql.dart'
    as get_offline_articles;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/get_other_brief_entries.ast.gql.dart'
    as get_other_brief_entries;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/get_other_topic_entries.ast.gql.dart'
    as get_other_topic_entries;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/get_related_content.ast.gql.dart'
    as get_related_content;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/mark_article_as_seen.ast.gql.dart'
    as mark_article_as_seen;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/update_article_audio_position.ast.gql.dart'
    as update_article_audio_position;
import 'package:better_informed_mobile/data/article/api/documents/__generated__/update_article_content_progress.ast.gql.dart'
    as update_article_content_progress;
import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/topic_media_items_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/update_article_progress_response_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/exception/article_exception_mapper_facade.di.dart';
import 'package:better_informed_mobile/data/categories/dto/category_item_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/networking/gql_customs/gql_options_with_custom_exception_mapper.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/exception/article_blocked_by_subscription_exception.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ArticleApiDataSource, env: defaultEnvs)
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
      QueryOptionsWithCustomExceptionMapper(
        document: article_content.document,
        operationName: article_content.articleContent.name?.value,
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        exceptionMapper: _articleExceptionMapperFacade,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        return ArticleContentDTO.fromJson(raw);
      },
      rootKey: 'article',
    );

    if (dto == null) throw Exception('ArticleContent is null');

    return dto;
  }

  @override
  Future<ArticleHeaderDTO> getArticleHeader(String slug) async {
    final result = await _client.query(
      QueryOptionsWithCustomExceptionMapper(
        document: article_header.document,
        operationName: article_header.articleHeader.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        exceptionMapper: _articleExceptionMapperFacade,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => ArticleHeaderDTO.fromJson(raw),
      rootKey: 'article',
    );

    if (dto == null) {
      throw Exception('Article is null - ${result.hasException ? result.exception : 'no API exception'}');
    }

    return dto;
  }

  @override
  Future<AudioFileDTO> getArticleAudioFile(String slug, bool forceFresh) async {
    final result = await _client.query(
      QueryOptionsWithCustomExceptionMapper(
        document: article_audio_file.document,
        operationName: article_audio_file.getArticleAudioFile.name?.value,
        fetchPolicy: forceFresh ? FetchPolicy.networkOnly : FetchPolicy.cacheAndNetwork,
        exceptionMapper: _articleExceptionMapperFacade,
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
    );

    if (dto == null) throw Exception('AudioFile is null');

    return dto;
  }

  @override
  Future<List<BriefEntryItemDTO>> getOtherBriefEntries(String articleSlug, String briefId) async {
    final result = await _client.query(
      QueryOptions(
        document: get_other_brief_entries.document,
        operationName: get_other_brief_entries.getOtherBriefEntries.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'articleSlug': articleSlug,
          'briefId': briefId,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final briefEntriesRaw = raw['getOtherBriefEntries'] as List<dynamic>;
        final briefEntries = briefEntriesRaw
            .map((json) => BriefEntryItemDTO.fromJson(json as Map<String, dynamic>))
            .toList(growable: false);

        return briefEntries;
      },
    );

    if (dto == null) throw Exception('Response for other brief entries is null');

    return dto;
  }

  @override
  Future<UpdateArticleProgressResponseDTO> trackAudioPosition(String slug, int position) async {
    final result = await _client.mutate(
      MutationOptions(
        document: update_article_audio_position.document,
        operationName: update_article_audio_position.updateArticleAudioPosition.name?.value,
        variables: {
          'slug': slug,
          'position': position,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      rootKey: 'updateArticleAudioPosition',
      UpdateArticleProgressResponseDTO.fromJson,
    );

    if (dto == null) throw Exception('Response for article audio position update is null');

    return dto;
  }

  @override
  Future<UpdateArticleProgressResponseDTO> trackReadingProgress(String slug, int progress) async {
    final result = await _client.mutate(
      MutationOptions(
        document: update_article_content_progress.document,
        operationName: update_article_content_progress.updateArticleContentProgress.name?.value,
        variables: {
          'slug': slug,
          'progress': progress,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      rootKey: 'updateArticleContentProgress',
      UpdateArticleProgressResponseDTO.fromJson,
    );

    if (dto == null) throw Exception('Response for article progress update is null');

    return dto;
  }

  @override
  Future<TopicMediaItemsDTO> getOtherTopicEntries(String articleSlug, String topicSlug) async {
    final result = await _client.query(
      QueryOptions(
        document: get_other_topic_entries.document,
        operationName: get_other_topic_entries.getOtherTopicEntries.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'articleSlug': articleSlug,
          'topicSlug': topicSlug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      TopicMediaItemsDTO.fromJson,
    );

    if (dto == null) throw Exception('Other topic entries response is null');

    return dto;
  }

  @override
  Future<List<CategoryItemDTO>> getRelatedContent(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: get_related_content.document,
        fetchPolicy: FetchPolicy.networkOnly,
        operationName: get_related_content.getRelatedContent.name?.value,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final briefEntriesRaw = raw['getRelatedContent'] as List<dynamic>;
        return briefEntriesRaw.map((json) => CategoryItemDTO.fromJson(json as Map<String, dynamic>)).toList();
      },
    );

    if (dto == null) throw Exception('Response for related content s is null');
    return dto;
  }

  @override
  Future<SuccessfulResponseDTO> markArticleAsSeen(String slug) async {
    final result = await _client.mutate(
      MutationOptions(
        document: mark_article_as_seen.document,
        operationName: mark_article_as_seen.markArticleAsSeen.name?.value,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => SuccessfulResponseDTO.fromJson(raw),
      rootKey: 'markArticleSeen',
    );

    return dto ?? SuccessfulResponseDTO(false);
  }

  @override
  Future<ArticleDTO> getArticle(String slug, bool hasAudio) async {
    final result = await _client.query(
      QueryOptionsWithCustomExceptionMapper(
        document: full_article.document,
        operationName: full_article.fullArticle.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        exceptionMapper: _articleExceptionMapperFacade,
        variables: {
          'slug': slug,
        },
      ),
    );

    AudioFileDTO? audioFile;

    if (hasAudio) {
      try {
        audioFile = await getArticleAudioFile(slug, false);
      } on ArticleBlockedBySubscriptionException {
        audioFile = null;
      }
    }

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final header = ArticleHeaderDTO.fromJson(raw['article'] as Map<String, dynamic>);
        final content = ArticleContentDTO.fromJson(raw['article'] as Map<String, dynamic>);
        final audio = audioFile;
        return ArticleDTO(header: header, content: content, audioFile: audio);
      },
    );

    if (dto == null) throw Exception('Response for article is null');

    return dto;
  }

  @override
  Future<List<ArticleDTO>> getArticleBatch(List<String> slugs) async {
    final result = await _client.query(
      QueryOptionsWithCustomExceptionMapper(
        document: get_offline_articles.document,
        operationName: get_offline_articles.getOfflineArticles.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        exceptionMapper: _articleExceptionMapperFacade,
        variables: {
          'slugs': slugs,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final list = raw['getOfflineArticles'] as List<dynamic>;
        return list.cast<Map<String, dynamic>>().map((json) {
          final header = ArticleHeaderDTO.fromJson(json['article'] as Map<String, dynamic>);
          final content = ArticleContentDTO.fromJson(json['article'] as Map<String, dynamic>);
          final audio =
              raw['audioFile'] != null ? AudioFileDTO.fromJson(json['audioFile'] as Map<String, dynamic>) : null;
          return ArticleDTO(header: header, content: content, audioFile: audio);
        }).toList(growable: false);
      },
    );

    if (dto == null) throw Exception('Response for article batch is null');

    return dto;
  }
}
