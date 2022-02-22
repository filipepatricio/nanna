import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_with_background.freezed.dart';

@freezed
class ArticleWithBackground with _$ArticleWithBackground {
  factory ArticleWithBackground.image(MediaItemArticle article, Image image) = _$ArticleWithBackgroundImage;

  factory ArticleWithBackground.color(MediaItemArticle article, int colorIndex) = _$ArticleWithBackgroundColor;
}
