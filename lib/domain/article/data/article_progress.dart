class ArticleProgress {
  ArticleProgress({
    required this.audioPosition,
    required this.audioProgress,
    required this.contentProgress,
  });

  final int audioPosition;
  final int audioProgress;
  final int contentProgress;

  ArticleProgress copyWith({
    int? audioPosition,
    int? audioProgress,
    int? contentProgress,
  }) {
    return ArticleProgress(
      audioPosition: audioPosition ?? this.audioPosition,
      audioProgress: audioProgress ?? this.audioProgress,
      contentProgress: contentProgress ?? this.contentProgress,
    );
  }
}
