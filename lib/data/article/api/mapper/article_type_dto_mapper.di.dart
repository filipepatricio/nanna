import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleTypeDTOMapper implements Mapper<String, ArticleType> {
  @override
  ArticleType call(String data) {
    switch (data) {
      case 'FREE':
        return ArticleType.free;
      case 'PREMIUM':
        return ArticleType.premium;
      default:
        throw Exception('Unknown article type: $data');
    }
  }
}
