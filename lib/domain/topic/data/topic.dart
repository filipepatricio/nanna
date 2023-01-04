import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';

class Topic {
  Topic({
    required this.id,
    required this.slug,
    required this.title,
    required this.strippedTitle,
    required this.introduction,
    required this.ownersNote,
    required this.url,
    required this.curationInfo,
    required this.lastUpdatedAt,
    required this.summary,
    required this.publisherInformation,
    required this.heroImage,
    required this.entries,
    required this.visited,
    required this.category,
  });

  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String? ownersNote;
  final String url;
  final CurationInfo curationInfo;
  final String? summary;
  final DateTime lastUpdatedAt;
  final TopicPublisherInformation publisherInformation;
  final Image heroImage;
  final List<Entry> entries;
  final bool visited;
  final Category category;

  MediaItemArticle articleAt(int index) => entries[index].item as MediaItemArticle;

  TopicPreview get asPreview {
    return TopicPreview(
      id,
      slug,
      title,
      strippedTitle,
      introduction,
      ownersNote,
      url,
      curationInfo,
      lastUpdatedAt,
      publisherInformation,
      heroImage,
      entries.length,
      visited,
      category,
    );
  }

  Topic copyWith({
    String? id,
    String? slug,
    String? title,
    String? strippedTitle,
    String? introduction,
    String? ownersNote,
    String? url,
    CurationInfo? curationInfo,
    String? summary,
    DateTime? lastUpdatedAt,
    TopicPublisherInformation? publisherInformation,
    Image? heroImage,
    List<Entry>? entries,
    bool? visited,
    Category? category,
  }) {
    return Topic(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      strippedTitle: strippedTitle ?? this.strippedTitle,
      introduction: introduction ?? this.introduction,
      ownersNote: ownersNote ?? this.ownersNote,
      url: url ?? this.url,
      curationInfo: curationInfo ?? this.curationInfo,
      summary: summary ?? this.summary,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      publisherInformation: publisherInformation ?? this.publisherInformation,
      heroImage: heroImage ?? this.heroImage,
      entries: entries ?? this.entries,
      visited: visited ?? this.visited,
      category: category ?? this.category,
    );
  }
}
