import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_area_item.dt.freezed.dart';

@Freezed(toJson: false)
class ExploreAreaItem<T> with _$ExploreAreaItem<T> {
  factory ExploreAreaItem.standard(T value) = _ExploreAreaItemStandard;

  factory ExploreAreaItem.viewAll(String title) = _ExploreAreaItemViewAll;
}

extension ExploreAreaItemGenerator on ExploreAreaItem {
  static List<ExploreAreaItem<T>> generate<T>(
    List<T> values, {
    String? viewAllTitle,
  }) {
    return [
      ...values.map((value) => ExploreAreaItem.standard(value)),
      if (viewAllTitle != null) ExploreAreaItem.viewAll(viewAllTitle),
    ];
  }
}
