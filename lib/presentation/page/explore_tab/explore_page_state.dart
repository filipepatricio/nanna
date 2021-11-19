import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_page_state.freezed.dart';

@freezed
class ExplorePageState with _$ExplorePageState {
  @Implements(BuildState)
  factory ExplorePageState.initialLoading() = _ExplorePageStateInitialLoading;

  @Implements(BuildState)
  factory ExplorePageState.idle(List<ExploreContentArea> areas) = _ExplorePageStateIdle;
}
