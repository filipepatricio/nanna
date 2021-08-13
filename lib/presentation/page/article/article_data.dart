/// TEMP ARTICLE UI DATACLASS
//TODO: CHECK AND MODIFY ACCORDING TO LOGIC IMPLEMENTATION
class ArticleData {
  final String title;
  final String content;
  final String publicationDate;
  final ArticleType type;
  final String timeToRead;
  final String sourceUrl;
  final String publisherName;
  final String authorName;
  final String photoText;

  ArticleData({
    required this.title,
    required this.content,
    required this.publicationDate,
    required this.type,
    required this.timeToRead,
    required this.sourceUrl,
    required this.publisherName,
    required this.authorName,
    required this.photoText,
  });
}

enum ArticleType { freemium, premium }
