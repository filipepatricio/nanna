class MediaItemScrollData {
  const MediaItemScrollData({
    required this.contentOffset,
    required this.readArticleContentOffset,
    required this.contentHeight,
  });

  factory MediaItemScrollData.initial() => const MediaItemScrollData(
        contentOffset: 0,
        contentHeight: 0,
        readArticleContentOffset: 0,
      );

  final double contentOffset;
  final double readArticleContentOffset;
  final double contentHeight;

  MediaItemScrollData copyWith({
    double? contentOffset,
    double? readArticleContentOffset,
    double? contentHeight,
  }) {
    return MediaItemScrollData(
      contentOffset: contentOffset ?? this.contentOffset,
      readArticleContentOffset: readArticleContentOffset ?? this.readArticleContentOffset,
      contentHeight: contentHeight ?? this.contentHeight,
    );
  }
}
