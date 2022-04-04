import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleContentTypeDTOMapper implements Mapper<String, ArticleContentType> {
  @override
  ArticleContentType call(String data) {
    switch (data) {
      case 'HTML':
        return ArticleContentType.html;
      case 'MARKDOWN':
        return ArticleContentType.markdown;
      default:
        throw Exception('Unknown article content type: $data');
    }
  }
}
