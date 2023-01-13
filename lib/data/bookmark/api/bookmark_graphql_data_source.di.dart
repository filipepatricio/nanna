import 'package:better_informed_mobile/data/bookmark/api/bookmark_data_source.dart';
import 'package:better_informed_mobile/data/bookmark/api/documents/__generated__/article_id.ast.gql.dart' as article_id;
import 'package:better_informed_mobile/data/bookmark/api/documents/__generated__/bookmark_article.ast.gql.dart'
    as bookmark_article;
import 'package:better_informed_mobile/data/bookmark/api/documents/__generated__/bookmark_topic.ast.gql.dart'
    as bookmark_topic;
import 'package:better_informed_mobile/data/bookmark/api/documents/__generated__/get_paginated_bookmarks.ast.gql.dart'
    as get_paginated_bookmarks;
import 'package:better_informed_mobile/data/bookmark/api/documents/__generated__/remove_bookmark.ast.gql.dart'
    as remove_bookmark;
import 'package:better_informed_mobile/data/bookmark/api/documents/__generated__/topic_id.ast.gql.dart' as topic_id;
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_filter_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_id_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_list_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_order_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_sort_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/dto/update_bookmark_response_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BookmarkDataSource, env: defaultEnvs)
class BookmarkGraphqlDataSource implements BookmarkDataSource {
  BookmarkGraphqlDataSource(this._client, this._responseResolver);

  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  @override
  Future<BookmarkIdDTO?> getArticleBookmarkId(String articleSlug) async {
    final result = await _client.query(
      QueryOptions(
        document: article_id.document,
        operationName: article_id.articleId.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'slug': articleSlug,
        },
      ),
    );

    return _resolveBookmarkState(result, 'getArticleBookmark');
  }

  @override
  Future<BookmarkIdDTO?> getTopicBookmarkId(String topicSlug) async {
    final result = await _client.query(
      QueryOptions(
        document: topic_id.document,
        operationName: topic_id.topicId.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'slug': topicSlug,
        },
      ),
    );

    return _resolveBookmarkState(result, 'getTopicBookmark');
  }

  @override
  Future<UpdateBookmarkResponseDTO> bookmarkArticle(String articleSlug) async {
    final result = await _client.mutate(
      MutationOptions(
        document: bookmark_article.document,
        operationName: bookmark_article.bookmarkArticle.name?.value,
        variables: {
          'slug': articleSlug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => UpdateBookmarkResponseDTO.fromJson(raw),
      rootKey: 'bookmarkArticle',
    );

    if (dto == null) throw Exception('Response for adding article bookmark is null');
    return dto;
  }

  @override
  Future<UpdateBookmarkResponseDTO> bookmarkTopic(String topicSlug) async {
    final result = await _client.mutate(
      MutationOptions(
        document: bookmark_topic.document,
        operationName: bookmark_topic.bookmarkTopic.name?.value,
        variables: {
          'slug': topicSlug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => UpdateBookmarkResponseDTO.fromJson(raw),
      rootKey: 'bookmarkTopic',
    );

    if (dto == null) throw Exception('Response for adding topic bookmark is null');
    return dto;
  }

  @override
  Future<UpdateBookmarkResponseDTO> removeBookmark(String bookmarkId) async {
    final result = await _client.mutate(
      MutationOptions(
        document: remove_bookmark.document,
        operationName: remove_bookmark.removeBookmark.name?.value,
        variables: {
          'id': bookmarkId,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => UpdateBookmarkResponseDTO.fromJson(raw),
      rootKey: 'removeBookmark',
    );

    if (dto == null) throw Exception('Response for removing bookmark is null');
    return dto;
  }

  BookmarkIdDTO? _resolveBookmarkState(QueryResult result, String key) {
    return _responseResolver.resolve<BookmarkIdDTO?>(
      result,
      (raw) {
        final json = raw[key] as Map<String, dynamic>?;

        if (json == null) return null;
        return BookmarkIdDTO.fromJson(json);
      },
    );
  }

  @override
  Future<BookmarkListDTO> getPaginatedBookmarks({
    required int limit,
    required int offset,
    required BookmarkFilterDTO filter,
    required BookmarkOrderDTO order,
    required BookmarkSortDTO sortBy,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: get_paginated_bookmarks.document,
        operationName: get_paginated_bookmarks.getPaginatedBookmarks.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'limit': limit,
          'offset': offset,
          'filter': filter.value,
          'order': order.value,
          'sortBy': sortBy.value,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => BookmarkListDTO.fromJson(raw),
    );

    if (dto == null) throw Exception('Paginated bookmarks response is null');
    return dto;
  }
}
