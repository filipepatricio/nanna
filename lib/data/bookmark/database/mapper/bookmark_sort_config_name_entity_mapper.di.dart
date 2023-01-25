import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_sort_config_name_entity.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:injectable/injectable.dart';

const _entityMap = {
  'last_updated': BookmarkSortConfigName.lastUpdated,
  'last_added': BookmarkSortConfigName.lastAdded,
  'alphabetical_asc': BookmarkSortConfigName.alphabeticalAsc,
  'alphabetical_desc': BookmarkSortConfigName.alphabeticalDesc,
};

@injectable
class BookmarkSortConfigNameEntityMapper
    implements BidirectionalMapper<BookmarkSortConfigName, BookmarkSortConfigNameEntity> {
  @override
  BookmarkSortConfigName from(BookmarkSortConfigNameEntity data) {
    return _entityMap[data.value] ?? (throw Exception('Unknown bookmark sort config stored: ${data.value}'));
  }

  @override
  BookmarkSortConfigNameEntity to(BookmarkSortConfigName data) {
    final value = _entityMap.entries.firstWhere((element) => element.value == data).key;
    return BookmarkSortConfigNameEntity(value);
  }
}
