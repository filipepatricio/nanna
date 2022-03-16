import 'package:better_informed_mobile/data/invite/api/invite_api_data_source.dart';
import 'package:better_informed_mobile/data/invite/mapper/invite_code_dto_mapper.dart';
import 'package:better_informed_mobile/domain/invite/data/invite_code.dart';
import 'package:better_informed_mobile/domain/invite/invite_remote_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: InviteRemoteRepository)
class InviteRemoteRepositoryImpl implements InviteRemoteRepository {
  InviteRemoteRepositoryImpl(
    this._inviteApiDataSource,
    this._inviteCodeDTOMapper,
  );

  final InviteApiDataSource _inviteApiDataSource;
  final InviteCodeDTOMapper _inviteCodeDTOMapper;

  @override
  Future<InviteCode> getInviteCode() async {
    final dto = await _inviteApiDataSource.getInviteCode();
    return _inviteCodeDTOMapper(dto);
  }
}
