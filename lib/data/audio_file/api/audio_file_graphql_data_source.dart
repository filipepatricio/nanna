import 'package:better_informed_mobile/data/audio_file/api/audio_file_api_data_source.dart';
import 'package:better_informed_mobile/data/audio_file/api/audio_file_gql.dart';
import 'package:better_informed_mobile/data/audio_file/api/dto/audio_file_dto.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudioFileApiDataSource, env: liveEnvs)
class AudioFileDataSource implements AudioFileApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  AudioFileDataSource(this._client, this._responseResolver);

  @override
  Future<AudioFileDTO> getArticleAudioFile(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: AudioFileGQL.articleAudioFile(slug),
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        return AudioFileDTO.fromJson(raw);
      },
      rootKey: 'getArticleAudioFile',
    );

    if (dto == null) throw Exception('AudioFile is null');
    return dto;
  }
}
