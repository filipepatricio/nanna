import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snackbar_parent_view_state.dt.freezed.dart';

@Freezed(toJson: false)
class SnackbarParentViewState with _$SnackbarParentViewState {
  const SnackbarParentViewState._();

  @Implements<BuildState>()
  factory SnackbarParentViewState.idle() = _SnackbarParentViewStateIdle;

  @Implements<BuildState>()
  factory SnackbarParentViewState.message(SnackbarMessage message) = _SnackbarParentViewStateMessage;

  bool isMessageVisible() => maybeMap(
        message: (_) => true,
        orElse: () => false,
      );

  SnackbarMessage? get nullableMessage => maybeMap(
        message: (state) => state.message,
        orElse: () => null,
      );
}
