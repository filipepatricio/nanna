import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_style_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/presentation/util/color_util.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryStyleDTOMapper implements Mapper<BriefEntryStyleDTO, BriefEntryStyle> {
  @override
  BriefEntryStyle call(BriefEntryStyleDTO data) {
    final backgroundColor = data.backgroundColor;
    return BriefEntryStyle(
      backgroundColor: backgroundColor != null ? HexColor(backgroundColor) : null,
      type: data.type,
    );
  }
}
