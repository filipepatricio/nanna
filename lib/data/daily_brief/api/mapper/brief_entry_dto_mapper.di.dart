import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_style_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryDTOMapper implements Mapper<BriefEntryDTO, BriefEntry> {
  final BriefEntryItemDTOMapper _briefEntryItemDTOMapper;
  final BriefEntryStyleDTOMapper _briefEntryStyleDTOMapper;

  BriefEntryDTOMapper(
    this._briefEntryItemDTOMapper,
    this._briefEntryStyleDTOMapper,
  );

  @override
  BriefEntry call(BriefEntryDTO data) {
    return BriefEntry(
      item: _briefEntryItemDTOMapper(data.item),
      style: _briefEntryStyleDTOMapper(data.style),
    );
  }
}
