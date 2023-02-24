import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/relax_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/call_to_action_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';
import 'package:injectable/injectable.dart';

@injectable
class RelaxEntityMapper implements BidirectionalMapper<RelaxEntity, Relax> {
  RelaxEntityMapper(this._callToActionEntityMapper);

  final CallToActionEntityMapper _callToActionEntityMapper;

  @override
  RelaxEntity from(Relax data) {
    final action = data.callToAction;

    return RelaxEntity(
      headline: data.headline,
      message: data.message,
      icon: data.icon,
      callToAction: action != null ? _callToActionEntityMapper.from(action) : null,
    );
  }

  @override
  Relax to(RelaxEntity data) {
    final action = data.callToAction;

    return Relax(
      headline: data.headline,
      message: data.message,
      icon: data.icon,
      callToAction: action != null ? _callToActionEntityMapper.to(action) : null,
    );
  }
}
