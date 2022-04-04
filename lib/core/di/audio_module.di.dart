import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:better_informed_mobile/data/audio/handler/informed_audio_handler.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

@module
abstract class AudioModule {
  @lazySingleton
  AudioPlayer get audioPlayer => AudioPlayer();

  @preResolve
  @LazySingleton(env: liveEnvs)
  Future<AudioSession> get audioSession => AudioSession.instance;

  @preResolve
  @LazySingleton(env: liveEnvs)
  Future<AudioHandler> getAudioHandler(
    AudioPlayer player,
    AudioSession audioSession,
    AppConfig config,
  ) async {
    await audioSession.configure(const AudioSessionConfiguration.speech());
    return AudioService.init(
      builder: () => InformedAudioHandler(player),
      config: AudioServiceConfig(
        androidNotificationChannelId: '${config.appId}.channel.audio',
        androidNotificationChannelName: 'Article audio playback',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: true,
        fastForwardInterval: const Duration(seconds: 10),
        rewindInterval: const Duration(seconds: 10),
      ),
    );
  }
}
