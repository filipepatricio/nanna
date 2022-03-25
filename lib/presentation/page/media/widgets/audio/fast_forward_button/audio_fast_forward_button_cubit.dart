import 'package:better_informed_mobile/domain/audio/use_case/fast_forward_audio_use_case.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/fast_forward_button/audio_fast_forward_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AufioFastForwardButtonCubit extends Cubit<AudioFastForwardButtonState> {
  AufioFastForwardButtonCubit(
    this._fastForwardAudioUseCase,
  ) : super(AudioFastForwardButtonState());

  final FastForwardAudioUseCase _fastForwardAudioUseCase;

  Future<void> fastForward() async {
    await _fastForwardAudioUseCase();
  }
}
