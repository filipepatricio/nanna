import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_style_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/presentation/util/color_util.dart';
import 'package:injectable/injectable.dart';

@injectable
class EntryStyleDTOMapper implements Mapper<EntryStyleDTO, EntryStyle> {
  @override
  EntryStyle call(EntryStyleDTO data) {
    return EntryStyle(
      color: HexColor(data.color),
      type: data.type,
    );
  }
}
