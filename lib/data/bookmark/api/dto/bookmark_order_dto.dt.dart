import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_order_dto.dt.freezed.dart';

@Freezed(toJson: false)
class BookmarkOrderDTO with _$BookmarkOrderDTO {
  const factory BookmarkOrderDTO._(String value) = _BookmarkOrderDTO;

  factory BookmarkOrderDTO.descending() => const BookmarkOrderDTO._('DESC');

  factory BookmarkOrderDTO.ascending() => const BookmarkOrderDTO._('ASC');
}
