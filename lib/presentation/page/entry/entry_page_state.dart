import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry_page_state.freezed.dart';

@freezed
class EntryPageState with _$EntryPageState {
  @Implements<BuildState>()
  factory EntryPageState.idle() = _EntryPageStateIdle;

  factory EntryPageState.alreadySignedIn() = _EntryPageStateAlreadySignedIn;

  factory EntryPageState.notSignedIn() = _EntryPageStateNotSignedIn;
}
