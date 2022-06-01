import 'package:better_informed_mobile/data/article/api/mapper/article_kind_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/article_image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryItemDTOMapper implements Mapper<BriefEntryItemDTO, BriefEntryItem> {
  final ArticleImageDTOMapper _articleImageDTOMapper;
  final PublisherDTOMapper _publisherDTOMapper;
  final ArticleTypeDTOMapper _articleTypeDTOMapper;
  final ArticleKindDTOMapper _articleKindDTOMapper;
  final SummaryCardDTOMapper _summaryCardDTOMapper;
  final TopicOwnerDTOMapper _topicOwnerDTOMapper;
  final EntryDTOMapper _entryDTOMapper;
  final ImageDTOMapper _imageDTOMapper;

  BriefEntryItemDTOMapper(
    this._articleImageDTOMapper,
    this._publisherDTOMapper,
    this._articleTypeDTOMapper,
    this._articleKindDTOMapper,
    this._summaryCardDTOMapper,
    this._topicOwnerDTOMapper,
    this._entryDTOMapper,
    this._imageDTOMapper,
  );

  @override
  BriefEntryItem call(BriefEntryItemDTO data) {
    return data.map(
      article: (data) {
        final image = data.image;
        final publicationDate = data.publicationDate;
        final kind = data.kind;

        return BriefEntryItem.article(
          id: data.id,
          slug: data.slug,
          url: data.url,
          title: data.title,
          strippedTitle: data.strippedTitle,
          credits: data.credits,
          timeToRead: data.timeToRead,
          type: _articleTypeDTOMapper(data.type),
          kind: kind != null ? _articleKindDTOMapper(kind) : null,
          publicationDate: publicationDate != null ? DateTime.parse(publicationDate).toLocal() : null,
          image: image != null ? _articleImageDTOMapper(image) : null,
          publisher: _publisherDTOMapper(data.publisher),
          sourceUrl: data.sourceUrl,
          author: data.author,
          hasAudioVersion: data.hasAudioVersion,
        );
      },
      topic: (data) {
        return BriefEntryItem.topic(
          id: data.id,
          slug: data.slug,
          title: data.title,
          strippedTitle: data.strippedTitle,
          introduction: data.introduction,
          url: data.url,
          owner: _topicOwnerDTOMapper(data.owner),
          lastUpdatedAt: DateTime.parse(data.lastUpdatedAt).toLocal(),
          highlightedPublishers: data.highlightedPublishers.map<Publisher>(_publisherDTOMapper).toList(),
          heroImage: _imageDTOMapper(data.heroImage),
          coverImage: _imageDTOMapper(data.coverImage),
          entries: data.entries.map<Entry>(_entryDTOMapper).toList(),
          topicSummaryList: data.summaryCards.map<TopicSummary>(_summaryCardDTOMapper).toList(),
        );
      },
      unknown: (_) => const BriefEntryItem.unknown(),
    );
  }
}
