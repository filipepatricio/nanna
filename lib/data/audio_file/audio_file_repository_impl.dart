import 'package:better_informed_mobile/data/audio_file/api/audio_file_api_data_source.dart';
import 'package:better_informed_mobile/data/audio_file/api/mapper/audio_file_dto_mapper.dart';
import 'package:better_informed_mobile/domain/audio_file/audio_file_repository.dart';
import 'package:better_informed_mobile/domain/audio_file/data/audio_file.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudioFileRepository)
class AudioFileRepositoryImpl implements AudioFileRepository {
  final AudioFileApiDataSource _audioFileDataSource;
  final AudioFileDTOMapper _audioFileDTOMapper;

  AudioFileRepositoryImpl(
    this._audioFileDataSource,
    this._audioFileDTOMapper,
  );

  @override
  Future<AudioFile> getArticleAudioFile(String slug) async {
    final dto = await _audioFileDataSource.getArticleAudioFile(slug);
    return _audioFileDTOMapper(dto);
  }
}
