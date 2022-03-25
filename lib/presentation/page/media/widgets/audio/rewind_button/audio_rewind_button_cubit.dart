import 'package:better_informed_mobile/domain/audio/use_case/rewind_audio_use_case.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/rewind_button/audio_rewind_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioRewindButtonCubit extends Cubit<AudioRewindButtonState> {
  AudioRewindButtonCubit(
    this._rewindAudioUseCase,
  ) : super(AudioRewindButtonState());

  final RewindAudioUseCase _rewindAudioUseCase;

  Future<void> rewind() async {
    await _rewindAudioUseCase();
  }
}
