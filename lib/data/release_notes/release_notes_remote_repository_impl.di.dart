import 'package:better_informed_mobile/data/release_notes/api/release_notes_data_source.dart';
import 'package:better_informed_mobile/data/release_notes/mapper/release_note_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_remote_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReleaseNotesRemoteRepository)
class ReleaseNotesRemoteRepositoryImpl implements ReleaseNotesRemoteRepository {
  ReleaseNotesRemoteRepositoryImpl(
    this._dataSource,
    this._releaseNoteDTOMapper,
  );

  final ReleaseNotesDataSource _dataSource;
  final ReleaseNoteDTOMapper _releaseNoteDTOMapper;

  @override
  Future<ReleaseNote?> getReleaseNote(String version) async {
    final dto = await _dataSource.getReleaseNote(version);

    if (dto == null) return null;

    return _releaseNoteDTOMapper(dto);
  }
}
