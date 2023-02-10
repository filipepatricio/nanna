import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_precaching_view_state.dt.freezed.dart';

@freezed
class ImagePrecachingViewState with _$ImagePrecachingViewState {
  const factory ImagePrecachingViewState.initial() = _ImagePrecachingViewStateInitial;

  factory ImagePrecachingViewState.article(MediaItemArticle article) = _ImagePrecachingViewStateArticle;

  factory ImagePrecachingViewState.topic(Topic topic) = _ImagePrecachingViewStateTopic;
}
