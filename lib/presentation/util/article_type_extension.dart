import 'package:better_informed_mobile/domain/article/data/article.dt.dart';

extension ArticleTypeExt on ArticleType {
  bool get isPremium => this == ArticleType.premium;
}
