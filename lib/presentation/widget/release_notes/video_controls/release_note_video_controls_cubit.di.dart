import 'dart:async';

import 'package:better_informed_mobile/presentation/widget/release_notes/video_controls/release_note_video_controls_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReleaseNoteVideoControlsCubit extends Cubit<ReleaseNoteVideoControlsState> {
  ReleaseNoteVideoControlsCubit() : super(ReleaseNoteVideoControlsState.overlay(false));

  Timer? _timer;

  void onVideoStateChange(bool isPlaying) {
    if (isPlaying != state.playing) {
      emit(ReleaseNoteVideoControlsState.overlay(isPlaying));
      if (isPlaying) {
        _resetTimer();
      } else {
        _timer?.cancel();
      }
    }
  }

  void toggleOverlay() {
    state.map(
      empty: (state) {
        emit(ReleaseNoteVideoControlsState.overlay(state.playing));
        _resetTimer();
      },
      overlay: (state) {
        emit(ReleaseNoteVideoControlsState.empty(state.playing));
        _timer?.cancel();
      },
    );
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(
      const Duration(seconds: 2),
      () {
        emit(ReleaseNoteVideoControlsState.empty(state.playing));
      },
    );
  }
}
