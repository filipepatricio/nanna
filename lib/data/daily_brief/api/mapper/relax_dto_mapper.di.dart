import 'package:better_informed_mobile/data/daily_brief/api/dto/relax_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/call_to_action_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';
import 'package:injectable/injectable.dart';

@injectable
class RelaxDTOMapper extends Mapper<RelaxDTO, Relax> {
  RelaxDTOMapper(this._callToActionDTOMapper);

  final CallToActionDTOMapper _callToActionDTOMapper;

  @override
  Relax call(RelaxDTO data) {
    return Relax(
      message: data.message,
      icon: data.icon,
      callToAction: _callToActionDTOMapper(data.callToAction),
      headline: data.headline,
    );
  }
}
