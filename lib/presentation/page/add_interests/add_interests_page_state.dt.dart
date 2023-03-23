import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_interests_page_state.dt.freezed.dart';

const _minSelectedCategories = 4;

@Freezed(toJson: false)
class AddInterestsPageState with _$AddInterestsPageState {
  @Implements<BuildState>()
  factory AddInterestsPageState.loading() = _Loading;

  @Implements<BuildState>()
  factory AddInterestsPageState.idle({
    required List<Category> categories,
    required Set<Category> selectedCategories,
  }) = _Idle;

  @Implements<BuildState>()
  factory AddInterestsPageState.processing({
    required List<Category> categories,
    required Set<Category> selectedCategories,
  }) = _Processing;

  factory AddInterestsPageState.success() = _Success;

  factory AddInterestsPageState.failure() = _Failure;
}

// ignore: library_private_types_in_public_api
extension IdleExt on _Idle {
  bool get isSelectionValid => selectedCategories.length >= _minSelectedCategories;
}
