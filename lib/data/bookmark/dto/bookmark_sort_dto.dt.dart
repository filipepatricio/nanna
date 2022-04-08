import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_sort_dto.dt.freezed.dart';

@freezed
class BookmarkSortDTO with _$BookmarkSortDTO {
  const factory BookmarkSortDTO._(String value) = _BookmarkSortDTO;

  factory BookmarkSortDTO.added() => const BookmarkSortDTO._('ADDED');

  factory BookmarkSortDTO.alphabetical() => const BookmarkSortDTO._('ALPHABETICAL');

  factory BookmarkSortDTO.updated() => const BookmarkSortDTO._('UPDATED');
}
