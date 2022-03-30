import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_page_state.freezed.dart';

@freezed
class ProfilePageState with _$ProfilePageState {
  @Implements<BuildState>()
  factory ProfilePageState.initializing() = _ProfilePageStateInitializing;

  @Implements<BuildState>()
  factory ProfilePageState.idle(
    BookmarkFilter filter,
    BookmarkSortConfigName sortConfigName,
  ) = _ProfilePageStateIdle;
}
