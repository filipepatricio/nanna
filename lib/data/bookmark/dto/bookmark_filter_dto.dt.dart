import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_filter_dto.dt.freezed.dart';

@Freezed(toJson: false)
class BookmarkFilterDTO with _$BookmarkFilterDTO {
  const factory BookmarkFilterDTO._(String value) = _BookmarkFilterDTO;

  factory BookmarkFilterDTO.article() => const BookmarkFilterDTO._('ARTICLE');

  factory BookmarkFilterDTO.topic() => const BookmarkFilterDTO._('TOPIC');

  factory BookmarkFilterDTO.all() => const BookmarkFilterDTO._('ALL');
}
