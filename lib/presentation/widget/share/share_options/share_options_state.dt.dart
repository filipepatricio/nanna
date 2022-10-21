import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_options_state.dt.freezed.dart';

@Freezed(toJson: false)
class ShareOptionsState with _$ShareOptionsState {
  @Implements<BuildState>()
  const factory ShareOptionsState.loading() = _Loading;

  @Implements<BuildState>()
  const factory ShareOptionsState.idle(List<ShareOptions> shareOptions) = _Idle;
}
