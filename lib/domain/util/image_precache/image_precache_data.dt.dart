import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_precache_data.dt.freezed.dart';

@freezed
class ImagePrecacheData with _$ImagePrecacheData {
  factory ImagePrecacheData.article(MediaItemArticle article) = _ImagePrecacheDataArticle;

  factory ImagePrecacheData.topic(Topic topic) = _ImagePrecacheDataTopic;
}
