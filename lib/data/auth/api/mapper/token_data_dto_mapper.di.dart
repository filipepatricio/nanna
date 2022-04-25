import 'package:better_informed_mobile/data/auth/api/dto/token_data_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/auth/data/token_data.dart';
import 'package:injectable/injectable.dart';

@injectable
class TokenDataDTOMapper implements Mapper<TokenDataDTO, TokenData> {
  const TokenDataDTOMapper();

  @override
  TokenData call(TokenDataDTO data) {
    return TokenData(
      uuid: data.uuid,
      email: data.email,
      firstName: data.firstName,
      lastName: data.lastName,
    );
  }
}
