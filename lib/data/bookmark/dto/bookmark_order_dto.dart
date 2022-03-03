import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_order_dto.freezed.dart';

@freezed
class BookmarkOrderDTO with _$BookmarkOrderDTO {
  const factory BookmarkOrderDTO._(String value) = _BookmarkOrderDTO;

  factory BookmarkOrderDTO.descending() => const BookmarkOrderDTO._('DESC');

  factory BookmarkOrderDTO.ascending() => const BookmarkOrderDTO._('ASC');
}
