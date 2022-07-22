import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shareable_app_state.dt.freezed.dart';

@freezed
class ShareableAppState with _$ShareableAppState {
  @Implements<BuildState>()
  const factory ShareableAppState.loading() = _Loading;
  @Implements<BuildState>()
  const factory ShareableAppState.idle(List<ShareApp> shareApps) = _Idle;
}
