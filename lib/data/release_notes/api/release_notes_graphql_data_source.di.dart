import 'package:better_informed_mobile/data/networking/dato_cms_gql_client_factory.di.dart';
import 'package:better_informed_mobile/data/release_notes/api/documents/__generated__/get_release_notes.ast.gql.dart'
    as get_release_notes;
import 'package:better_informed_mobile/data/release_notes/api/release_notes_data_source.dart';
import 'package:better_informed_mobile/data/release_notes/dto/release_note_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const _rootKey = 'releaseNote';

@LazySingleton(as: ReleaseNotesDataSource, env: defaultEnvs)
class ReleaseNotesGraphqlDataSource implements ReleaseNotesDataSource {
  ReleaseNotesGraphqlDataSource(
    @Named(releaseNotesClientName) this._gqlClient,
    this._resolver,
  );

  final GraphQLClient _gqlClient;
  final GraphQLResponseResolver _resolver;

  @override
  Future<ReleaseNoteDTO?> getReleaseNote(String version) async {
    final result = await _gqlClient.query(
      QueryOptions(
        document: get_release_notes.document,
        operationName: get_release_notes.getReleaseNotes.name?.value,
        variables: {
          'version': version,
        },
      ),
    );

    if (result.data?[_rootKey] == null) return null;

    final dto = _resolver.resolve<ReleaseNoteDTO?>(
      result,
      (raw) => ReleaseNoteDTO.fromJson(raw),
      rootKey: _rootKey,
    );

    return dto;
  }
}
