class AudioFileUnknownDurationException implements Exception {
  const AudioFileUnknownDurationException(this.url);

  final String url;

  @override
  String toString() {
    return '$runtimeType {url: $url}';
  }
}
