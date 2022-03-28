import 'package:better_informed_mobile/data/audio_file/api/audio_file_api_data_source.dart';
import 'package:better_informed_mobile/data/audio_file/api/dto/audio_file_dto.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudioFileApiDataSource, env: mockEnvs)
class AudioFileGraphqlDataSource implements AudioFileApiDataSource {
  @override
  Future<AudioFileDTO> getArticleAudioFile(String slug) async {
    return MockDTO.audioFile;
  }
}
