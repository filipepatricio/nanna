import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_with_background.dt.freezed.dart';

@Freezed(toJson: false)
class ArticleWithBackground with _$ArticleWithBackground {
  factory ArticleWithBackground.image(MediaItemArticle article, ArticleImage image) = _ArticleWithBackgroundImage;

  factory ArticleWithBackground.color(MediaItemArticle article, int colorIndex) = _ArticleWithBackgroundColor;
}
