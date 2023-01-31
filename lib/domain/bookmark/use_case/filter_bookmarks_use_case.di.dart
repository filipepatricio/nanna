import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

typedef KeyFunction<K, T> = K Function(T element);

@injectable
class FilterBookmarksUseCase {
  Future<List<Bookmark>> call(
    List<Synchronizable<Bookmark>> bookmarks,
    BookmarkFilter filter,
    BookmarkSort sort,
    BookmarkOrder order,
  ) async {
    return compute(_filter, _Data(bookmarks, filter, sort, order));
  }

  static List<Bookmark> _filter(_Data data) {
    final bookmarks = data.bookmarks.whereType<Synchronized<Bookmark>>();
    final Iterable<Synchronized<Bookmark>> filtered;

    switch (data.filter) {
      case BookmarkFilter.all:
        filtered = bookmarks;
        break;
      case BookmarkFilter.article:
        filtered = bookmarks.where((synchronizable) => synchronizable.data.data.isArticle());
        break;
      case BookmarkFilter.topic:
        filtered = bookmarks.where((synchronizable) => synchronizable.data.data.isTopic());
        break;
    }

    final List<Synchronized<Bookmark>> sorted;

    switch (data.sort) {
      case BookmarkSort.alphabetical:
        sorted = _sortByName(filtered, data.order);
        break;
      case BookmarkSort.added:
        sorted = _sortByCreationDate(filtered.toList(), data.order);
        break;
      case BookmarkSort.updated:
        sorted = _sortByUpdateDate(filtered.toList(), data.order);
        break;
    }

    return sorted.map((e) => e.data).toList(growable: false);
  }

  static List<Synchronized<Bookmark>> _sortByName(
    Iterable<Synchronized<Bookmark>> bookmarks,
    BookmarkOrder order,
  ) {
    switch (order) {
      case BookmarkOrder.ascending:
        return bookmarks.sortedByCompare((element) => element.data.data.name, (a, b) => a.compareTo(b)).toList();
      case BookmarkOrder.descending:
        return bookmarks.sortedByCompare((element) => element.data.data.name, (a, b) => b.compareTo(a)).toList();
    }
  }

  static List<Synchronized<Bookmark>> _sortByCreationDate(
    List<Synchronized<Bookmark>> bookmarks,
    BookmarkOrder order,
  ) {
    switch (order) {
      case BookmarkOrder.ascending:
        return bookmarks.sortedByCompare((element) => element.createdAt, (a, b) => a.compareTo(b)).toList();
      case BookmarkOrder.descending:
        return bookmarks.sortedByCompare((element) => element.createdAt, (a, b) => b.compareTo(a)).toList();
    }
  }

  static List<Synchronized<Bookmark>> _sortByUpdateDate(
    List<Synchronized<Bookmark>> bookmarks,
    BookmarkOrder order,
  ) {
    switch (order) {
      case BookmarkOrder.ascending:
        return bookmarks.sortedByCompare((element) => element.synchronizedAt, (a, b) => a.compareTo(b)).toList();
      case BookmarkOrder.descending:
        return bookmarks.sortedByCompare((element) => element.synchronizedAt, (a, b) => b.compareTo(a)).toList();
    }
  }
}

class _Data {
  _Data(this.bookmarks, this.filter, this.sort, this.order);

  final List<Synchronizable<Bookmark>> bookmarks;
  final BookmarkFilter filter;
  final BookmarkSort sort;
  final BookmarkOrder order;
}

extension on BookmarkData {
  bool isArticle() {
    return map(
      article: (_) => true,
      topic: (_) => false,
      unknown: (_) => false,
    );
  }

  bool isTopic() {
    return map(
      article: (_) => false,
      topic: (_) => true,
      unknown: (_) => false,
    );
  }

  String get name {
    return map(
      article: (data) => data.article.strippedTitle,
      topic: (data) => data.topic.strippedTitle,
      unknown: (_) => throw Exception('Unknown bookmark type'),
    );
  }
}
